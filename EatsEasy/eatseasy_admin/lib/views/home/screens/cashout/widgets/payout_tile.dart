import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/payouts_model.dart';
import 'package:eatseasy_admin/views/home/screens/cashout/widgets/cashout_update_page.dart';
import 'package:get/get.dart';

class PayoutTile extends StatelessWidget {
  const PayoutTile({
    super.key,
    required this.payout,
    this.refetch,
  });

  final PayoutElement payout;
  final Function? refetch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kGrayLight,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        onTap: () {
          Get.to(
            () => PayoutDetailsUpdates(
              element: payout, refetch: refetch!,
            )
          );
        },
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        leading: CircleAvatar(
          radius: 15.r,
          backgroundImage: NetworkImage(payout.restaurant.logoUrl),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: payout.restaurant.title,
              style: appStyle(11, kGray, FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Icon(
                payout.method == "stripe"
                    ? FontAwesome5Brands.stripe
                    : payout.method == "paypal"
                        ? FontAwesome5Brands.cc_paypal
                        : FontAwesome5Brands.cc_mastercard,
                color: kPrimary,
              ),
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: "Amount",
              style: appStyle(11, kGrayLight, FontWeight.normal),
            ),
            ReusableText(
              text: "Php ${payout.amount.toString()}",
              style: appStyle(11, kGray, FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
