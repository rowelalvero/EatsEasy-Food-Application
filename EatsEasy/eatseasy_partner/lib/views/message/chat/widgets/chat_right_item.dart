import 'package:eatseasy_partner/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:get/get.dart';

//import '../../../../common/routes/names.dart';

Widget ChatRightItem(Msgcontent item){
  return Container(
    padding: const EdgeInsets.only(top:10, left: 15, right: 15, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 230,
              minHeight: 40
            ),
          child: Container(
            margin: const EdgeInsets.only(right: 10, top:0),
            padding: const EdgeInsets.only(top:10, left: 10, right: 10,),
            decoration:  BoxDecoration(
                color: kSecondary.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10))

            ),
            child: item.type=="text"?Text("${item.content}"):
                ConstrainedBox(constraints: const BoxConstraints(
                    maxWidth: 90,
                ),
                child: GestureDetector(
                  onTap: (){
                    /*Get.toNamed(AppRoutes.Photoimgview,
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