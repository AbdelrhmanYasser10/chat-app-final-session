import 'package:chat_app_final/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app_final/screens/chat_details_screen.dart';
import 'package:chat_app_final/utils/text_style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getContacts();
        return BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);

            if(state is GetContactsLoading){
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            else{
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title: Text(
                    "Contacts",
                    style: AppTextStyle.appBarTextStyle(),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return ChatDetailsScreen(recieverUser: cubit.users[index]);
                                  },)
                            ,);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.blueGrey.shade100,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(
                                    cubit.users[index].imageUrl,
                                  ),
                                ),
                                const SizedBox(
                                  width: 25.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cubit.users[index].name,
                                        style: AppTextStyle.nameTextStyle(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        cubit.users[index].online?"Online":"Offline",
                                        style: AppTextStyle.nameTextStyle().copyWith(
                                          color: cubit.users[index].online?Colors.green : Colors.red,
                                          fontSize: 12.0
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20.0,
                      );
                    },
                    itemCount: cubit.users.length,
                  ),
                ),
              );
            }
          },
        );
      }
    );
  }
}
