

import 'package:chat_app_final/cubits/app_cubit/app_cubit.dart';
import 'package:flutter/material.dart';

import '../screens/chats_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/profile_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {


  List<Widget> screens = const [
    ContactsScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  int currentIndex= 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused || state == AppLifecycleState.detached || state == AppLifecycleState.inactive){
      AppCubit.get(context).setUserOffline();
    }
    else{
      AppCubit.get(context).setUserOnline();

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {

          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.contacts_outlined,
              ),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_sharp,
              ),
            label: "Chats",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
              ),
            label: "Profile",
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
