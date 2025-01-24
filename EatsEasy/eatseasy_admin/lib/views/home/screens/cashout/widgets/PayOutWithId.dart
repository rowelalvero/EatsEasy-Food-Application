// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:eatseasy_admin/common/app_style.dart';
// import 'package:eatseasy_admin/common/back_ground_container.dart';
// import 'package:eatseasy_admin/common/custom_btn.dart';
// import 'package:eatseasy_admin/common/reusable_text.dart';
// import 'package:eatseasy_admin/constants/constants.dart';
// import 'package:eatseasy_admin/controllers/payout_controller.dart';
// import 'package:eatseasy_admin/models/payouts_model.dart';
// import 'package:get/get.dart';

// class PayoutDetailsWithId extends StatefulWidget {
//   const PayoutDetailsWithId(
//       {super.key, required this.id, required this.refetch});

//   final String id;
//   final Function refetch;

//   @override
//   State<PayoutDetailsWithId> createState() => _PayoutDetailsWithIdState();
// }

// class _PayoutDetailsWithIdState extends State<PayoutDetailsWithId> {
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(PayoutController());
//     return Scaffold(
//       backgroundColor: kPrimary,
//       appBar: AppBar(
//         backgroundColor: kPrimary,
//         title: ReusableText(
//             text: widget.element.id,
//             style: appStyle(13, kWhite, FontWeight.w600)),
//       ),
//       body: BackGroundContainer(
//           color: kWhite,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 12.w),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ReusableText(
//                           text: widget.element.restaurant.title,
//                           style: appStyle(18, kGray, FontWeight.w600)),
//                       CircleAvatar(
//                         radius: 15.r,
//                         backgroundColor: kGray,
//                         backgroundImage:
//                             NetworkImage(widget.element.restaurant.logoUrl),
//                       ),
//                     ]),
//                 const Divider(),
//                 RowText(
//                   first: "Withdrawable amount",
//                   second:
//                       "\Php ${(widget.element.restaurant.earnings - (widget.element.restaurant.earnings * 0.1))}",
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 RowText(
//                   first: "Requested amount",
//                   second: "\Php ${widget.element.amount}",
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 const Divider(),
//                 RowText(
//                   first: "Payout method",
//                   second: widget.element.method == "bank_transfer"
//                       ? "Bank Transfer"
//                       : "Stripe",
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 widget.element.method == "bank_transfer"
//                     ? Column(
//                         children: [
//                           RowText(
//                             first: "Card Holder",
//                             second: widget.element.accountName == "none"
//                                 ? "Horizon Dev"
//                                 : widget.element.accountName,
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           RowText(
//                             first: "Bank ",
//                             second: widget.element.accountBank,
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           RowText(
//                             first: "Account number",
//                             second: widget.element.accountNumber,
//                           ),
//                         ],
//                       )
//                     : const SizedBox.shrink(),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 widget.element.status == "pending"
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomButton(
//                             btnHieght: 35.h,
//                             radius: 0,
//                             btnWidth: width / 2.2,
//                             text: "Approve",
//                             onTap: () {
//                               controller.updateStatus(
//                                 widget.element.id,
//                                 "completed",
//                                 widget.refetch,
//                               );
//                             },
//                             color: kPrimary,
//                           ),
//                           CustomButton(
//                             btnHieght: 35.h,
//                             radius: 0,
//                             btnWidth: width / 2.2,
//                             text: "Reject",
//                             onTap: () {
//                               controller.updateStatus(
//                                 widget.element.id,
//                                 "failed",
//                                 widget.refetch,
//                               );
//                             },
//                             color: kRed,
//                           ),
//                         ],
//                       )
//                     : const SizedBox.shrink()
//               ],
//             ),
//           )),
//     );
//   }
// }

// class RowText extends StatelessWidget {
//   const RowText({
//     super.key,
//     required this.first,
//     required this.second,
//   });

//   final String first;
//   final String second;

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       ReusableText(
//           text: first, style: appStyle(11, kGrayLight, FontWeight.normal)),
//       ReusableText(text: second, style: appStyle(11, kGray, FontWeight.normal)),
//     ]);
//   }
// }
