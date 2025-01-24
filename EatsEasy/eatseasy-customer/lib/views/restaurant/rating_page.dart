import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/rating_controller.dart';
import 'package:eatseasy/hooks/fetchRating.dart';
import 'package:eatseasy/models/rating_response.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:eatseasy/models/sucess_model.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:eatseasy/views/search/seach_page.dart';
import 'package:get/get.dart';

class RatingPage extends HookWidget {
  const RatingPage({super.key, required this.restaurant});

  final Restaurants restaurant;
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRating("?product=${restaurant.id}&ratingType=Restaurant");
    SuccessResponse? ratingExistence = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    final controller = Get.put(RatingController());
    controller.rating = 3;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        title: ReusableText(
            text: "Rate ${restaurant.title} Restaurant",
          style: appStyle(20, kDark, FontWeight.w400),),
      ),
      body: Center(
        child: BackGroundContainer(
          child: isLoading
              ? const LoadingWidget()
              : ratingExistence!.status == false
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ReusableText(
                              text:
                                  "Tap the stars to rate the restaurant and submit",
                              style: appStyle(12, kGray, FontWeight.w600)),
                          SizedBox(
                            height: 20.h,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            itemSize: 55.r,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0.h),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              controller.updateRating(rating);
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomButton(
                              onTap: () {
                                Rating data = Rating(
                                    ratingType: "Restaurant",
                                    product: restaurant.id!,
                                    rating: controller.rating.toInt());

                                String rating = ratingToJson(data);

                                controller.addRating(rating, refetch);
                              },
                              radius: 6.r,
                              btnHieght: 30.h,
                              color: controller.isLoading ? kGray : kPrimary,
                              text: controller.isLoading ? "...submitting rating" : "Rate Restaurant",
                              btnWidth: width - 80.w),

                              SizedBox(height: 20.h,),



                               ReusableText(
                              text:
                                  "Tap the stars to rate the food and submit",
                              style: appStyle(12, kGray, FontWeight.w600)),
                          SizedBox(
                            height: 20.h,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            itemSize: 55.r,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0.h),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              controller.updateRating(rating);
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomButton(
                              onTap: () {
                                Rating data = Rating(
                                    ratingType: "Restaurant",
                                    product: restaurant.id!,
                                    rating: controller.rating.toInt());

                                String rating = ratingToJson(data);

                                controller.addRating(rating, refetch);
                              },
                              radius: 6.r,
                              btnHieght: 30.h,
                              color: controller.isLoading ? kGray : kPrimary,
                              text: controller.isLoading ? "...submitting rating" : "Rate Food",
                              btnWidth: width - 80.w)
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: 5,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.grey,
                            ),
                            itemCount: 5,
                            itemSize: 55.0,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ReusableText(
                              text: "You have already rated this restaurant",
                              style: appStyle(12, kGray, FontWeight.w400)),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
