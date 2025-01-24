import 'package:flutter/material.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/constants/constants.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key? key,
    this.prefixIcon,
    this.keyboardType,
    this.onEditingComplete,
    this.controller,
    this.hintText,
    this.focusNode,
    this.initialValue,
    this.maxLines,
    this.onChanged,
    this.enabled,
    this.contentPadding,
    required this.textCapitalization,
  }) : super(key: key);
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final int? maxLines;
  final dynamic onChanged;
  final dynamic enabled;
  final dynamic contentPadding;
  final TextCapitalization textCapitalization;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
        enabled: enabled,
        cursorColor: kPrimary,
        textInputAction: TextInputAction.next,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        keyboardType: keyboardType,
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged ,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter a valid value";
          } else {
            return null;
          }
        },
        style: appStyle(12, kDark, FontWeight.normal),
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: prefixIcon,
          isDense: true,
          contentPadding: contentPadding,

          labelStyle: appStyle(16, kGray, FontWeight.normal),
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
        )
    );
  }
}

class DropdownFormField extends StatelessWidget {
  const DropdownFormField({
    Key? key,
    this.prefixIcon,
    this.hint,
    this.onChanged,
    this.items,
    this.value
  }) : super(key: key);
  final dynamic hint;
  final Widget? prefixIcon;
  final dynamic onChanged;
  final dynamic items;
  final dynamic value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items,
      hint: hint,
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        contentPadding: const EdgeInsets.all(12),

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
    );
  }
}
