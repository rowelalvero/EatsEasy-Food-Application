// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/divida.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/show_snack_bar.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/address_controller.dart';
import 'package:eatseasy/controllers/location_controller.dart';
import 'package:eatseasy/models/distance_time.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:eatseasy/services/distance.dart';
import 'package:eatseasy/views/auth/login_page.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:eatseasy/views/restaurant/directions_page.dart';
import 'package:eatseasy/views/restaurant/rating_page.dart';
import 'package:eatseasy/views/restaurant/widgets/explore.dart';
import 'package:eatseasy/views/restaurant/widgets/menu.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glass/glass.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key, required this.restaurant});

  final Restaurants restaurant;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> with TickerProviderStateMixin {
  late TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  final box =  GetStorage();
  final controller = Get.put(AddressController());
  final location = Get.put(UserLocationController());
  String accessToken = "";
  DistanceTime? distanceTime;
  double totalTime = 30;
  @override
  void initState() {
    super.initState();
    _fetchDistance();
  }

  Future<void> _fetchDistance() async {
    Distance distanceCalculator = Distance();
    distanceTime = await distanceCalculator.calculateDistanceDurationPrice(
        controller.defaultAddress!.latitude,
        controller.defaultAddress!.longitude,
        widget.restaurant.coords.latitude,
        widget.restaurant.coords.longitude,
        35,
        pricePkm
    );
    setState(() {
      totalTime += distanceTime!.time;
    }); // Update the UI with fetched data
  }
  @override
  Widget build(BuildContext context) {

    String? token = box.read('token');

    /*if (controller.defaultAddress != null && token != null) {
       accessToken = jsonDecode(token);
       distanceTime = Distance().calculateDistanceDurationPrice(
          controller.defaultAddress!.latitude,
          controller.defaultAddress!.longitude,
          widget.restaurant.coords.latitude,
          widget.restaurant.coords.longitude,
           35,
           deliveryFee);
    } else{
      distanceTime = Distance().calculateDistanceDurationPrice(
          location.currentLocation.latitude,
          location.currentLocation.longitude,
          widget.restaurant.coords.latitude,
          widget.restaurant.coords.longitude,
          35,
          deliveryFee);
    }*/



    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: kLightWhite,
          body: Center(
            child: Padding(padding: EdgeInsets.only(
                bottom: height * 0.1,
                top: height * 0.05
            ) , child: BackGroundContainer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
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
                                        imageUrl: widget.restaurant.imageUrl!),
                                  )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 230.h,
                          width: width,
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.restaurant.imageUrl!),
                        ),

                        Positioned(
                          left: 0,
                          right: 0,
                          child: RestaurantTopBar(
                            title: widget.restaurant.title!,
                            restaurant: widget.restaurant,
                          ),
                        ),
                        /*Positioned(
                    right: 5,
                    top: 6.h,
                    child: Container(
                      width: 60.h,
                      height: 19.h,
                      decoration: BoxDecoration(
                          color: widget.restaurant.isAvailable == true ||
                              widget.restaurant.isAvailable == null
                              ? kPrimary
                              : kSecondaryLight,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Center(
                        child: ReusableText(
                          text: widget.restaurant.isAvailable == null ||
                              widget.restaurant.isAvailable == true
                              ? "OPEN"
                              : "CLOSED",
                          style: appStyle(12, kLightWhite, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),*/
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      height: 100.h,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableText(
                              text: widget.restaurant.title!,
                              style: appStyle(18, kDark, FontWeight.w600)),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: widget.restaurant.rating,
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
                                  text: "${widget.restaurant.ratingCount} ratings",
                                  style: appStyle(9, kGray, FontWeight.w500)
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RowText(
                              first: "Distance To Restaurant",
                              second: distanceTime != null
                                  ? "${distanceTime!.distance.toStringAsFixed(1)} km"
                                  : "Loading..."),
                          SizedBox(
                            height: 10.h,
                          ),
                          RowText(
                              first: "Delivery Price From Current Location",
                              second: distanceTime != null
                                  ? "Php ${distanceTime!.price.toStringAsFixed(2)}"
                                  : "Loading..."),

                          SizedBox(
                            height: 10.h,
                          ),
                          RowText(
                              first: "Estimated Delivery Time to Current Location",
                              second: distanceTime != null
                                  ? "${"${totalTime.toStringAsFixed(0)} - ${(totalTime + distanceTime!.time).toStringAsFixed(0)}" } mins."
                                  : "Loading..."),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        height: 25.h,
                        width: MediaQuery.of(context).size.width,
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelPadding: EdgeInsets.zero,
                          labelColor: Colors.white,
                          dividerColor: Colors.transparent,
                          labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                          unselectedLabelColor: Colors.grey.withOpacity(0.7),
                          tabs:  <Widget>[
                            Tab(
                              child: SizedBox(
                                width:MediaQuery.of(context).size.width/2,
                                //margin: EdgeInsets.only(left: 20, right: 20),
                                height: 25,
                                child: const Center(child: Text("Menu")),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                width:MediaQuery.of(context).size.width/2,
                                height: 25,

                                child: const Center(child: Text("Explore")),
                              ),
                            )
                          ],
                        ),
                      ).asGlass(
                          tintColor: kPrimary,
                          clipBorderRadius: BorderRadius.circular(19.0),
                          blurX: 8,
                          blurY: 8),
                    ),

                    SizedBox(
                        height: height / 1.2,
                        child: TabBarView(controller: _tabController, children: [
                          RestaurantMenu(
                            restaurant: widget.restaurant,
                          ),
                          Explore(restaurant: widget.restaurant)
                        ]))
                  ],
                )
            ),)
          )
      ),
    );
  }
}

class RestaurantRatingBar extends StatelessWidget {
  const RestaurantRatingBar({
    super.key,
    required this.restaurant,
  });

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read("token");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35.h,
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r), topRight: Radius.circular(6.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingBarIndicator(
              rating: restaurant.rating.toDouble(),
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              itemCount: 5,
              itemSize: 25.0,
              direction: Axis.horizontal,
            ),
            CustomButton(
              onTap: () {
                if (token == null) {
                  Get.to(() => const Login());
                } else {
                  Get.to(() => RatingPage(
                        restaurant: restaurant,
                      ));
                }
              },
              text: "Rate Restaurant",
              btnWidth: width / 3,
            )
          ],
        ),
      ),
    );
  }
}

class RestaurantTopBar extends StatelessWidget {
  const RestaurantTopBar({
    super.key,
    required this.title,
    required this.restaurant,
  });

  final String title;
  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(12.w, 30.h, 12.w, 0.h),
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
              size: 38,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(10)
              ),
              child: ReusableText(
                  text: title, style: appStyle(14, kOffWhite, FontWeight.w500)),
            ),
          ),
          /*GestureDetector(
            onTap: () {
              Get.to(() => RestaurantRatingBar(
                restaurant: restaurant,
              ));
            },
            child: const Icon(
              Feather.star,
              color: kLightWhite,
              size: 38,
            ),
          ),*/
          GestureDetector(
            onTap: () {
              Get.to(() => DirectionsPage(
                    restaurant: restaurant,
                  ));
            },
            child: const Icon(
              Feather.map_pin,
              color: kLightWhite,
              size: 38,
            ),
          )
        ],
      ),
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.first,
    required this.second,
  });

  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(text: first, style: appStyle(10, kGray, FontWeight.w500)),
        Flexible(
            child: Text(second,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: appStyle(10, kGray, FontWeight.w400)))
      ],
    );
  }
}
