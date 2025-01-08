import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends AppBar{
  final String appBarTitle;
   CustomAppBar({super.key, required this.appBarTitle}): super(
     backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    title: Text(
      appBarTitle,
      style: GoogleFonts.inter(
        fontSize: 20.sp,
        color: Colors.white,
      ),
    ),
  );
}