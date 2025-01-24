import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_rider/common/custom_app_bar.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/hooks/earningData.dart';
import 'package:eatseasy_rider/models/earning_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

// Example widget using the custom hook
class EarningData extends HookWidget {
  EarningData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchEarnings();
    final isLoading = hookResult.isLoading;
    final earningsData = hookResult.data;

    // State to track selected chart type
    final selectedChartType = useState<String>("Daily");

    if (isLoading) {
      return Scaffold(
        appBar: CommonAppBar(titleText: "Sales data"),
        body: Center(child: LoadingAnimationWidget.threeArchedCircle(
          color: kPrimary,
          size: 35,
        )),
      );
    }
    if (earningsData == null) {
      return Scaffold(
        appBar: CommonAppBar(titleText: "No earnings data"),
        body: const Center(child: Text("No earnings data available", style: TextStyle(color: kPrimary))),
      );
    }

    List<DailySalesData> data;

    if (selectedChartType.value == "Daily") {
      data = prepareDailyData(earningsData.dailyEarnings ?? []);
    } else if (selectedChartType.value == "Monthly") {
      data = prepareMonthlyData(earningsData.monthlyEarnings ?? []);
    } else {
      data = prepareWeeklyData(earningsData.weeklyEarnings ?? []);
    }

    return Scaffold(
      appBar: CommonAppBar(
        titleText: "Sales data",
        appBarActions: [
          DropdownButton<String>(
            dropdownColor: kOffWhite,
            value: selectedChartType.value,
            items: <String>['Daily', 'Monthly', 'Weekly']
                .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: kDark),
              ),
            ))
                .toList(),
            onChanged: (String? newValue) {
              selectedChartType.value = newValue!;
            },
          ),
        ],
      ),
      body: Center(child: BackGroundContainer(child: SingleChildScrollView(child: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(
                text: selectedChartType.value == "Daily"
                    ? "---Timeline"
                    : selectedChartType.value == "Monthly"
                    ? "---Months"
                    : "---Weeks",
              ),
              dateFormat: selectedChartType.value == "Daily"
                  ? DateFormat('yyyy-MM-dd')
                  : selectedChartType.value == "Monthly"
                  ? DateFormat('yyyy-MM')
                  : DateFormat('yyyy-MM-dd'),
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              intervalType: selectedChartType.value == "Daily"
                  ? DateTimeIntervalType.days
                  : selectedChartType.value == "Monthly"
                  ? DateTimeIntervalType.months
                  : DateTimeIntervalType.days,
              interval: selectedChartType.value == "Weekly" ? 7 : 1,
            ),
            title: ChartTitle(
                text: selectedChartType.value == "Daily"
                    ? 'Daily Sales Analysis'
                    : selectedChartType.value == "Monthly"
                    ? 'Monthly Sales Analysis'
                    : 'Weekly Sales Analysis'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<DailySalesData, DateTime>>[
              LineSeries<DailySalesData, DateTime>(
                dataSource: data,
                xValueMapper: (DailySalesData sales, _) => sales.date,
                yValueMapper: (DailySalesData sales, _) => sales.sales,
                name: 'Sales',
                xAxisName: "Time",
                yAxisName: "Amount",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),

          /*const Divider(),
          *//*Statistics(
            totalDeliveries: ordersTotal,
            cancelledDeliveries: cancelledOrders,
            activeDeliveries: processingOrders,
            revenueTotal: revenueTotal,
          ),*//*
          const Divider(),*/
        ],
      )))),
    );
  }
}

class DailySalesData {
  DailySalesData(this.date, this.sales);

  final DateTime date;
  final double sales;
}

List<DailySalesData> prepareDailyData(List<Earning> earnings) {
  return earnings.map((entry) => DailySalesData(
    DateTime(entry.year, entry.month!, entry.day!),
    entry.totalEarnings,
  )).toList();
}

List<DailySalesData> prepareMonthlyData(List<Earning> earnings) {
  return earnings.map((entry) => DailySalesData(
    DateTime(entry.year, entry.month!),
    entry.totalEarnings,
  )).toList();
}

List<DailySalesData> prepareWeeklyData(List<Earning> earnings) {
  if (earnings.isEmpty) {
    return [];
  }

  final List<DailySalesData> weeklySalesData = [];

  for (var entry in earnings) {
    // Calculate the date corresponding to the first day of the specified week
    DateTime firstDayOfWeek = DateTime(entry.year).add(Duration(days: (entry.week! - 1) * 7));

    // Add the total earnings to the list with the first day of the week as the date
    weeklySalesData.add(DailySalesData(firstDayOfWeek, entry.totalEarnings));
  }

  // Sort the entries by date
  weeklySalesData.sort((a, b) => a.date.compareTo(b.date));

  return weeklySalesData;
}

