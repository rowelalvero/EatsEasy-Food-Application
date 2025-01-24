import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/restaurant_data.dart';
import 'package:get/get.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.restaurant,
  });

  final Data? restaurant;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(restaurant!.imageUrl),
                  fit: BoxFit.cover)),
        ),
        Positioned(
            top: 50,
            left: 10,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Ionicons.chevron_back_circle,
                color: kLightWhite,
              ),
            )),
        Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: 30,
              decoration: const BoxDecoration(
                color: kLightWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ))
      ],
    );
  }
}
