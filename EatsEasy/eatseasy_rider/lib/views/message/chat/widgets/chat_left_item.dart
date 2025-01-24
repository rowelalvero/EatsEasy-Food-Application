import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../common/entities/msgcontent.dart';
import '../../../../constants/constants.dart';

//import '../../../../common/routes/names.dart';
Widget ChatLeftItem(Msgcontent item){
  return Container(
    padding: EdgeInsets.only(top:10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: 230.w,
                minHeight: 40.w
            ),
            child: Container(
                margin: EdgeInsets.only(right: 10.w, top:0.w),
                padding: EdgeInsets.only(top:10.w, left: 10.w, right: 10.w,),
                decoration:  BoxDecoration(
                    color: kPrimary.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: item.type=="text"?Text("${item.content}"):
                ConstrainedBox(constraints: BoxConstraints(
                  maxWidth: 90.w,
                ),
                  child: GestureDetector(
                    onTap: (){
                  /*    Get.toNamed(AppRoutes.Photoimgview,
                          parameters: {"url": item.content??""});*/
                    },
                    child: CachedNetworkImage(
                      imageUrl: "${item.content}",
                    ),
                  ),
                )
            )
        )],
    ),

  );
}