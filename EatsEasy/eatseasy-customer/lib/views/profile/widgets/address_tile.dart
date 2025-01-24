import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/all_addresses.dart';
import 'package:eatseasy/views/profile/edit_address_page.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../controllers/address_controller.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
    required this.refetch,
    this.cartRefetch// Add refetch parameter
  });

  final AddressesList address;
  final VoidCallback refetch; // Define refetch as a callback
  final VoidCallback? cartRefetch;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    final localContext = context;
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateAddressPage(address: address), // Pass update if needed
          ),
        );
        if (result != null) {
          refetch();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: height * .08,
        width: width,
        decoration: const BoxDecoration(
          color: kLightWhite,
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,  // Allow the child to take as much space as it needs
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    ReusableText(
                      text: address.addressName,
                      style: appStyle(13, kGray, FontWeight.w600),
                    ),
                    ReusableText(
                      text: address.addressLine1,
                      style: appStyle(11, kGray, FontWeight.w500),
                    ),
                    ReusableText(
                      text: address.postalCode,
                      style: appStyle(11, kGray, FontWeight.normal),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Row(
                children: [
                  Switch.adaptive(
                    value: address.addressesListDefault,
                    onChanged: (bool value) {
                      _showSetDefaultDialog(context, localContext, controller, address, refetch, cartRefetch: cartRefetch);
                    },
                    thumbColor: WidgetStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      return states.contains(MaterialState.disabled)
                          ? kPrimary.withOpacity(.48)
                          : kPrimary;
                    }),
                    activeColor: kCupertinoModalBarrierColor,
                  ),
                  address.addressesListDefault ?
                  SizedBox.shrink()
                   : IconButton(
                    onPressed: () async {
                      await _handleDelete(context, localContext, controller, address, refetch, cartRefetch: cartRefetch);
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSetDefaultDialog(BuildContext context, BuildContext localContext, AddressController controller, AddressesList address, VoidCallback refetch, {VoidCallback? cartRefetch}) {
    showDialog(
      context: localContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Default Address'),
          content: const Text('Are you sure you want to set this as your default address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(localContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(localContext).pop();
                showDialog(
                  context: localContext,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: kPrimary,
                        size: 35,
                      ),
                    );
                  },
                );
                try {
                  await controller.setDefaultAddress(address.id);
                  refetch();
                  if (cartRefetch != null) {
                    cartRefetch();
                  }
                } finally {
                  Navigator.of(localContext).pop();
                }
              },
              child: const Text('Set Default', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDelete(BuildContext context, BuildContext localContext, AddressController controller, AddressesList address, VoidCallback refetch, {VoidCallback? cartRefetch}) async {
    final confirmed = await showDialog<bool>(
      context: localContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(localContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(localContext).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      showDialog(
        context: localContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: kPrimary,
              size: 35,
            ),
          );
        },
      );
      try {
        await controller.deleteAddress(address.id);
        refetch();
        if (cartRefetch != null) {
          cartRefetch();
        }
      } finally {
        Navigator.of(localContext).pop();
      }
    }
  }
}
