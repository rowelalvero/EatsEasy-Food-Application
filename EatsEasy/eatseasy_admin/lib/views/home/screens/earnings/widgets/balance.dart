import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/constants.dart';
import '../../../../../controllers/admin_earnings_controller.dart';
import '../../../../../controllers/constant_controller.dart';

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    final ConstantController controller = Get.put(ConstantController());
    controller.getConstants();
    final earningsController = Get.put(EarningsController());
    earningsController.fetchEarnings(controller.constants.value.commissionRate);
     // Fetch the current constants when the page loads
    return Obx(() => Center(
        child: earningsController.isLoading
            ? const CircularProgressIndicator()
            : earningsController.earnings == null
            ? const Text('No earnings data available')
            : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child:
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text('Earnings', style: TextStyle(color: Colors.white, fontSize: 14)),
                                    const SizedBox(height: 5),
                                    earningsController.earnings == null ?
                                    const Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)) :
                                    Text('Php ${earningsController.earnings!.commission.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                IconButton(onPressed: () {
                                  controller.getConstants();
                                  earningsController.fetchEarnings(controller.constants.value.commissionRate);
                                }, icon: Icon(Icons.refresh), color: Colors.white,)
                              ],
                            )
                        ),
                      )
                  ),
                ],
              ),
            ])));
  }
}
