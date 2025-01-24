import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:eatseasy_partner/common/utils/security.dart';
import 'package:eatseasy_partner/controllers/login_controller.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eatseasy_partner/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;


class ChatController extends GetxController{
  ChatController();
  ChatState state = ChatState();
  var doc_id = null;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final box = GetStorage();

  String? user_id;// UserStore.to.token;
  var user_profile = Get.find<LoginController>().loginResponse;
  final db = FirebaseFirestore.instance;
  var listener;
  var to_uid;
  var from_uid;
  var from_name;
  var to_name;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      _photo = File(pickedFile.path);
      uploadFile();
    }else{
      print("No image selected");
    }
  }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceRef.getDownloadURL();
    return str??"";
  }

  sendImageMessage(String url) async {
   final content= Msgcontent(
      uid: user_id,
      content: url,
      type: "image",
      addtime: Timestamp.now()
    );

   await FirebaseFirestore.instance.collection("message").doc(doc_id).collection("msglist").
   withConverter(
       fromFirestore: Msgcontent.fromFirestore,
       toFirestore: (Msgcontent msgcontent, options)=>msgcontent.toFirestore())
       .add(content).then((DocumentReference doc) {
     print("Document snapshot added with id, ${doc.id}");

   });
   await FirebaseFirestore.instance.collection("message").doc(doc_id).update({
     "last_msg":"【image】",
     "last_time":Timestamp.now()
   }
   );
   var userbase = await FirebaseFirestore.instance.collection("users").withConverter(
     fromFirestore: UserData.fromFirestore,
     toFirestore: (UserData userdata, options)=>userdata.toFirestore(),
   ).where("id", isEqualTo: state.to_uid.value).get();
   if(userbase.docs.isEmpty) {
     var title = "Message made by ${from_name}";
     var body = "【image】";
     var token = userbase.docs.first.data().fcmtoken;
     if(token!=null){
       sendNotification(title, body, token);
     }
   }
  }

  Future uploadFile()async{
    if(_photo==null) return;
    final fileName = getRandomString(15)+extension(_photo!.path);
    try{
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);
      ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch(event.state){
          case TaskState.running:
            print("...uploading file ${fileName}");
            break;

          case TaskState.paused:
            print("...uploading file paused ${fileName}");
            break;
          case TaskState.success:
            String imgUrl = await getImgUrl(fileName);
            sendImageMessage(imgUrl);
            print("...uploading file succeed ${fileName}");
            break;
          case TaskState.error:
            print("...uploading file error ${fileName}");
            break;
          case TaskState.canceled:
            print("...uploading file canceled ${fileName}");
            break;
        }

      });
    }catch(e){
      print("There's an error $e");
    }
  }

  @override
  void onInit(){
    super.onInit();
    user_id =  box.read("userId");
    var data= Get.arguments;
    doc_id = data['doc_id']??"";
    state.to_uid.value = data['to_uid']??"";
    state.to_name.value = data['to_name']??"";
    state.to_avatar.value = data['to_avatar']??"";
    clear_msg_num(doc_id);
  }
  @override
  void onClose() {
    super.onClose();
    clear_msg_num(doc_id);
  }

  clear_msg_num(String doc_id) async{
    var message_res = await db.collection("message").doc(doc_id).withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    ).get();
    if(message_res.data()!=null){
      var item = message_res.data()!;
      from_uid = item.from_uid;
      to_uid = item.to_uid;
      from_name = item.from_name;
      to_name = item.to_name;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;

      if (item.from_uid == user_id) {
        to_msg_num = 0;
      } else {
        from_msg_num = 0;
      }

      await db.collection("message").doc(doc_id).update({"to_msg_num":to_msg_num,"from_msg_num":from_msg_num});
    }
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
      uid: user_id,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now()
    );
    try{
      await FirebaseFirestore.instance.collection("message")
          .doc(doc_id)
          .collection("msglist")
          .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msgcontent, options)=>msgcontent.toFirestore())
          .add(content).then((DocumentReference doc) {
            print("added $doc");
        textController.clear();
        Get.focusScope?.unfocus();
      });
    }catch(e){
      print("Could not add message ${e.toString()}");
    }
    var message_res = await db.collection("message").doc(doc_id).withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    ).get();
    if(message_res.data()!=null) {
      var item = message_res.data()!;
      to_uid = item.to_uid;
      from_uid = item.from_uid;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_uid == user_id) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      try{
        await db.collection("message")
            .doc(doc_id)
            .update({
          "to_msg_num": to_msg_num,
          "from_msg_num": from_msg_num,
          "last_msg": sendContent,
          "last_time": Timestamp.now()
        });
      }catch(e){
        print("error ${e.toString()}");
      }

    }

    var userbase = await FirebaseFirestore.instance.collection("users").withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options)=>userdata.toFirestore(),
    ).where("id", isEqualTo: state.to_uid.value).get();

    if(userbase.docs.isNotEmpty) {
      var title = "Message made by $from_name";
      var body = sendContent;
      var token = userbase.docs.first.data().fcmtoken;
      if(token!=null){
        sendNotification(title, body, token);
      }
    }
  }
  @override
  void onReady(){
    super.onReady();
    var messages = FirebaseFirestore.instance.collection("message").doc(doc_id).collection("msglist")
    .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options)=>msgcontent.toFirestore()
    ).orderBy("addtime", descending: false);
    state.msgcontentList.clear();
    listener = messages.snapshots().listen((event) {
      for(var change in event.docChanges){
        switch(change.type){
          case DocumentChangeType.added:
            if(change.doc.data()!=null){
              state.msgcontentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
      state.msgcontentList.refresh();
    },

    onError: (error)=>print("Listen failed:  $error")
    );

    getLocation();
  }

  getLocation() async {
    try{
     var user_location= await FirebaseFirestore.instance.collection("users").where("id", isEqualTo: state.to_uid.value)
          .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options)=>userdata.toFirestore()).get();
      var location = user_location.docs.first.data().location;
      if(location!=""){
        state.to_location.value=location??"unknown";
      }else{
      }
    }catch(e){
      print("We have error $e");
    }
  }

  Future<void> sendNotification(String? title, String? body, String? token) async {
    if(title==null || body==null || token == null || from_uid == null){
      print("one of the info is null");
      return;
    }
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/messagesByRes/');
    var IosNotification={
      "data":{
        "doc_id":"${doc_id}",
        "to_uid":"${to_uid}",
        "to_name":"${user_profile?.username}",
        "to_avatar":"${user_profile?.profile}"
      },
      "notification":
      {
        "body": "${body}",
        "title": "${title}",
        "content_available": true,
        "mutable_content":true,
        "sound":"task_cancel.caf",
        "badge":1
      },
      "to":"${token}"
    };
    String IosNotificationJson = jsonEncode(IosNotification);
    // android
    var AndroidNotification={
      "data":{
        "doc_id":"${doc_id}",
        "to_uid":"${from_uid}",
        "to_name":"${"Ahmed"}",
        "to_avatar":"${"cool"}"
      },
      "notification":
      {
        "body": body,
        "title": title,
        "android_channel_id":"com.szacheo.letschat1",
        "sound":"default",
      },
      "to": token
    };
    var restToken = await box.read("token");
    restToken = jsonDecode(restToken);
    String AndroidNotificationJson = jsonEncode(AndroidNotification);
    var notificationInfo = jsonEncode({
      "data":{
        "doc_id":"ahaha",
        "to_uid":from_uid,
        "to_name":"Ahmed",
        "to_avatar":"cool"
      },
      "notification":
      {
        "body": body,
        "title": title,
        "android_channel_id":"com.szacheo.letschat1",
        "sound":"default"
      },
      "to": "xys"
    });
    try{
      await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',

            'Authorization': 'Bearer $restToken'
          },
          //body: GetPlatform.isIOS?IosNotificationJson:AndroidNotificationJson

          body:notificationInfo
      );
    }catch(e){
      print("Error sending notification ${e.toString()}");
    }
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}