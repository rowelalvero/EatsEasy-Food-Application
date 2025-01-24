import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatseasy_admin/views/home/screens/cashout/widgets/cashout_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:eatseasy_admin/common/divida.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/status_controller.dart';
import 'package:eatseasy_admin/hooks/fetch_restaurant.dart';
import 'package:eatseasy_admin/views/restaurant/widgets/image_widget.dart';
import 'package:eatseasy_admin/views/restaurant/widgets/restaurant_error.dart';
import 'package:eatseasy_admin/views/restaurant/widgets/statistics.dart';
import 'package:eatseasy_admin/views/restaurant/widgets/status_buttons.dart';
import 'package:get/get.dart';

import '../../controllers/payout_controller.dart';

class RestaurantDetailsPage extends HookWidget {
  const RestaurantDetailsPage({super.key, required this.restaurantId});

  final String restaurantId;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatusController());
    final payoutController = Get.put(PayoutController()); // Add PayoutController instance
    payoutController.getRestaurantWithdrawalsStats(restaurantId);
    final data = fetchRestaurant(restaurantId);
    final restaurant = data.restaurant;
    final ordersTotal = data.ordersTotal;
    final cancelledOrders = data.cancelledOrders;
    final processingOrders = data.processingOrders;
    final revenueTotal = data.revenueTotal;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;
    controller.setData(data.refetch!);

    if (isLoading) {
      return const Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(child: BackGroundContainer(child: FoodsListShimmer()),),
          ));
    }
    if (error != null) {
      return Center(
        child: Text(error.toString()),
      );
    }

    if (restaurant == null) {
      return const RestaurantError();
    }

    return Scaffold(
      body: Scaffold(
        body: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: hieght * 0.1,
                  top: hieght * 0.05),
              child: BackGroundContainer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [

                      //ImageWidget(restaurant: restaurant),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20.r),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                    height: 230.h,
                                    child: Container(
                                      height: 230.h,
                                      width: width,
                                      color: kLightWhite,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:restaurant.logoUrl,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 40.h,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(
                                    Ionicons.chevron_back_circle,
                                    color: kPrimary,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ReusableText(
                            text: restaurant.title,
                            style: appStyle(20, kDark, FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            RatingBarIndicator(
                              rating: restaurant.rating.toDouble(),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: kPrimary,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ReusableText(
                                text: "${restaurant.ratingCount} ratings",
                                style: appStyle(9, kGray, FontWeight.w500)),
                          ],
                        ),
                      ),
                      StatusButtons(
                        restaurant: restaurant,
                        refetch: refetch,
                      ),
                      if (restaurant.verification == "Verified" || restaurant.verification == "Rejected") ...[
                        // Restaurant name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ReusableText(
                              text: "${restaurant.title} Statistics",
                              style: appStyle(12, kGray, FontWeight.w600)),
                        ),

                        //Restaurant Statistics
                        Statistics(
                          ordersTotal: ordersTotal,
                          cancelledOrders: cancelledOrders,
                          processingOrders: processingOrders,
                          revenueTotal: restaurant.earnings.toDouble(),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                  text: "Withdrawal History",
                                  style: appStyle(12, kGray, FontWeight.w600)),

                              // Payout History
                              Obx(() {
                                final stats = payoutController.restaurantStats;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        ReusableText(
                                            text: stats['totalWithdrawals']?.toString() ?? "0",
                                            style: appStyle(14, kGray, FontWeight.w600)),
                                        ReusableText(
                                            text: "Total Withdrawals",
                                            style: appStyle(10, kGray, FontWeight.normal)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ReusableText(
                                            text: stats['pendingWithdrawals']?.toString() ?? "0",
                                            style: appStyle(14, kGray, FontWeight.w600)),
                                        ReusableText(
                                            text: "Pending Withdrawals",
                                            style: appStyle(10, kGray, FontWeight.normal)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        ReusableText(
                                            text: stats['completedWithdrawals']?.toString() ?? "0",
                                            style: appStyle(14, kGray, FontWeight.w600)),
                                        ReusableText(
                                            text: "Completed Withdrawals",
                                            style: appStyle(10, kGray, FontWeight.normal)),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                      /*const Divida(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                      text: "Send Notifications",
                      style: appStyle(12, kGray, FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            AntDesign.bells,
                            color: kGrayLight,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(AntDesign.mail, color: kGrayLight)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(AntDesign.phone, color: kGrayLight)),
                    ],
                  ),
                ],
              ),
            ),

            const Divida(),*/
                      const Divida(),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                                text: "${restaurant.title} details",
                                style: appStyle(16, kDark, FontWeight.w600)),
                            const SizedBox(height: 10,),
                            RowText(first: "Owner name: ", second: restaurant.ownerName),
                            RowText(first: "Operational time: ", second: restaurant.time),
                            RowText(first: "Operational status: ", second: restaurant.isAvailable == true ? "Open" : "Closed"),
                            RowText(first: "Phone number: ", second: restaurant.phoneNumber),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                    text: "Business address: ",
                                    style: appStyle(11, kDark , FontWeight.w500)
                                ),
                                Expanded(  // Use Expanded to allow the text to take up available space
                                  child: Text(
                                    restaurant.coords.address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis, // Truncate long text with ellipsis
                                    style: appStyle(11, kGray, FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10,),
                            ReusableText(
                                text: "Uploaded credentials",
                                style: appStyle(16, kDark, FontWeight.w600)),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.r),
                                              child: Image.network(
                                                restaurant.image1Url,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 120,
                                      width: width / 2.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: kGrayLight),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network(
                                          restaurant.image1Url,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10), // Add spacing between the containers
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10.r),
                                              child: Image.network(
                                                restaurant.image2Url,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 120,
                                      width: width / 2.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: kGrayLight),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network(
                                          restaurant.image2Url,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            AntDesign.bells,
                            color: kGrayLight,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(AntDesign.mail, color: kGrayLight)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(AntDesign.phone, color: kGrayLight)),
                    ],
                  ),*/
                          ],
                        ),
                      ),
                    ],
                  )),)
        ),
      ),
    );
  }
}
