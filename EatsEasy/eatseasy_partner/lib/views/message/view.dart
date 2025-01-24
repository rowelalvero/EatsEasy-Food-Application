import 'package:eatseasy_partner/common/common_appbar.dart';
import 'package:eatseasy_partner/common/values/colors.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/views/message/index.dart';

import 'chat/widgets/message_list.dart';
import 'package:get/get.dart';
class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());
    return Scaffold(
        appBar: CommonAppBar(
            titleText: "Message"
        ),
        body: const Center(child: BackGroundContainer(child: MessageList(),),)
    );
  }
}
