import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/views/widgets/vertical_spacer.dart';

class CustomTextField extends StatefulWidget {
  final Widget? trailing;
  final IconData leading;
  final bool hidePassword;
  final String hintText;
  final double heigth;
  final Color hintColor;
  final Color leadingColor;
  final TextEditingController controller;

  final bool showSuffix;
  const CustomTextField(
      {super.key,
      this.trailing,
      required this.leading,
      required this.controller,
      this.hidePassword = false,
      this.hintText = "",
      this.heigth = 65,
      this.hintColor = Colors.white,
      this.leadingColor = Colors.white,
      this.showSuffix = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.heigth.h,
          child: TextField(
            //textAlign: TextAlign.center,
            controller: widget.controller,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20.sp,
            ),

            obscureText: widget.hidePassword,
            decoration: InputDecoration(
              labelStyle:
                  GoogleFonts.signika(color: Colors.white, fontSize: 20.sp),
              hintText: widget.hintText,
              suffix: widget.showSuffix
                  ? widget.controller.text != ""
                      ? IconButton(
                          onPressed: () {
                            widget.controller.text = "";
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ))
                      : const SizedBox.shrink()
                  : widget.trailing,
              prefixIcon: Icon(
                widget.leading,
                color: widget.leadingColor,
              ),
              hintStyle: GoogleFonts.inter(
                fontSize: 20.sp,
                color: widget.hintColor,
              ),
              filled: true,
              fillColor: ColorController().colorFive,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class TaskTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final int maxLines;
  const TaskTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.maxLength = 50,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.signika(color: Colors.white, fontSize: 20.sp),
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: (value) {
        if (value!.isEmpty) {
          return "Veuillez renseigner quelque chose";
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: ColorController().colorFour)),
          hintText: hintText,
          hintStyle: GoogleFonts.signika(color: Colors.grey, fontSize: 20.sp)),
    );
  }
}
