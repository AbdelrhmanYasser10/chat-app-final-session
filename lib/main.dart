import 'package:chat_app_final/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app_final/layout/main_layout.dart';
import 'package:chat_app_final/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.signOut();
    print(FirebaseAuth.instance.currentUser!.uid);
  }
  else{

  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(

          useMaterial3: false,
        ),
        home: FirebaseAuth.instance.currentUser != null ? const MainLayout() : const RegisterScreen(),
      ),
    );
  }
}

