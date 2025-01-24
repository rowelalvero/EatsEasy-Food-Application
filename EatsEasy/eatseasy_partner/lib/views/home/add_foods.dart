// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:eatseasy_partner/views/home/widgets/add_question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/common_appbar.dart';
import 'package:eatseasy_partner/common/custom_btn.dart';
import 'package:eatseasy_partner/common/description.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/common/row_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/Image_upload_controller.dart';
import 'package:eatseasy_partner/controllers/foods_controller.dart';
import 'package:eatseasy_partner/controllers/restaurant_controller.dart';
import 'package:eatseasy_partner/models/foods.dart';
import 'package:eatseasy_partner/models/foods_request.dart';
import 'package:eatseasy_partner/views/auth/widgets/email_textfield.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:eatseasy_partner/views/home/widgets/is_available_switch.dart';
import 'package:eatseasy_partner/views/home/widgets/more_categories.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/counter_controller.dart';

class AddFoodsPage extends StatefulWidget {
  const AddFoodsPage({super.key, this.food, this.update});
  final bool? update;
  final Food? food;

  @override
  State<AddFoodsPage> createState() => _AddFoodsPageState();
}

class _AddFoodsPageState extends State<AddFoodsPage> {
  final imageUploader = Get.put(ImageUploadController());
  final foodsController = Get.put(FoodsController());
  final restaurantController = Get.put(RestaurantController());
  final CounterController counterController = Get.put(CounterController());

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _tags = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _counter = TextEditingController();
  String? selectedPrepTime;  // For the selected preparation time
  List<String> prepTimes = ['5', '10', '15', '20', '30', '45', '60']; // List of numeric preparation times

  final PageController _pageController = PageController();

  bool isButtonPressed = false;
  List<CustomAdditives> questions = [];
  final bool _isChecked = false;
  bool isFoodEnabled = false;

  @override
  void dispose() {
    _pageController.dispose();
    // Optional: Clear values if you want a fresh state each time
    foodsController.customAdditives.clear();
    imageUploader.images.clear();
    foodsController.type.clear();
    foodsController.customAdditives.clear();
    foodsController.tags.clear();
    //widget.food!.imageUrl.clear();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    if(widget.update == true) {
      counterController.count.value = widget.food!.stocks!;
      _counter.text = counterController.count.toString();
      _title = TextEditingController(text: widget.food?.title);
      _price = TextEditingController(text: widget.food?.price.toStringAsFixed(2));
      selectedPrepTime = widget.food?.time;  // Initialize with the existing preparation time
      _description = TextEditingController(text: widget.food?.description);


      if(widget.food?.category != null) {
        foodsController.category = widget.food!.category!;
      }

      if (widget.food!.imageUrl.isNotEmpty) {
        for (var i = 0; i < widget.food!.imageUrl.length && i < 4; i++) {
          imageUploader.images.add(widget.food!.imageUrl[i]);
          print(imageUploader.images);
        }
      }

      if(widget.food?.customAdditives != null) {
        foodsController.customAdditives.addAll(widget.food!.customAdditives);
      }
      if (widget.food?.foodType != null) {
        // Filter out null values before adding to the controller
        foodsController.type.addAll(widget.food?.foodType.whereType<String>() ?? []);
      }
      if (widget.food?.foodTags != null) {
        foodsController.tags.addAll(widget.food!.foodTags);
      }
    } else {
      _counter.text = counterController.count.toString();
    }
  }

  void _editQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AddQuestionDialog(
          question: foodsController.customAdditives[index],
          onAdd: (question) {
            setState(() {
              foodsController.customAdditives[index] = question;
            });
          },
        );
      },
    );
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) {
        return AddQuestionDialog(
          onAdd: (question) {
            setState(() {
              _saveQuestions(question);
            });
          },
        );
      },
    );
  }

  void _saveQuestions(CustomAdditives question) {
    setState(() {
      foodsController.customAdditives.add(question);
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      foodsController.customAdditives.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CommonAppBar(titleText: widget.update == true ? widget.food?.title : "Add custom food"),
      body: Center(
          child: BackGroundContainer(
              child: PageView(
                controller: _pageController,
                pageSnapping: false,
                children: [
                  SizedBox(
                    height: hieght,
                    child: AllCategories(
                      next: () {
                        _pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        ReusableText(
                          text: "Upload Images",
                          style: appStyle(16, kGray, FontWeight.w600),
                        ),
                        ReusableText(
                          text:
                          "You are required to upload a minimum of two images",
                          style: appStyle(11, kGray, FontWeight.normal),
                        ),

                        SizedBox(
                          height: 20.h,
                        ),

                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //imageUploader.pickImage("one");
                                },
                                child: Badge(
                                  backgroundColor: Colors.transparent,

                                  label: Obx(
                                        () => imageUploader.imageOneUrl.isNotEmpty
                                        ? GestureDetector(
                                      onTap: () {
                                        imageUploader.imageOneUrl = '';

                                      },
                                      child: const Icon(Icons.remove_circle, color: kRed),
                                    ) : Container(),
                                  ),

                                  child: Container(
                                      height: 120.h,
                                      width: width / 2.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: kGrayLight),
                                      ),
                                      child: widget.update == true &&
                                          widget.food != null &&
                                          widget.food!.imageUrl.isNotEmpty
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network(
                                          widget.food!.imageUrl[0],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : Obx(
                                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "one"
                                            ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              LoadingAnimationWidget.threeArchedCircle(
                                                  color: kSecondary,
                                                  size: 35
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                                style: appStyle(16, kDark, FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        )
                                            : imageUploader.imageOneUrl.isEmpty
                                            ? Center(
                                          child: IconButton(
                                            onPressed: () {
                                              imageUploader.pickImage("one");
                                            },
                                            icon: const Icon(Icons.file_upload_outlined),
                                            iconSize: 40.0, // Set the size of the icon
                                            color: kPrimary, // Set the color of the icon
                                            padding: const EdgeInsets.all(8.0), // Adjust the padding
                                            splashColor: kPrimary, // Change the splash effect color when pressed
                                            tooltip: 'Upload file', // Tooltip for accessibility
                                          ),

                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: Image.network(
                                            imageUploader.imageOneUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //imageUploader.pickImage("one");
                                },
                                child: Badge(
                                  backgroundColor: Colors.transparent,

                                  label: Obx(
                                        () => imageUploader.imageTwoUrl.isNotEmpty
                                        ? GestureDetector(
                                      onTap: () {
                                        imageUploader.imageTwoUrl = '';

                                      },
                                      child: const Icon(Icons.remove_circle, color: kRed),
                                    ) : Container(),
                                  ),

                                  child: Container(
                                      height: 120.h,
                                      width: width / 2.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: kGrayLight),
                                      ),
                                      child: widget.update == true &&
                                          widget.food != null &&
                                          widget.food!.imageUrl.isNotEmpty
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network(
                                          widget.food!.imageUrl[1],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : Obx(
                                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "two"
                                            ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              LoadingAnimationWidget.threeArchedCircle(
                                                  color: kSecondary,
                                                  size: 35
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                                style: appStyle(16, kDark, FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        )
                                            : imageUploader.imageTwoUrl.isEmpty
                                            ? Center(
                                          child: IconButton(
                                            onPressed: () {
                                              imageUploader.pickImage("two");
                                            },
                                            icon: const Icon(Icons.file_upload_outlined),
                                            iconSize: 40.0, // Set the size of the icon
                                            color: kPrimary, // Set the color of the icon
                                            padding: const EdgeInsets.all(8.0), // Adjust the padding
                                            splashColor: kPrimary, // Change the splash effect color when pressed
                                            tooltip: 'Upload file', // Tooltip for accessibility
                                          ),

                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: Image.network(
                                            imageUploader.imageTwoUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //add spacer
                        SizedBox(
                          height: 20.h,
                        ),

                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //imageUploader.pickImage("one");
                                },
                                child: Badge(
                                  backgroundColor: Colors.transparent,

                                  label: Obx(
                                        () => imageUploader.imageThreeUrl.isNotEmpty
                                        ? GestureDetector(
                                      onTap: () {
                                        imageUploader.imageThreeUrl = '';

                                      },
                                      child: const Icon(Icons.remove_circle, color: kRed),
                                    ) : Container(),
                                  ),

                                  child: Container(
                                      height: 120.h,
                                      width: width / 2.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: kGrayLight),
                                      ),
                                      child: widget.update == true &&
                                          widget.food != null &&
                                          widget.food!.imageUrl.isNotEmpty &&
                                          widget.food!.imageUrl.length > 2
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network(
                                          widget.food!.imageUrl[2],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : Obx(
                                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "three"
                                            ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              LoadingAnimationWidget.threeArchedCircle(
                                                  color: kSecondary,
                                                  size: 35
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                                style: appStyle(16, kDark, FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        )
                                            : imageUploader.imageThreeUrl.isEmpty
                                            ? Center(
                                          child: IconButton(
                                            onPressed: () {
                                              imageUploader.pickImage("three");
                                            },
                                            icon: const Icon(Icons.file_upload_outlined),
                                            iconSize: 40.0, // Set the size of the icon
                                            color: kPrimary, // Set the color of the icon
                                            padding: const EdgeInsets.all(8.0), // Adjust the padding
                                            splashColor: kPrimary, // Change the splash effect color when pressed
                                            tooltip: 'Upload file', // Tooltip for accessibility
                                          ),

                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: Image.network(
                                            imageUploader.imageThreeUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //imageUploader.pickImage("one");
                                },
                                child: Badge(
                                  backgroundColor: Colors.transparent,

                                  label: Obx(
                                        () => imageUploader.imageFourUrl.isNotEmpty
                                        ? GestureDetector(
                                      onTap: () {
                                        imageUploader.imageFourUrl = '';

                                      },
                                      child: const Icon(Icons.remove_circle, color: kRed),
                                    ) : Container(),
                                  ),

                                  child: Container(
                                      height: 120.h,
                                      width: width / 2.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: kGrayLight),
                                      ),
                                      child: widget.update == true &&
                                          widget.food != null &&
                                          widget.food!.imageUrl.isNotEmpty &&
                                          widget.food!.imageUrl.length > 3
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network(
                                          widget.food!.imageUrl[3],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : Obx(
                                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "four"
                                            ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              LoadingAnimationWidget.threeArchedCircle(
                                                  color: kSecondary,
                                                  size: 35
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                                style: appStyle(16, kDark, FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        )
                                            : imageUploader.imageFourUrl.isEmpty
                                            ? Center(
                                          child: IconButton(
                                            onPressed: () {
                                              imageUploader.pickImage("four");
                                            },
                                            icon: const Icon(Icons.file_upload_outlined),
                                            iconSize: 40.0, // Set the size of the icon
                                            color: kPrimary, // Set the color of the icon
                                            padding: const EdgeInsets.all(8.0), // Adjust the padding
                                            splashColor: kPrimary, // Change the splash effect color when pressed
                                            tooltip: 'Upload file', // Tooltip for accessibility
                                          ),

                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: Image.network(
                                            imageUploader.imageFourUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20.h,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              btnWidth: 150,
                              text: "B A C K",
                              color: kPrimary,
                              onTap: () {
                                _pageController.previousPage(
                                    duration:
                                    const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut);
                              },
                            ),
                            SizedBox(
                              width: 20.h,
                            ),
                            CustomButton(
                              btnWidth: 150,
                              text: "N E X T",
                              color: kPrimary,
                              onTap: () {
                                if(imageUploader.images.length > 1 || widget.food!.imageUrl.length > 1){
                                  _pageController.animateToPage(2,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Obx(
                          () => ListView(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          ReusableText(
                            text: "Add Details",
                            style: appStyle(16, kGray, FontWeight.w600),
                          ),
                          ReusableText(
                            text:
                            "You are required fill all the details fully with the correct information",
                            style: appStyle(11, kGray, FontWeight.normal),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          EmailTextField(
                            hintText: "Title",
                            controller: _title,
                            prefixIcon: Icon(
                              Ionicons.text,
                              color: Theme.of(context).dividerColor,
                              size: 20.h,
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          DescriptionField(
                            hintText: "Description of the food item ",
                            controller: _description,
                            maxLines: 4,
                            prefixIcon: Icon(
                              Ionicons.time_outline,
                              color: Theme.of(context).dividerColor,
                              size: 20.h,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          DropdownButtonFormField<String>(
                            hint: const Text("Preparation time"),
                            value: selectedPrepTime,
                            items: prepTimes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('$value min'), // Display "min" in the dropdown
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Ionicons.time_outline,
                                color: Theme.of(context).dividerColor,
                                size: 20.h,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(0),

                              hintStyle: appStyle(12, kGray, FontWeight.normal),
                              // contentPadding: EdgeInsets.only(left: 24),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimary, width: 0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kGray, width: 0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: kGray, width: 0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimary, width: 0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPrepTime = newValue;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          EmailTextField(
                            hintText: "Price",
                            controller: _price,
                            prefixIcon: Icon(
                              Feather.dollar_sign,
                              color: Theme.of(context).dividerColor,
                              size: 20.h,
                            ),
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.none,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ReusableText(
                            text: "Add FoodType",
                            style: appStyle(16, kGray, FontWeight.w600),
                          ),
                          ReusableText(
                            text:
                            "Enter food type e.g., Fruits, Vegetables, Sugars, Sweets, Beverages, Dairy, Fats, Oils",
                            style: appStyle(11, kGray, FontWeight.normal),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          EmailTextField(
                            hintText: "Food type",
                            controller: _type,
                            prefixIcon: Icon(
                              Ionicons.text,
                              color: Theme.of(context).dividerColor,
                              size: 20.h,
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),

                          foodsController.type.isNotEmpty
                              ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  foodsController.type.length, (index) {
                                return Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.r))),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: ReusableText(
                                              text:
                                              foodsController.type[index],
                                              style: appStyle(10, kLightWhite,
                                                  FontWeight.w400)),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            foodsController.type.removeAt(index);
                                          },
                                          child: Icon(
                                            Ionicons.remove_circle_outline,
                                            color: kWhite,
                                            size: 20.h,
                                          ),
                                        ),
                                      ],
                                    )
                                );
                              }),
                            ),
                          )
                              : const SizedBox.shrink(),
                          SizedBox(
                            height: 20.h,
                          ),

                          CustomButton(
                            text: "A D D    T Y P E",
                            btnHieght: 40,
                            onTap: () {
                              if (_type.text.isNotEmpty) {
                                foodsController.type.add(_type.text);

                                _type.clear();
                              } else {
                                Get.snackbar(
                                  "Error", "Please enter a valid value.",);
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                btnWidth: 145,
                                text: "B A C K",
                                color: kPrimary,
                                onTap: () {
                                  _pageController.previousPage(
                                      duration:
                                      const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                },
                              ),
                              SizedBox(
                                width: 20.h,
                              ),
                              CustomButton(
                                btnWidth: 145,
                                text: "N E X T",
                                color: kPrimary,
                                onTap: () {
                                  _pageController.nextPage(
                                      duration:
                                      const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Obx(() =>
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                ReusableText(
                                  text: "Add custom additives",
                                  style: appStyle(16, kGray, FontWeight.w600),
                                ),
                                ReusableText(
                                  text:
                                  "Create your custom additives for your food item.",
                                  style: appStyle(11, kGray, FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: foodsController.customAdditives.length,
                                  itemBuilder: (context, index) {
                                    final question = foodsController.customAdditives[index];
                                    return Container(
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
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(Icons.edit),
                                                            onPressed: () => _editQuestion(index),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                                                            onPressed: () => _removeQuestion(index),
                                                          ),
                                                        ],
                                                      )
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
                                                            Checkbox(
                                                              visualDensity: VisualDensity.comfortable,
                                                              value: _isChecked,
                                                              onChanged: null,
                                                            ),
                                                          ],
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(option.optionName.toString(),
                                                                  style: appStyle(16, kGray, FontWeight.w600)),
                                                              SizedBox(width: 10.w,),
                                                              Text('Php ${option.price.toString()}',
                                                                  style: appStyle(16, kGray, FontWeight.w600)),
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
                                SizedBox(
                                  height: 20.h,
                                ),

                                CustomButton(
                                  text: "A D D    A D D I T I V E",
                                  btnHieght: 40,
                                  onTap: () {
                                    _addQuestion();
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomButton(
                                      btnWidth: 145,
                                      text: "B A C K",
                                      color: kPrimary,
                                      onTap: () {
                                        _pageController.previousPage(
                                            duration:
                                            const Duration(milliseconds: 400),
                                            curve: Curves.easeInOut);
                                      },
                                    ),
                                    SizedBox(
                                      width: 20.h,
                                    ),
                                    CustomButton(
                                      btnWidth: 145,
                                      text: "N E X T",
                                      color: kPrimary,
                                      onTap: () {
                                        _pageController.nextPage(
                                            duration:
                                            const Duration(milliseconds: 400),
                                            curve: Curves.easeInOut);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ),
                      )
                  ),

                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Obx(
                            () => ListView(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            ReusableText(
                              text: "Add Tags",
                              style: appStyle(16, kGray, FontWeight.w600),
                            ),
                            ReusableText(
                              text:
                              "Enter food tags to easily search your food item.",
                              style: appStyle(11, kGray, FontWeight.normal),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            EmailTextField(
                              hintText: "Tag title",
                              controller: _tags,
                              prefixIcon: Icon(
                                Ionicons.text,
                                color: Theme.of(context).dividerColor,
                                size: 20.h,
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            foodsController.tags.isNotEmpty
                                ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
                              child: Row(
                                children: List.generate(
                                  foodsController.tags.length,
                                      (index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.r),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: ReusableText(
                                              text: foodsController.tags[index],
                                              style: appStyle(
                                                10,
                                                kLightWhite,
                                                FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Remove the tag at the given index
                                              foodsController.tags.removeAt(index);
                                            },
                                            child: Icon(
                                              Ionicons.remove_circle_outline,
                                              color: kWhite,
                                              size: 20.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),

                            SizedBox(
                              height: 20.h,
                            ),
                            CustomButton(
                              text: "A D D    T A G S",
                              btnHieght: 40,
                              onTap: () {
                                if (_tags.text.isNotEmpty) {
                                  foodsController.tags.add(_tags.text);
                                  _tags.clear();
                                } else {
                                  Get.snackbar(
                                      "Error", "Please enter a valid value.",);
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                  text: 'Stocks',
                                  style: appStyle(14, kGray, FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          counterController.decrement();
                                          _counter.text = counterController.count.toString();
                                        },
                                        child: const Icon(
                                          AntDesign.minuscircleo,
                                          color: kPrimary,
                                        )
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),

                                    SizedBox(
                                      width: 47.w,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: _counter,
                                        cursorColor: kPrimary,
                                        onChanged: (value) {
                                          setState(() {
                                            counterController.count.value = int.parse(value);
                                          });
                                        },
                                        textAlign: TextAlign.center, // Aligns text to the center
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: kPrimary, width: 0.5),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: kPrimary, width: 0.5),
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          counterController.increment();
                                          _counter.text = counterController.count.toString();
                                        },
                                        child: const Icon(
                                          AntDesign.pluscircleo,
                                          color: kPrimary,
                                        )),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            const AvailableSwitch(),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  btnWidth: 145,
                                  text: "B A C K",
                                  color: kPrimary,
                                  onTap: () {
                                    _pageController.previousPage(
                                        duration:
                                        const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut);
                                  },
                                ),
                                foodsController.isLoading ? Center(
                                  child: LoadingAnimationWidget.waveDots(
                                      color: kSecondary,
                                      size: 35
                                  ),) :
                                CustomButton(
                                  btnWidth: 145,
                                  text: widget.update == true ? "U P D A T E  F O O D" : "A D D",
                                  color: kPrimary,
                                  onTap: () {
                                    if (_title.text.isEmpty ||
                                        _description.text.isEmpty ||
                                        _price.text.isEmpty ||
                                        foodsController.type.isEmpty ||
                                        foodsController.customAdditives.isEmpty ||
                                        foodsController.tags.isEmpty) {

                                      Get.snackbar("Error", "Please enter a valid value.",);

                                    } else {
                                      print(foodsController.customAdditives );
                                      final foodData = AddFoods(
                                        title: _title.text,
                                        foodTags: foodsController.tags,
                                        foodType: foodsController.type,
                                        isAvailable: restaurantController.isAvailable,
                                        code: restaurantController.restaurant!.code,
                                        category: foodsController.category,
                                        restaurant: restaurantController.restaurant!.id,
                                        description: _description.text,
                                        stocks: counterController.count.toInt(),
                                        time: selectedPrepTime!,
                                        price: double.parse(_price.text),
                                        //additives: foodsController.additives,
                                        imageUrl: imageUploader.images,
                                        customAdditives: foodsController.customAdditives,  // Include questions here
                                      );

                                      String foodItem = addFoodsToJson(foodData);
                                      print(foodItem);
                                      if (widget.update == true) {
                                        foodsController.updateFood(widget.food!.id, foodItem);
                                      } else {
                                        foodsController.addFood(foodItem);
                                      }
                                      _title.clear();
                                      _description.clear();
                                      _price.clear();
                                      selectedPrepTime = "5";
                                      foodsController.type.clear();
                                      foodsController.additives.clear();
                                      foodsController.tags.clear();
                                      foodsController.customAdditives.clear();  // Clear questions after submission
                                      imageUploader.images.clear();
                                    }
                                  },
                                )
                                /*foodsController.isLoading ?

                          : Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: kPrimary,
                                size: 35
                            ),
                          ),*/
                              ],
                            )
                          ],
                        ),
                      )
                  )
                ],
              ))
      ),
    );
  }
}
