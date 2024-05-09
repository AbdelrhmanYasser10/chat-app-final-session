class UserModel{

  late String email;
  late String name;
  late String imageUrl;
  late bool online;

  UserModel.fromMap(Map<String,dynamic> json){
    email = json["email"];
    name = json["name"];
    imageUrl = json["imageUrl"];
    online = json["online"];
  }

  Map<String,dynamic> toMap(){
    return {
      "email":email,
      "name":name,
      "imageUrl":imageUrl,
      "online":online,
    };
  }

}