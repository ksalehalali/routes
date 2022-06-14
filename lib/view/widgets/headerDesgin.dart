import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Assistants/globals.dart';

Widget Header (size){
  return Container(
    width: double.infinity,
    height: size.height *0.1.h,

      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            routes_color6,
            routes_color,
          ]

      ),
        boxShadow: [
          BoxShadow(
            color: Colors.red,
          ),
          BoxShadow(
            color: routes_color7,
            blurRadius: 6.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          )
        ]
    ),
    child: Padding(
      padding:  EdgeInsets.only(top: 19.0.h,bottom: 12.h),
      child: Image.asset('assets/images/routes/logo_white_300.png',height: 30.h,width: 30.w,fit: BoxFit.contain,),
    )
  );
}