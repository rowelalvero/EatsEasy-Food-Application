import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class FinishedOrders extends StatelessWidget {
  const FinishedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Orders'),
        backgroundColor: kOffWhite,
        elevation: 0.4,
      ),
      body: const Center(child: BackGroundContainer(child: Center(
        child: Text('Finished Orders'),
      )),)
    );
  }
}