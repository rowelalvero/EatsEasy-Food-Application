import 'package:flutter/material.dart';
import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class RestaurantError extends StatelessWidget {
  const RestaurantError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
      ),
      body: const BackGroundContainer(
        child: Center(
          child: Text("An error occured"),
        ),
      ),
    );
  }
}
