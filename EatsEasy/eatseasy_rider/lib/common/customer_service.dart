import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';
import 'app_style.dart';

Future<dynamic> customerService(BuildContext context, String service) {
  return showDialog(
    context: context,

    builder: (context) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
      title: Center(
        child: Text(
          '🍽 EatsEasy Service Center 🍽',
          style: appStyle(14, kPrimary, FontWeight.bold),
        ),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      content: SizedBox(
        width: width,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'We hope you are enjoying a seamless and delicious journey with EatsEasy, your go-to app for all things tasty and convenient! Whether it is a crave-worthy dinner, a cozy breakfast, or that midday snack, we are here to bring it right to your doorstep.',
              textAlign: TextAlign.justify,
              style: appStyle(11, kDark, FontWeight.normal),
            ),
            SizedBox(
              height: 10 ,
            ),
            Text(
              "Got Questions or Need Help?",
              textAlign: TextAlign.justify,
              style: appStyle(14, kDark, FontWeight.w600),
            ),
            SizedBox(
              height: 10 ,
            ),
            GestureDetector(
              onTap: () {
                FlutterPhoneDirectCaller.callNumber(service);
              },
              child: Text(
                "📞 $service",
                textAlign: TextAlign.justify,
                style: appStyle(14, Colors.blue.shade600, FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
