import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:eatseasy/controllers/updates_controllers/cancelled_controller.dart';
import 'package:eatseasy/controllers/updates_controllers/delivered_controller.dart';
import 'package:eatseasy/controllers/updates_controllers/picked_controller.dart';
import 'package:eatseasy/controllers/updates_controllers/preparing_controller.dart';
import 'package:get/get.dart';

class UpdatesWidget extends StatelessWidget {
  const UpdatesWidget({super.key, required this.id});

  final String id;

  Stream<Map<String, dynamic>> userOrdersStream(String restaurantId) {
    DatabaseReference restaurantRef =
        FirebaseDatabase.instance.ref(restaurantId);

    return restaurantRef.onValue.map((event) {
      final orderData = event.snapshot.value as Map<dynamic, dynamic>;

      return Map<String, dynamic>.from(orderData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final preparingController = Get.put(PreparingController());
    final pickedController = Get.put(PickedController());
    final deliveredController = Get.put(DeliveredController());
    final cancelledController = Get.put(CancelledController());

    return StreamBuilder<Map<String, dynamic>>(
        stream: userOrdersStream(id),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // Show loading indicator while waiting for data
          }
          if (snapshot.hasError) {
            return const SizedBox(); // Handle errors from the stream
          }

          // The stream has data, so display the appropriate UI
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          String lastOrder = 'updated';
          String status = "none";

          Map<String, dynamic> orderData = snapshot.data!;
          if (lastOrder != orderData['order_id'] &&
              status != orderData['status']) {
            lastOrder = orderData['order_id'];
            status = orderData['status'];

            if (orderData['status'] == "Preparing" || orderData['status'] == "Ready") {
              preparingController.refetch.value = true;
              Future.delayed(
                const Duration(seconds: 6),
                () {
                  preparingController.refetch.value = false;
                },
              );
            } else if (orderData['status'] == "Out_for_Delivery") {
              pickedController.refetch.value = true;

              Future.delayed(
                const Duration(seconds: 6),
                () {
                  pickedController.refetch.value = false;
                },
              );
            } else if (orderData['status'] == "Delivered") {
              deliveredController.refetch.value = true;

              Future.delayed(
                const Duration(seconds: 6),
                () {
                  deliveredController.refetch.value = false;
                },
              );
            } else if (orderData['status'] == "Cancelled") {
              cancelledController.refetch.value = true;

              Future.delayed(
                const Duration(seconds: 6),
                () {
                  cancelledController.refetch.value = false;
                },
              );
            }
          }

          return const SizedBox.shrink();
        });
  }
}
