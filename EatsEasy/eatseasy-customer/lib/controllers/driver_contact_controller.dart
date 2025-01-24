
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../common/entities/msg.dart';
import '../common/entities/user.dart';
import '../common/utils/check_user.dart';
import '../models/login_response.dart';
import '../models/order_details.dart';
import '../models/response_model.dart';
import '../models/restaurants.dart';
import '../views/message/chat/view.dart';

class DriverContactState {
  var count = 0.obs;
  RxString driverId = "".obs;
  Rxn<Driver> driver = Rxn<Driver>();
  RxBool loading = false.obs;
  RxList<UserData> contactList = <UserData>[].obs;
}

class DriverContactController extends GetxController {
  DriverContactController();

  final DriverContactState state = DriverContactState();
  final db = FirebaseFirestore.instance;
  final box = GetStorage();
  String? token;

  @override
  void onReady() {
    super.onReady();
    //this token could be something encrypted
    token = box.read("userId");
    if (token != null) {
      token = jsonDecode(token!);
    }
  }

  Future<ResponseModel> goChat(Driver to_userdata) async {
    String? token = box.read("userId");
    if(token!=null){
      token = jsonDecode(token);
    }
    if(token == state.driverId.value){
      return ResponseModel(isSuccess: false, message: "You can not chat to yourself", title: "Token issue");
    }
    if(token==null){
      return ResponseModel(isSuccess: false, message: "Login before you continue", title: "Login issue");
    }
    bool appUser = CheckUser.isValidId(token);
    if(appUser==false){
      return ResponseModel(isSuccess: false, message: "Corrupted user account", title: "Serious issue");
    }
    to_userdata.id = state.driverId.value;
    bool restaurantOwner = CheckUser.isValidId(to_userdata.id!);

    if(to_userdata.id==null){
      return ResponseModel(isSuccess: false, message: "Restaurant may not exist, try another shop");
    }
    if(restaurantOwner==false){
      return ResponseModel(isSuccess: false, message: "Corrupted restaurant account", title: "Serious issue");

    }
    var from_messages = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token) //and condition
        .where("to_uid", isEqualTo: to_userdata.id)
        .get();
    var to_messages = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: to_userdata.id)
        .where("to_uid", isEqualTo: token)
        .get();
    if (from_messages.docs.isEmpty) {
      print("Empty chat list");
    } else {
      print("Chat id is ${from_messages.docs.first.id}");
    }

    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      String? data = box.read("user");
      if(data==null){
        return ResponseModel(isSuccess: false, message: "Try to login again",title: "Login");
      }
      LoginResponse userdata = LoginResponse.fromJson(jsonDecode(data));
      print("inserting---------");
      var msgdata = Msg(
          from_uid: userdata.id,
          to_uid: to_userdata.id,
          from_name: userdata.username,
          to_name: to_userdata.username,
          from_avatar: userdata.profile,
          to_avatar: to_userdata.profile,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);
      await db
          .collection("message")
          .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgdata)
          .then((value) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": value.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.username ?? "",
          "to_avatar": to_userdata.profile ?? ""
        });
      });
      return ResponseModel(isSuccess: true, message: "");

    } else {
      if (from_messages.docs.isNotEmpty) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": from_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.username ?? "",
          "to_avatar": to_userdata.profile ?? ""
        });
      }
      if (to_messages.docs.isNotEmpty) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": to_messages.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.username ?? "",
          "to_avatar": to_userdata.profile ?? ""
        });
      }
      return ResponseModel(isSuccess: true,);

    }
  }

  Future<ResponseModel> asyncLoadSingleDriver() async {
    // Retrieve the userId from storage
    final userId = box.read("userId");
    if(userId==null){
      return ResponseModel(isSuccess: false, message: "Please login first");
    }
    final decodedUserId = jsonDecode(userId).toString();
    final restaurantId = state.driverId.value;
    print("Raw user id from storage: $userId");
    print("Decoded user id: $decodedUserId");
    print("Restaurant id : $restaurantId");
    state.contactList.clear();
    // Query the Firestore collection
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: decodedUserId)
        .withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options) => userdata.toFirestore(),
    )
        .get();
    state.contactList.add(usersbase.docs[0].data());
    print("${usersbase.docs[0].data().toFirestore()}");
    return ResponseModel(isSuccess: true);
  }
  Future<ResponseModel> asyncLoadMultipleRestaurant() async {
    // Retrieve the userId from storage

    final userId = box.read("userId");
    if(userId==null){
      return ResponseModel(isSuccess: false, message: "Please login first");
    }
    final decodedUserId = jsonDecode(userId).toString();
    final restaurantId = state.driverId.value;
    print("Raw user id from storage: $userId");
    print("Decoded user id: $decodedUserId");
    print("Restaurant id : $restaurantId");
    // Query the Firestore collection
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: decodedUserId)
        .withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options) => userdata.toFirestore(),
    )
        .get();
    state.contactList.clear();
    for(var item in usersbase.docs){
      state.contactList.add(item.data());
    }
    //state.contactList.add(usersbase.docs[0].data());
    print("${usersbase.docs[0].data().toFirestore()}");
    return ResponseModel(isSuccess: true);
  }
}
