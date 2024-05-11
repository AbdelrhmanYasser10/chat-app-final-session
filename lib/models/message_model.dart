import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  late String content;
  late String senderId;
  late String recieverId;
  late Timestamp time;

  MessageModel({required this.content,required this.senderId, required this.recieverId,required this.time});
  MessageModel.formJson(Map<String,dynamic>json){
    content = json['content'];
    senderId = json['senderId'];
    recieverId = json['recieverId'];
    time = json['time'];
  }

  Map<String,dynamic> toMap(){
    return {
      'content':content,
      'senderId':senderId,
      'recieverId':recieverId,
      'time':time,
    };
  }
}