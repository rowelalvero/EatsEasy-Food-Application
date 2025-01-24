import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/search_results_controller.dart';
import 'package:eatseasy_admin/views/search/search_results.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantSearchController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Ionicons.chevron_back_circle,
              size: 40,
              color: kPrimary,
            )),
        title: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(
              color: kLightWhite,
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: kPrimary, width: 0.5)),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search Restuarants",
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              suffixIcon: GestureDetector(
                onTap: () {
                  controller.searchRestaurants(searchController.text);
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              prefixIcon: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Ionicons.close_circle_outline,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: kOffWhite,
        elevation: 0,
      ),
      body: const Center(child: BackGroundContainer(
        child: SearchResultsWidget(),
      ),)
    );
  }
}
