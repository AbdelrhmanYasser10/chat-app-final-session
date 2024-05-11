import 'package:chat_app_final/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app_final/models/user_model.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/text_style/text_style.dart';

class ChatDetailsScreen extends StatefulWidget {
  final UserModel recieverUser;

  const ChatDetailsScreen({super.key, required this.recieverUser});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
 final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(widget.recieverUser.id);
        return BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {
            print(state);
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.0,
                      backgroundImage: NetworkImage(
                        widget.recieverUser.imageUrl,
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
                            widget.recieverUser.name,
                            style: AppTextStyle.nameTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.recieverUser.online ? "Online" : "Offline",
                            style: AppTextStyle.nameTextStyle().copyWith(
                                color: widget.recieverUser.online ? Colors.green : Colors
                                    .red,
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
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          bool iamASender=  cubit.messages[index].senderId == cubit.userModel!.id;
                          return BubbleSpecialThree(
                            text: cubit.messages[index].content,
                            color: iamASender ? Colors.green.shade400 :const Color(0xFFE8E8EE),
                            textStyle: TextStyle(
                              color: iamASender ?Colors.white : Colors.black,
                            ),
                            tail: true,
                            isSender: iamASender,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20.0,
                          );
                        },
                        itemCount: cubit.messages.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0,
                      left: 10,
                      right: 10.0
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                hintText: "Write your message....",
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        FloatingActionButton(
                            onPressed: () {
                              cubit.sentMessage(
                                  recieverId: widget.recieverUser.id,
                                  content: controller.text,
                              );
                              controller.clear();
                            },
                            child: const Icon(
                              Icons.send,
                            ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
    );
  }
}
