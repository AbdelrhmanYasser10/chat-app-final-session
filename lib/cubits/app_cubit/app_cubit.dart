import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());


  static AppCubit get(context)=>BlocProvider.of(context);

  //image instances
  ImagePicker picker = ImagePicker();
  XFile? image;
  CroppedFile? finalImage;



  //firebase instances
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;


  void pickImage()async{
    image = await picker.pickImage(
        source: ImageSource.gallery,
    );
    if(image == null){
      emit(GetImageError());
    }
    else{
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
    if(finalImage !=null){
      emit(CroppedSuccessfully());
    }
    else{
      emit(CroppedError());
    }
  }

  void register(){

  }

  void login(){

  }

}
