import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_partner/common/common_appbar.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/updates_controllers/new_orders_controller.dart';
import 'package:eatseasy_partner/hooks/fetchRestaurantOrders.dart';
import 'package:eatseasy_partner/models/ready_orders.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesData extends HookWidget {
  const SalesData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewOrdersController());
    final hookResult = useFetchPicked("delivered");
    List<ReadyOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    // State to track selected chart type
    final selectedChartType = useState<String>("Daily");

    if (isLoading) {
      return Scaffold(
        appBar: CommonAppBar(titleText: "Sales data"),
        body: Center(child: LoadingAnimationWidget.threeArchedCircle(
          color: kPrimary,
            size: 35
        )),
      );
    }
    if(orders!.isEmpty){
      return Scaffold(
        appBar: CommonAppBar(titleText: "You don't have sales"),
        body: Center(child: LoadingAnimationWidget.threeArchedCircle(
          color: kPrimary,
            size: 35
        )),
      );
    }

    List<DailySalesData> data;
    if (selectedChartType.value == "Daily") {
      data = prepareDailyData(orders);
    } else if (selectedChartType.value == "Monthly") {
      data = prepareMonthlyData(orders);
    } else {
      data = prepareYearlyData(orders);
    }

    return Scaffold(
      appBar: CommonAppBar(
        titleText: "Sales data",
        appBarActions: [
          DropdownButton<String>(
            dropdownColor: kSecondary,
            value: selectedChartType.value,
            items: <String>['Daily', 'Monthly', 'Yearly']
                .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: kOffWhite),
              ),
            ))
                .toList(),
            onChanged: (String? newValue) {
              selectedChartType.value = newValue!;
            },
          ),
        ],
      ),
      body: Center(child: BackGroundContainer(child: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(
                text: selectedChartType.value == "Daily"
                    ? "---Timeline"
                    : selectedChartType.value == "Monthly"
                    ? "---Months"
                    : "---Years",
              ),
              dateFormat: selectedChartType.value == "Daily"
                  ? DateFormat('yyyy-MM-dd')
                  : selectedChartType.value == "Monthly"
                  ? DateFormat('yyyy-MM')
                  : DateFormat('yyyy'),
              // Change format based on selection
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              intervalType: selectedChartType.value == "Daily"
                  ? DateTimeIntervalType.days
                  : selectedChartType.value == "Monthly"
                  ? DateTimeIntervalType.months
                  : DateTimeIntervalType.years,
              // Change interval type based on selection
              interval: 1, // Set interval to 1 day, month, or year
            ),
            title: ChartTitle(
                text: selectedChartType.value == "Daily"
                    ? 'Daily Sales Analysis'
                    : selectedChartType.value == "Monthly"
                    ? 'Monthly Sales Analysis'
                    : 'Yearly Sales Analysis'),
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
        ],
      ),))
    );
  }
}

class DailySalesData {
  DailySalesData(this.date, this.sales);

  final DateTime date;
  final double sales;
}

List<DailySalesData> prepareDailyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(
          order.orderDate!.year, order.orderDate!.month, order.orderDate!.day);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

List<DailySalesData> prepareMonthlyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(order.orderDate!.year, order.orderDate!.month);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

List<DailySalesData> prepareYearlyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(order.orderDate!.year);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}
