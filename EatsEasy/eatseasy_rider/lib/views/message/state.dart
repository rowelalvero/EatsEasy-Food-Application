
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/entities/message.dart';

class MessageState{

  RxList<Message> msgList = <Message>[].obs;
  //RxList<QueryDocumentSnapshot<Msg>> msgList = <QueryDocumentSnapshot<Msg>>[].obs;
}