// ignore_for_file: unrelated_type_equality_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../../common/app_style.dart';
import '../../../../common/back_ground_container.dart';
import '../../../../common/reusable_text.dart';
import '../../../../constants/constants.dart';
import '../../../../controllers/foods_controller.dart';
import '../../../../models/foods.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key, required this.food});

  final Food food;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodController = Get.put(FoodsController());

    return Scaffold(
        backgroundColor: kLightWhite,
        body: Center(
            child: Padding(padding: EdgeInsets.only(
                bottom: hieght * 0.1,
                top: hieght * 0.05
            ) ,child: BackGroundContainer(
                child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
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
                                    child: PageView.builder(
                                        itemCount: widget.food.imageUrl.length,
                                        controller: _pageController,
                                        onPageChanged: (i) {
                                          foodController.currentPage(i);
                                        },
                                        itemBuilder: (context, i) {
                                          return Container(
                                            height: 230.h,
                                            width: width,
                                            color: kLightWhite,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: widget.food.imageUrl[i],
                                            ),
                                          );
                                        }),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: Obx(
                                          () => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          widget.food.imageUrl.length,
                                              (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Container(
                                                margin: EdgeInsets.all(4.h),
                                                width:
                                                foodController.currentPage == index
                                                    ? 10
                                                    : 8,
                                                // ignore: unrelated_type_equality_checks
                                                height:
                                                foodController.currentPage == index
                                                    ? 10
                                                    : 8,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: foodController.currentPage ==
                                                      index
                                                      ? kSecondary
                                                      : kGrayLight,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ReusableText(
                                      text: widget.food.title,
                                      style: appStyle(18, kDark, FontWeight.w600)),
                                  ReusableText(
                                    text: 'Php ${widget.food.price.toStringAsFixed(2)}',
                                    style: appStyle(18, kGray, FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                widget.food.description,
                                maxLines: 8,
                                style: appStyle(11, kGray, FontWeight.w400),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              ReusableText(
                                  text: "Food Tags",
                                  style: appStyle(14, kDark, FontWeight.w600)),

                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                height: 15.h,
                                child: ListView.builder(
                                    itemCount: widget.food.foodTags.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, i) {
                                      final tag = widget.food.foodTags[i];
                                      return Container(
                                        margin: EdgeInsets.only(right: 5.h),
                                        decoration: BoxDecoration(
                                            color: kPrimary,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(15.r))),
                                        child: Center(
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: ReusableText(
                                                text: tag,
                                                style: appStyle(
                                                    10, kLightWhite, FontWeight.w400)),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              ReusableText(
                                  text: "Food Type",
                                  style: appStyle(14, kDark, FontWeight.w600)),

                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                height: 19.h,
                                child: ListView.builder(
                                  itemCount: widget.food.foodType.length, // Adjusted itemCount
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    final types = widget.food.foodType[i];
                                    SizedBox(
                                      width: 10.h,
                                    );
                                    return Container(
                                      height: 19.h,
                                      margin: EdgeInsets.only(right: 5.h),
                                      decoration: const BoxDecoration(
                                        color: kSecondary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),

                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: ReusableText(
                                              text: types!,
                                              style: appStyle(
                                                  10, kLightWhite, FontWeight.w400)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              ReusableText(
                                  text: "Custom Additives",
                                  style: appStyle(14, kDark, FontWeight.w600)),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.food.customAdditives.length,
                                itemBuilder: (context, index) {
                                  final question = widget.food.customAdditives[index];
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 9,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      question.text,
                                                      style: appStyle(16, kGray, FontWeight.w600),
                                                    ),
                                                  ],
                                                ),

                                                if (question.required)
                                                  Text(
                                                    'Required',
                                                    style: appStyle(15, kRed, FontWeight.w600),
                                                  ),
                                                if (question.type == 'Checkbox') ...[
                                                  if (question.selectionType == "Select at least" ||
                                                      question.selectionType == "Select at most" ||
                                                      question.selectionType == "Select exactly") ...[
                                                    Row(
                                                      children: [
                                                        Text('Condition: ',
                                                          style: appStyle(14, kGray, FontWeight.w600),),
                                                        Text('${question.selectionType} ${question.selectionNumber} options.',
                                                          style: appStyle(14, kGray, FontWeight.w400),),
                                                      ],
                                                    )
                                                  ],
                                                  if (question.customErrorMessage != null &&
                                                      question.customErrorMessage!.isNotEmpty)
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Custom error message: ',
                                                          style: appStyle(14, kGray, FontWeight.w600),),
                                                        Expanded(
                                                          child: Text('${question.customErrorMessage}',
                                                            maxLines: 4,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: appStyle(14, kGray, FontWeight.w400),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ],
                                                if (question.type == 'Multiple Choice' || question.type == 'Checkbox') ...[
                                                  ...question.options!.map((option) => Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                    child: Row(
                                                      children: [
                                                        if (question.type == 'Multiple Choice') ...[
                                                          Radio(
                                                            visualDensity: VisualDensity.compact,
                                                            value: option,
                                                            groupValue: null,
                                                            onChanged: null,
                                                          ),
                                                        ],
                                                        if (question.type == 'Checkbox') ...[
                                                          const Checkbox(
                                                            visualDensity: VisualDensity.comfortable,
                                                            value: false,
                                                            onChanged: null,
                                                          ),
                                                        ],
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(option.optionName.toString(),
                                                                style: appStyle(16, kGray, FontWeight.w600)),
                                                            SizedBox(width: 10.w,),
                                                            ReusableText(
                                                              text: 'Php ${option.price.toString()}',
                                                              style: appStyle(16, kGray, FontWeight.w600),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                                if (question.type == 'Linear Scale') ...[
                                                  Text(
                                                      'Scale: ${question.minScaleLabel} to ${question.maxScaleLabel}'),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: List.generate(
                                                      (question.maxScale! - question.minScale! + 1).toInt(),
                                                          (index) {
                                                        final scaleValue = question.minScale! + index;
                                                        return Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(scaleValue.toString(),
                                                                  style: const TextStyle(fontSize: 16)),
                                                              Radio(
                                                                value: scaleValue,
                                                                groupValue: null,
                                                                onChanged: null,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                                if (question.type == 'Paragraph') ...[
                                                  const Text(
                                                      'Paragraph response area will be here.'),
                                                ],
                                                if (question.type == 'Short Answer') ...[
                                                  const Text(
                                                      'Short answer response area will be here.'),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                )
            ),)
        )
    );
  }
}
