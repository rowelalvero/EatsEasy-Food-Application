
import 'package:eatseasy/common/values/colors.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/login_controller.dart';
import 'package:eatseasy/views/message/chat/widgets/chat_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/back_ground_container.dart';
import '../../../common/common_appbar.dart';
import 'controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  AppBar _buildAppBar(){
    return CommonAppBar(
        appBarChild: Container(
          padding: EdgeInsets.only(top: 0,bottom: 0, right: 0),

          child: Row(
            children: [

              Container(
                padding: EdgeInsets.only(top: 0,bottom: 0, right: 0),
                child: InkWell(
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CachedNetworkImage(
                      imageUrl: controller.state.to_avatar.value,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 44,
                        width: 44,
                        margin: null,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(44)),
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      errorWidget: (context, url, error)=>const Image(
                        image: AssetImage('assets/images/profile-photo.png'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15,),
              Container(
                width: 180,
                padding: const EdgeInsets.only(top: 0,bottom: 0, right: 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 180,
                      height: 44,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.state.to_name.value,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.bold,
                                  color: kDark,
                                  fontSize: 16
                              ),
                            ),
                            /*Obx(
                                    ()=>Text(
                                  controller.state.to_location.value,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.normal,
                                      color: kDark,
                                      fontSize: 14
                                  ),
                                )
                            )*/
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  void _showPicker(context){
    showModalBottomSheet(
        context: context, builder: (BuildContext bc){
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: (){
                controller.imgFromGallery();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Camera"),
              onTap: (){

              },
            )
          ],
        ),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => LoginController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading:InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: kDark,
            )),
        flexibleSpace: _buildAppBar(),
        elevation: 0,
        backgroundColor: kOffWhite,
      ),


      body: Center(
        child: BackGroundContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                const ChatList(),
                Positioned(
                  bottom: 0, // Align the container to the bottom
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    decoration: BoxDecoration(
                      color: kOffWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            controller: controller.textController,
                            autofocus: false,
                            focusNode: controller.contentNode,
                            decoration: const InputDecoration(
                              hintText: "Send messages...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Icon(
                            Icons.photo_outlined,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            controller.sendMessage();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Send",
                              style: TextStyle(color: kOffWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

