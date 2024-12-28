import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends Text {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  CustomTitle(
      {super.key,
      required this.text,
      this.fontSize = 26,
      this.color = Colors.white,
      this.fontWeight = FontWeight.normal})
      : super(text,
            style: GoogleFonts.inter(
                fontSize: fontSize.sp, color: color, fontWeight: fontWeight));
}
