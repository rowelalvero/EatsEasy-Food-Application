import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/back_ground_container.dart';
import '../../common/custom_app_bar.dart';
import 'chat/widgets/message_list.dart';
import 'package:get/get.dart';

import 'controller.dart';
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
