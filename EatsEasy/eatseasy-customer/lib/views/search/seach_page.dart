import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/views/search/resto_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/custom_container.dart';
import 'package:eatseasy/common/custom_textfield.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/search_controller.dart';
import 'package:eatseasy/views/search/search_results.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../common/app_style.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(FoodSearchController());
    return Obx(() => Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kOffWhite,
        centerTitle: true,
        title: Text("Search food", style: appStyle(20, kDark, FontWeight.w400)),
      ),

      body: Center(
        child: BackGroundContainer(
            child: ListView(
              children: [
                Center(  // Center widget ensures vertical alignment
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),  // Adjust vertical padding to achieve the best centering
                    child: CustomTextField(
                      controller: controller,
                      hintText: "Search for food",
                      keyboardType: TextInputType.text,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          searchController.searchFoods(controller.text);
                        },
                        child: Icon(
                          Ionicons.search_circle,
                          size: 36.h,
                          color: kPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                searchController.isLoading
                    ? const FoodsListShimmer()
                    :  searchController.foodSearchResults == null
                    ? const SizedBox.shrink()
                    : const SearchResults(),
              ],
            )),
      ),

    ));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))
      ),
      child: Padding(
        padding:  EdgeInsets.only(bottom: 180.0.h),
        child: LottieBuilder.asset("assets/anime/delivery.json", width: width, height: height/2,),
      ),
    );
  }
}
