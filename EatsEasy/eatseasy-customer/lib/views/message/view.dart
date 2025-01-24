import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/common/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/views/message/index.dart';

import '../../common/common_appbar.dart';
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
