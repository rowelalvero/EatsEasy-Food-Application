import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/app_style.dart';
import '../../../../common/reusable_text.dart';
import '../../../../constants/constants.dart';
import '../../../../models/order_model.dart';
import '../../../../models/users_model.dart';
import '../cashout/widgets/cashout_update_page.dart';

class UserDetailsPage extends HookWidget {
  const UserDetailsPage({super.key, required this.user});

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        title: ReusableText(
          text: "Driver Details",
          style: appStyle(20, kGray, FontWeight.w600),
        ),
      ),
      body: Center(
        child: BackGroundContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(user.profile),
                        ),
                        const SizedBox(width: 10),
                        ReusableText(
                          text: user.username,
                          style: appStyle(16, kDark, FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RowText(first: "User Id: ", second: user.id),
                    RowText(first: "Email: ", second: user.email),
                    RowText(first: "Phone: ", second: user.phone),
                    RowText(first: "User type: ", second: user.userType),
                    const SizedBox(height: 10),
                    ReusableText(
                      text: "Order Items",
                      style: appStyle(16, kDark, FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
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
                                        user.validIdUrl!,
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
                                  user.validIdUrl!,
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
                                        user.proofOfResidenceUrl!,
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
                                  user.proofOfResidenceUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
