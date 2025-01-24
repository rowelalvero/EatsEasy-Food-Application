import 'package:eatseasy/common/cached_image_loader.dart';
import 'package:eatseasy/common/entities/message.dart';
import 'package:eatseasy/common/show_snack_bar.dart';
import 'package:eatseasy/common/utils/date.dart';
import 'package:eatseasy/main.dart';
import 'package:eatseasy/views/message/chat/index.dart';
import 'package:eatseasy/views/message/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/values/colors.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({Key? key}) : super(key: key);

  Widget messageListItem(Message item){

    return Container(
      padding: EdgeInsets.only(top:10, left: 15, right: 15),
      child: InkWell(
        onTap: (){

          Get.to(ChatPage(),arguments: {
            "doc_id":item.doc_id,
            "to_uid":item.token,
            "to_name":item.name,
            "to_avatar":item.avatar
          });
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top:0, left: 0, right: 15),
              child: SizedBox(
                width: 54,
                height: 54,
                child: CachedNetworkImage(
                  imageUrl: item.avatar!,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(54)),
                        image: DecorationImage(
                            image: imageProvider,
                            fit:BoxFit.cover
                        )
                    ),
                  ),
                  errorWidget: (context, url, error)=>const Image(
                      image:AssetImage('assets/images/feature-1.png')
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:0, left: 0, right: 5),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color:Color(0xffe5e5e5))
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name!,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color:AppColors.thirdElement,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          item.last_msg??"",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color:AppColors.thirdElement,
                              fontSize: 14
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          duTimeLineFormat(
                              (item.last_time as Timestamp).toDate()
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color:AppColors.thirdElementText,
                              fontSize: 12
                          ),
                        ),
                        item.msg_num == 0
                            ? Container()
                            : Container(
                          padding: EdgeInsets.only(
                              left: 4,
                              right: 4,
                              top: 0,
                              bottom: 0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)),
                          ),
                          child: Text(
                            "${item.msg_num}",
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryElementText,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(
            ()=>CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, index){
                      var item = controller.state.msgList[index];
                      return messageListItem(item);
                    },
                    childCount: controller.state.msgList.length
                ),
              ),
            ),

          ],
        )
    );
  }
}
