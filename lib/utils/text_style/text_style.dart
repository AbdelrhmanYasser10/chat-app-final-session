import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyle{

   //static const String _fontName = "lora";


   static TextStyle appBarTextStyle(){
     return GoogleFonts.lora(
       textStyle:const TextStyle(
         fontSize: 24.0,
         color: Colors.black,
         fontWeight: FontWeight.bold,
       )
     );
   }

   static TextStyle buttonTextStyle(){
     return GoogleFonts.lora(
         textStyle:const TextStyle(
           fontSize: 18.0,
           color: Colors.white,
           fontWeight: FontWeight.bold,
         )
     );
   }

}