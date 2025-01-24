import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phone_otp_verification/phone_verification.dart';

import '../../../common/app_style.dart';
import '../../../constants/constants.dart';
import '../../../controllers/phone_verification_controller.dart';
import '../../../services/verification.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final AuthService _authService = AuthService();
  final PhoneVerificationController controller = Get.put(PhoneVerificationController());

  String _verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading == false
        ? _buildPhoneVerificationWidget()
        : _buildLoadingWidget(context));
  }

  Widget _buildPhoneVerificationWidget() {
    return PhoneVerification(
      isFirstPage: false,
      enableLogo: false,
      themeColor: kPrimary,
      initialPageText: "EatsEasy Phone Verification",
      initialPageTextStyle: appStyle(20, kPrimary, FontWeight.bold),
      textColor: kDark,
      onSend: (String value) {
        _verifyPhoneNumber(value);
      },
      onVerification: (String value) {
        if (_verificationId.isNotEmpty) {
          _submitVerificationCode(value);
        }
      },
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: kLightWhite,
      child: Center(
        child: LoadingAnimationWidget.waveDots(
          color: kPrimary,
          size: 35,
        ),
      ),
    );
  }

  // Function to trigger phone verification
  void _verifyPhoneNumber(String phoneNumber) async {
    controller.phoneNumber = phoneNumber;

    await _authService.verifyPhoneNumber(
      controller.phoneNumber,
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  // Function to submit the verification code
  void _submitVerificationCode(String code) async {
    await _authService.verifySmsCode(_verificationId, code);
  }
}
