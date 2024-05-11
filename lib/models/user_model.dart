import 'message_model.dart';

class UserModel{
  late String id;
  late String email;
  late String name;
  late String imageUrl;
  late bool online;
  MessageModel? lastMessage;

  UserModel.fromMap(Map<String,dynamic> json){
    id = json["id"];
    email = json["email"];
    name = json["username"];
    imageUrl = json["imageUrl"];
    online = json["online"];
  }

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "email":email,
      "username":name,
      "imageUrl":imageUrl,
      "online":online,
    };
  }

}