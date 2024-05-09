import 'package:chat_app_final/utils/text_style/text_style.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MyButton({super.key ,required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child:Center(
          child: Text(
              text,
            style: AppTextStyle.buttonTextStyle(),
          ),
        ),
      ),
    );
  }
}
