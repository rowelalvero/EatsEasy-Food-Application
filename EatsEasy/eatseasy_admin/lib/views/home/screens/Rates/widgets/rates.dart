import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/app_style.dart';
import '../../../../../common/custom_btn.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';
import '../../../../../controllers/constant_controller.dart';

class Rates extends StatelessWidget {
  const Rates({super.key});

  @override
  Widget build(BuildContext context) {
    final ConstantController controller = Get.put(ConstantController());
    controller.getConstants(); // Fetch the current constants when the page loads

    // Create TextEditingControllers to manage the input fields
    TextEditingController commissionController = TextEditingController();
    TextEditingController driverBaseController = TextEditingController();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          // Set the initial values for the text fields when the constants are fetched
          commissionController.text = controller.constants.value.commissionRate.toStringAsFixed(2);
          driverBaseController.text = controller.constants.value.driverBaseRate.toStringAsFixed(2);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                    text: 'Commission Rate:',
                    style: appStyle(20, kDark, FontWeight.w400)),
                TextField(
                  controller: commissionController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter commission rate',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Optional: Handle any additional logic when the user changes the input
                  },
                ),
                const SizedBox(height: 10),
                ReusableText(
                    text: 'Driver Base Rate:',
                    style: appStyle(20, kDark, FontWeight.w400)),
                TextField(
                  controller: driverBaseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter driver base rate',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Optional: Handle any additional logic when the user changes the input
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    // Validate and send updated constants to the backend
                    double commissionRate = double.tryParse(commissionController.text) ?? 10.00; // Default to 10 if invalid
                    double driverBaseRate = double.tryParse(driverBaseController.text) ?? 20.00; // Default to 20 if invalid

                    // Update the constants in the backend
                    controller.updateConstants(commissionRate: commissionRate, driverBaseRate: driverBaseRate);
                  },
                  text: 'Update rates',
                  color: kPrimary,
                  radius: 0,
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
