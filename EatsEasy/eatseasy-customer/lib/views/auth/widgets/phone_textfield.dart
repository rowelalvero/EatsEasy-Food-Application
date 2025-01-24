import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/constants/constants.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    Key? key,
    this.prefixIcon,
    this.keyboardType,
    this.onEditingComplete,
    this.controller,
    this.hintText,
    this.focusNode, this.initialValue,
  }) : super(key: key);
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.7,
      
      child: TextFormField(
          cursorColor: kDark,
          textInputAction: TextInputAction.next,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          initialValue: initialValue,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter a valid value";
            } else {
              return null;
            }
          },
          style: appStyle(16, kGray, FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText,
           
            isDense: true,
            contentPadding:  EdgeInsets.all(8.w),
            hintStyle: appStyle(14, kGray, FontWeight.normal),
            // contentPadding: EdgeInsets.only(left: 24),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                     BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius:  BorderRadius.all(Radius.circular(12))),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            border: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.transparent, width: 0.5),
              borderRadius:  BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          )),
    );
  }
}