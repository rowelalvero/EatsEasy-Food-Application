import 'dart:convert';

import 'package:eatseasy_partner/common/entities/entities.dart';
import 'package:eatseasy_partner/common/entities/message.dart';
import 'package:eatseasy_partner/common/store/store.dart';
import 'package:eatseasy_partner/common/utils/http.dart';
import 'package:eatseasy_partner/views/message/state.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:location/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessageController extends GetxController {
  MessageController();
  final box = GetStorage();
  String? token;// = box.read('token');
 // final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();
  var listener;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
@override
  void onInit() {
   token = box.read('userId');
   if(token!=null){
     token = jsonDecode(token!);
   }
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
    _snapshots();
  }

  asyncLoadMsgData() async {
    print("-----------state.msgList.value");
    print(state.msgList.value);


    var from_messages = await db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("from_uid", isEqualTo: token)
        .get();
    print(from_messages.docs.length);

    var to_messages = await db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("to_uid", isEqualTo: token)
        .get();
    print("to_messages.docs.length------------");
    print(to_messages.docs.length);
    state.msgList.clear();

    if (from_messages.docs.isNotEmpty) {
      await addMessage(from_messages.docs);
    }
    if (to_messages.docs.isNotEmpty) {
      await addMessage(to_messages.docs);
    }
    // sort
    state.msgList.value.sort((a, b) {
      if (b.last_time == null) {
        return 0;
      }
      if (a.last_time == null) {
        return 0;
      }
      return b.last_time!.compareTo(a.last_time!);
    });
  }

  addMessage(List<QueryDocumentSnapshot<Msg>> data) async {
    data.forEach((element) {
      var item = element.data();
      Message message = new Message();
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if (item.from_uid == token) {
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.token = item.to_uid;
       // message.online = item.to_online;
        message.msg_num = item.to_msg_num ?? 0;
      } else {
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_uid;
        //message.online = item.from_online;
        message.msg_num = item.from_msg_num ?? 0;
      }

      print("num ${message.msg_num}");
      print("from ${message.msg_num}");
      print("to ${message.msg_num}");
      print("token $token");
      print("form_uid ${item.from_uid}");
      print("form_msg ${item.from_msg_num}");
      print("to_name ${item.to_name}");
      print("from_name ${item.from_name}");
      state.msgList.add(message);
    });
  }

  _snapshots() async {
    final toMessageRef = db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("to_uid", isEqualTo: token);
    final fromMessageRef = db
        .collection("message")
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .where("from_uid", isEqualTo: token);
    toMessageRef.snapshots().listen(
          (event) async {
        await asyncLoadMsgData();
      },
      onError: (error) => print("Listen failed: $error"),
    );
    fromMessageRef.snapshots().listen(
          (event) async {
        await asyncLoadMsgData();
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  getUserLocation() async {
    try {
      final location = await Location().getLocation();
      String address = "${location.latitude}, ${location.longitude}";
      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=AIzaSyCMESvjp3G5FtPnukZ28_GVOuFSvEhSS9c";
      var response = await HttpUtil().get(url);
      MyLocation location_res = MyLocation.fromJson(response);
      if (location_res.status == "OK") {
        String? myaddresss = location_res.results?.first.formattedAddress;
        if (myaddresss != null) {
          var user_location =
              await db.collection("users").where("id", isEqualTo: token).get();
          if (user_location.docs.isNotEmpty) {
            var doc_id = user_location.docs.first.id;
            await db
                .collection("users")
                .doc(doc_id)
                .update({"location": myaddresss});
          }
        }
      }
    } catch (e) {
      print("Getting error $e");
    }
  }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("...my token is $fcmToken...");
    if (fcmToken != null) {
      var user =
          await db.collection("users").where("id", isEqualTo: token).get();
      if (user.docs.isNotEmpty) {
        var doc_id = user.docs.first.id;
        await db.collection("users").doc(doc_id).update({"fcmtoken": fcmToken});
      }else{
        print("----------docs are empty-------");
      }
    }
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("..................onMessage................");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");
      print("message.data------------");
      print(message.data);
      //   HelperNotification.showNotification(message.notification!.title!, message.notification!.body!);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "onOpenApp: ${message.notification?.title}/${message.notification?.body}");
      print("message.data------------");
      print(message.data);
      if (message.data != null) {
        var to_uid = message.data["to_uid"];
        var to_name = message.data["to_name"];
        var to_avatar = message.data["to_avatar"];
        var doc_id = message.data['doc_id'];
        Get.toNamed("/chat", parameters: {
          "doc_id": doc_id,
          "to_uid": to_uid,
          "to_name": to_name,
          "to_avatar": to_avatar
        });
      }
    });
  }
}
