import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final TextInputType? keyboardType;
  final String hintText;
  bool? isObsecure = true;
  bool? enabled = true;
  bool redBorder;
  bool noLeftMargin;
  bool noRightMargin;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

  CustomTextField({
    super.key,
    this.controller,
    this.data,
    required this.hintText,
    this.isObsecure,
    this.enabled,
    this.keyboardType,
    required this.redBorder,
    required this.noLeftMargin,
    required this.noRightMargin,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    /*bool? borderColor;
    if (borderColor!) {

      if (redBorder) {
        Colors.red;
      }

      if (_isContactNumberInvalid) {
        if (_isContactNumberInvalid) {
          Colors.red;
        }
        else {
          if (_isUserTypingContactNumber) {
            if (isContactNumberCompleted) {
              Colors.green;
            } else {
              Colors.red;
            }
          } else {
            Colors.transparent;
          }
        }
      }

      if (_isPasswordControllerInvalid) {
        if (_isPasswordControllerInvalid) {
          Colors.red;
        }
        else {
          if (_isUserTypingPassword) {
            if (_isPasswordValidated()) {
              Colors.green;
            } else {
              Colors.red;
            }
          } else {
            Colors.transparent;
          }
        }
      }

      if (_isConfirmPasswordControllerInvalid) {
        if (_isConfirmPasswordControllerInvalid) {
          Colors.red;
        } else {
          if (_isUserTypingConfirmPassword) {
            if (_isPasswordMatched) {
              Colors.green;
            } else {
              Colors.red;
            }
          } else {
            Colors.transparent;
          }
        }
      }
    } else {
      Colors.transparent;
    }*/
    return Container(
      // box styling
      decoration: BoxDecoration(
        color: const Color(0xFFE0E3E7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: redBorder
              ? Colors.red
              : Colors.transparent,
        ),
      ),
      padding: const EdgeInsets.all(4),
      margin: noLeftMargin
          ? const EdgeInsets.only(left: 4.0, right: 18.0, top: 8.0)
          : (noRightMargin ? const EdgeInsets.only(left: 18.0, right: 4.0, top: 8.0) : const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0)),

      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = MediaQuery.of(context).size.width * 0.9; // Set maximum width to 80% of screen width

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: TextFormField(
              enabled: enabled,
              controller: controller,
              obscureText: isObsecure!,
              cursorColor: const Color.fromARGB(255, 242, 198, 65),
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,

              // icon styling
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(data, color: const Color.fromARGB(255, 67, 83, 89)),
                focusColor: Theme.of(context).primaryColor,
                hintText: hintText,
              ),
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
            ),
          );
        },
      ),
    );
  }
}