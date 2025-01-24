import 'package:flutter/material.dart';
import 'package:eatseasy_partner/common/common_appbar.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:eatseasy_partner/views/home/widgets/food_list.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      appBar: CommonAppBar(titleText: "Foods"),
      body: Center(
        child: BackGroundContainer(
            child: ListView(
              children: const [
                FoodList(),
              ],
            )
        ),
      )
    );
  }
}
