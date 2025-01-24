
import 'package:eatseasy_rider/views/message/chat/widgets/chat_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/custom_app_bar.dart';
import '../../../common/values/colors.dart';
import '../../../constants/constants.dart';
import '../../../controllers/login_controller.dart';
import 'controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  AppBar _buildAppBar(){
    return CommonAppBar(
      appBarChild: Container(
        padding: EdgeInsets.only(top: 0.w,bottom: 0.w, right: 0.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w,bottom: 0.w, right: 0.w),
              child: InkWell(
                child: SizedBox(
                  width: 44.w,
                  height: 44.w,
                  child: CachedNetworkImage(
                    imageUrl: controller.state.to_avatar.value,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 44.w,
                      width: 44.w,
                      margin: null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(44.w)),
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
            SizedBox(width: 15.w,),
            Container(
              width: 180.w,
              padding: EdgeInsets.only(top: 0.w,bottom: 0.w, right: 0.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 44.w,
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
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBackground,
                                fontSize: 16
                            ),
                          ),
                          Obx(
                                  ()=>Text(
                                controller.state.to_location.value,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.primaryBackground,
                                    fontSize: 14
                                ),
                              )
                          )
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
                  leading: Icon(Icons.photo_library),
                  title: Text("Gallery"),
                  onTap: (){
                    controller.imgFromGallery();
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Camera"),
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
    Get.lazyPut(()=>ChatController());
    Get.lazyPut(()=>LoginController());
    return  Scaffold(
      appBar: _buildAppBar(),
        body: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                const ChatList(),
                Positioned(
                  bottom: 0.h,
                  height: 50.h,
                  left: 0.h,
                  right: 0.h,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 50.h,
                    color: AppColors.primaryBackground,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: 217.w,
                            height: 50.h,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              controller: controller.textController,
                              autofocus: false,
                              focusNode: controller.contentNode,
                              decoration: const InputDecoration(
                                hintText: "Send messages..."
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 30.h,
                          width: 30.w,
                          margin: EdgeInsets.only(left: 5.w),
                          child: GestureDetector(
                            child:  Icon(
                              Icons.photo_outlined,
                              size: 35.w,
                              color: Colors.blue,
                            ),
                            onTap: (){
                              _showPicker(context);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, top: 5.h),
                          width: 85.w,
                          height: 35.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimary,
                            boxShadow: [
                              BoxShadow(
                                blurRadius:1.0,
                                spreadRadius: 2.0,
                                offset: const Offset(0, 1),
                                color: kPrimary.withOpacity(0.5)
                              )
                            ]
                          ),
                          child: GestureDetector(
                              child:const Center(child: Text("Send", style: TextStyle(color: kOffWhite),)),
                              onTap: (){
                                controller.sendMessage();
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
