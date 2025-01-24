import 'package:eatseasy/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/controllers/order_controller.dart';
import 'package:eatseasy/views/entrypoint.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';

class PaymentFailed extends StatelessWidget {
  const PaymentFailed({super.key});

  @override
  Widget build(BuildContext context) {
 final orderController = Get.put(OrderController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            orderController.paymentUrl = '';
            Get.off(() =>  MainScreen());
          },
          child: const Icon(
            AntDesign.closecircleo,
            color: kDark,
          ),
        ),
      ),
      body: Center(
        child: BackGroundContainer(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/No.png",
              color: Colors.red,
            ),
            ReusableText(
                text: "Payment Failed",
                style: appStyle(28, kDark, FontWeight.bold))
          ],
        )),
      ),
    );
  }
}
