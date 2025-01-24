import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/home_tile.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/home_controller.dart';
import 'package:eatseasy_admin/views/home/screens/more/more_page.dart';
import 'package:get/get.dart';

class HomeTilesHolder extends StatelessWidget {
  const HomeTilesHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: width,
        decoration: BoxDecoration(
            color: kOffWhite, borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 40,
            child: GridView.builder(
              scrollDirection: Axis.horizontal, // Add this line
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Set crossAxisCount to 1 for horizontal scrolling
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                final tile = tiles[index];
                return HomeTile(
                  imagePath: tile['imagePath'],
                  text: tile['title'],
                  onTap: () {
                    controller.updatePage = tile['title'];
                    controller.updateImage = tile['imagePath'];
                  },
                );
              },
            ),
          )

        ),
      ),
    );
  }
}

