import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app_final/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../models/user_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  //image instances
  ImagePicker picker = ImagePicker();
  XFile? image;
  CroppedFile? finalImage;

  //firebase instances
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  UserModel? userModel;

  void pickImage() async {
    image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      emit(GetImageError());
    } else {
      emit(GetImageSuccessfully());
    }
  }

  void cropImage() async {
    finalImage = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (finalImage != null) {
      emit(CroppedSuccessfully());
    } else {
      emit(CroppedError());
    }
  }

  void register({
    required String email,
    required String password,
    required String username,
  }) {
    emit(RegisterLoading());
    if (finalImage == null) {
      emit(RegisterError(message: "Image is Required"));
    } else {
      _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        _storage
            .ref("usersImages")
            .child(finalImage!.path.split("/").last)
            .putFile(
              File(finalImage!.path),
            )
            .then((image) {
          image.ref.getDownloadURL().then((imageUrl) {
            _database.collection("users").doc(value.user!.uid).set({
              "id": value.user!.uid,
              "username": username,
              "email": email,
              "imageUrl": imageUrl,
              "online": true,
            }).then((x) {
              userModel = UserModel.fromMap({
                "id": value.user!.uid,
                "username": username,
                "email": email,
                "imageUrl": imageUrl,
                "online": true,
              });
              var acs = ActionCodeSettings(

                  url: 'https://principal-truck-401321.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
                  handleCodeInApp: true,
                  iOSBundleId: 'com.example.chatAppFinal.RunnerTests',
                  androidPackageName: 'com.example.chat_app_final',
                  androidInstallApp: true,
                  androidMinimumVersion: '12');
              _auth
                  .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
                  .catchError((onError) =>
                      print('Error sending email verification $onError'))
                  .then(
                      (value) => print('Successfully sent email verification'));
              emit(RegisterSuccessfully());
            }).catchError((error) {
              emit(RegisterError(
                  message: "Registration Failed,try again later"));
            });
          }).catchError((error) {
            emit(RegisterError(message: "Registration Failed,try again later"));
          });
        }).catchError((error) {
          emit(RegisterError(message: "Registration Failed,try again later"));
        });
      }).catchError((error) {
        emit(RegisterError(message: "Registration Failed,try again later"));
      });
    }
  }

  void setUserOffline() {
    userModel!.online = false;
    _database
        .collection("users")
        .doc(userModel!.id)
        .set(
          userModel!.toMap(),
        )
        .then((value) {
      emit(SetUserOffline());
    });
  }

  void setUserOnline() {
    userModel!.online = true;
    _database
        .collection("users")
        .doc(userModel!.id)
        .set(
          userModel!.toMap(),
        )
        .then((value) {
      emit(SetUserOnline());
    });
  }

  void login({required String email,required String password}) {
    emit(LoginLoading());
    _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      //set user online;
      //setUserOnline();
      //get data
      _database.
      collection("users").
      doc(value.user!.uid).
      get().then((value){
        userModel = UserModel.fromMap(value.data()!);
        setUserOnline();
        emit(LoginSuccessfully());
      }).catchError((error){
        emit(LoginError(message:error.toString()));
      });
    }).catchError((error){
      emit(LoginError(message:error.toString()));
    });

  }

  void getUserData() {
    emit(GetUserDataLoading());
    if (_auth.currentUser != null) {
      _database
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        userModel = UserModel.fromMap(value.data()!);
        emit(GetUserDataSuccess());
      }).catchError((error) {
        emit(GetUserDataError());
      });
    } else {
      emit(GetUserDataError());
    }
  }

  List<UserModel> users = [];

  void getContacts() {

    emit(GetContactsLoading());
    _database.
    collection("users")
    .snapshots().listen((event) {
      users = [];
      for (var element in event.docs) {
        if(element.id != userModel!.id){
          users.add(UserModel.fromMap(element.data()));
        }
      }
      emit(GetContactsSuccess());
    });
  }

  void sentMessage({required String recieverId , required String content}){
    var myId = _auth.currentUser!.uid;

    MessageModel message = MessageModel(
      content: content,
      recieverId: recieverId,
      senderId: myId,
      time: Timestamp.now(),
    );
    _database.
    collection("users").
    doc(myId).
    collection("chats").
    doc(recieverId).
    collection("messages").
    add(message.toMap()).then((value){
      emit(SendMessageSuccess());
    }).catchError((error){
      emit(SendMessageError());
    });
    _database.
    collection("users").
    doc(recieverId).
    collection("chats").
    doc(myId).
    collection("messages").
    add(message.toMap()).then((value){
      emit(SendMessageSuccess());
    }).catchError((error){
      emit(SendMessageError());
    });
  }

  List<MessageModel> messages =[];
  void getMessages(String recieverId){
    _database.
    collection('users').
    doc(userModel!.id).
    collection('chats').
    doc(recieverId).
    collection('messages').
    orderBy('time').
    snapshots().listen((event) {
      messages = [];
      event.docs.forEach((element) {
      messages.add(MessageModel.formJson(element.data()));
      });
      emit(GetMessages());
    });
  }
}
