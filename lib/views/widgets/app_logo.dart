import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_management/controllers/color_controller.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color color;
  const AppLogo({super.key, this.size = 45, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      "DailyTask",
      style: GoogleFonts.pacifico(
        fontSize: size.sp,
        fontWeight: FontWeight.w600,
        shadows: [
          const Shadow(
            color: Colors.white,
            blurRadius: 1,
            offset: Offset(1, 1),
          )
        ],
        color: ColorController().colorFour,
      ),
    );
  }
}
