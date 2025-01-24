import 'package:eatseasy_admin/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:eatseasy_admin/common/custom_btn.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/add_category_controller.dart';
import 'package:eatseasy_admin/controllers/image_upload_controller.dart';
import 'package:eatseasy_admin/models/add_category_model.dart';
import 'package:eatseasy_admin/views/auth/widgets/email_textfield.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key, this.isEdit, this.category});
  final bool? isEdit;
  final Category? category;
  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  final TextEditingController _title = TextEditingController();
  final imageUploader = Get.put(ImageUploadController());
  final controller = Get.put(AddCategoryController());

  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true) {
      _title.text = widget.category!.title;
      if (widget.isEdit == true && widget.category!.imageUrl.isNotEmpty) {
        imageUploader.imageOneUrl = widget.category!.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        centerTitle: true,
        title: ReusableText(
          text: widget.isEdit == true ? "Edit category" : "Add category",
          style: appStyle(20, kDark, FontWeight.w600),
        ),
      ),
      body: Center(child: BackGroundContainer(
        color: kLightWhite,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => imageUploader.pickImage("one"),
              child: Badge(
                backgroundColor: Colors.transparent,
                label: Obx(
                      () => imageUploader.imageOneUrl.isNotEmpty
                      ? GestureDetector(
                    onTap: () => imageUploader.imageOneUrl = '',
                    child: const Icon(Icons.remove_circle, color: kRed),
                  )
                      : Container(),
                ),
                child: Container(
                  height: 120,
                  width: width / 2.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: kGrayLight),
                  ),
                  child: widget.isEdit == true && widget.category!.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      widget.category!.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Obx(
                        () => imageUploader.isLoading &&
                        imageUploader.imageBeingUploaded.value == "one"
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.threeArchedCircle(
                            color: kSecondary,
                            size: 35,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",
                            style: appStyle(16, kDark, FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                        : imageUploader.imageOneUrl.isEmpty
                        ? Center(
                      child: IconButton(
                        onPressed: () => imageUploader.pickImage("one"),
                        icon: const Icon(Icons.file_upload_outlined),
                        iconSize: 40.0,
                        color: kPrimary,
                        tooltip: 'Upload file',
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        imageUploader.imageOneUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ReusableText(
              text: "Category Title",
              style: appStyle(13, kGray, FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            EmailTextField(
              controller: _title,
              prefixIcon: const Icon(Ionicons.md_add_circle),
              hintText: "Category Title",
            ),
            SizedBox(height: 30.h),
            CustomButton(
              onTap: () async {
                if (_title.text.isEmpty || imageUploader.imageOneUrl.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please complete all fields",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (widget.isEdit == true) {
                  await controller.updateCategory(widget.category!.id!, _title.text, imageUploader.imageOneUrl);
                  //Get.snackbar("Success", "Category updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
                  Navigator.pop(context, true);
                } else {
                  var model = AddCategoryModel(
                    title: _title.text,
                    value: _title.text.toLowerCase(),
                    imageUrl: imageUploader.imageOneUrl,
                  );
                  String data = addCategoryModelToJson(model);
                  controller.addCategory(data);
                  //Get.snackbar("Success", "Category added successfully", backgroundColor: Colors.green, colorText: Colors.white);
                  Navigator.pop(context, true);
                }

                imageUploader.imageOneUrl = '';
                _title.text = '';
              },
              text: "Submit",
              btnHieght: 35.h,
              color: kPrimary,
            ),
          ],
        ),
      )),
    );
  }
}
