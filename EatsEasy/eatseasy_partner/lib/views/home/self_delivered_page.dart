import 'package:flutter/material.dart';
import 'package:eatseasy_partner/common/common_appbar.dart';
import 'package:eatseasy_partner/common/custom_appbar.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/views/home/restaurant_orders/self_deliveries.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';

class SelfDeliveredPage extends StatelessWidget {
  const SelfDeliveredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(titleText: "Self delivery orders"), /*AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: CustomAppBar(
          title: "View all internal deliveries and delivery earnings",
          heading: "Welcome EatsEasy",
        ),
        elevation: 0,
        backgroundColor: kLightWhite,
      ),*/
      body: const Center(child: BackGroundContainer(child: SelfDeliveries(),),)
    );
  }
}
