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
import 'package:eatseasy/models/client_orders.dart';
import 'package:eatseasy/models/rating_response.dart';
import 'package:eatseasy/models/sucess_model.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:eatseasy/views/search/seach_page.dart';
import 'package:get/get.dart';

import '../../models/order_details.dart';

class ReviewPage extends HookWidget {
  const ReviewPage({super.key, required this.order, required this.orders});

  final ClientOrders order;
  final DriverId orders;
  @override
  Widget build(BuildContext context) {
    final driverResult = useFetchRating("?product=${orders.id}&ratingType=Driver");
    final restaurantResult = useFetchRating("?product=${order.restaurantId}&ratingType=Restaurant");
    final foodResult = useFetchRating("?product=${order.orderItems[0].foodId.id}&ratingType=Food");

    SuccessResponse? restaurantExistence = restaurantResult.data;
    final isLoading = restaurantResult.isLoading;
    final refetch = restaurantResult.refetch;

    SuccessResponse? foodExistence = foodResult.data;
    final isFoodLoading = foodResult.isLoading;
    final refetchFood = foodResult.refetch;

    SuccessResponse? driverExistence = driverResult.data;
    final isDriverLoading = driverResult.isLoading;
    final refetchDriver = driverResult.refetch;

    final controller = Get.put(RatingController());
    controller.rating = 3;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        title: ReusableText(
            text: "Rate Restaurant and Food",
            style: appStyle(20, kGray, FontWeight.w400)),
      ),
      body: Center(
        child: BackGroundContainer(
            child: isLoading || isFoodLoading || isDriverLoading
                ? const LoadingWidget()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        driverExistence!.status == false
                            ? Column(
                          children: [
                            ReusableText(
                                text:
                                "Tap the stars to rate the restaurant and submit",
                                style:
                                appStyle(12, kGray, FontWeight.w600)),
                            const SizedBox(
                              height: 20,
                            ),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              itemSize: 55.r,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                controller.updateRating(rating);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                                onTap: () {
                                  Rating data = Rating(
                                      ratingType: "Driver",
                                      product: order.restaurantId,
                                      rating: controller.rating.toInt());

                                  String rating = ratingToJson(data);

                                  controller.addRating(rating, refetchDriver);
                                },
                                radius: 6.r,
                                btnHieght: 30,
                                color:
                                controller.isLoading ? kGray : kPrimary,
                                text: controller.isLoading
                                    ? "...submitting rating"
                                    : "Rate Driver",
                                btnWidth: width - 80),
                          ],
                        )
                            : const AlreadyRated(type: "driver"),

                        restaurantExistence!.status == false
                            ? Column(
                                children: [
                                  ReusableText(
                                      text:
                                          "Tap the stars to rate the restaurant and submit",
                                      style:
                                          appStyle(12, kGray, FontWeight.w600)),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    itemSize: 55.r,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0.h),
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
                                            product: order.restaurantId,
                                            rating: controller.rating.toInt());

                                        String rating = ratingToJson(data);

                                        controller.addRating(rating, refetch);
                                      },
                                      radius: 6.r,
                                      btnHieght: 30.h,
                                      color:
                                          controller.isLoading ? kGray : kPrimary,
                                      text: controller.isLoading
                                          ? "...submitting rating"
                                          : "Rate Restaurant",
                                      btnWidth: width - 80.w),
                                ],
                              )
                            : const AlreadyRated(type: "restaurant"),

                        foodExistence!.status == false
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  ReusableText(
                                      text:
                                          "Tap the stars to rate the food and submit",
                                      style:
                                          appStyle(12, kGray, FontWeight.w600)),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    itemSize: 55.r,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0.h),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      controller.updateFood(rating);
                                    },
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomButton(
                                      onTap: () {
                                        Rating data = Rating(
                                            ratingType: "Food",
                                            product:
                                                order.orderItems[0].foodId.id,
                                            rating:
                                                controller.foodRating.toInt());

                                        String rating = ratingToJson(data);

                                        controller.addRating(rating, refetchFood);
                                      },
                                      radius: 6.r,
                                      btnHieght: 30.h,
                                      color:
                                          controller.isLoading ? kGray : kPrimary,
                                      text: controller.isLoading
                                          ? "...submitting rating"
                                          : "Rate Food",
                                      btnWidth: width - 80.w),
                                ],
                              )
                            : const AlreadyRated(type: "food")
                      ],
                    ),
                  )),
      ),
    );
  }
}

class AlreadyRated extends StatelessWidget {
  const AlreadyRated({
    super.key,
    required this.type,
  });
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReusableText(
              text: "You have already rated this $type",
              style: appStyle(12, kGray, FontWeight.w600)),
          SizedBox(
            height: 20.h,
          ),
          RatingBarIndicator(
            rating: 5,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: kPrimary,
            ),
            itemCount: 5,
            itemSize: 55.r,
            direction: Axis.horizontal,
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
