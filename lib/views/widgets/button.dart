import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/main.dart';

class CustomButton extends StatelessWidget {
  final Widget widget;
  final double heigth;
  final double width;
  const CustomButton(
      {super.key, required this.widget, this.heigth = 67, this.width = 376});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: heigth.h,
      width: width.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorController().colorFour,
      ),
      child: widget,
    );
  }
}
