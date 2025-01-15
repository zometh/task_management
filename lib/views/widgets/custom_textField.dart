import 'dart:ui';

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

  const CustomTextField({
    super.key,
    this.trailing,
    required this.leading,
    required this.controller,
    this.hidePassword = false,
    this.hintText = "",
    this.heigth = 70,
    this.hintColor = Colors.white,
    this.leadingColor = Colors.white,
    this.showSuffix = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.heigth.h,
        maxHeight: widget.heigth.h,
      ),
      child: TextFormField(
        validator: (value) =>
            value!.isEmpty ? "Veuillez remplir ce champs" : null,
        onChanged: (value) {
          setState(() {});
        },
        controller: widget.controller,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 20.sp,
        ),
        obscureText: widget.hidePassword,
        decoration: InputDecoration(
          // Ajout d'un padding vertical constant
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          isDense: false, // Empêche la compression du TextField
          labelStyle: GoogleFonts.signika(
            color: Colors.white,
            fontSize: 20.sp,
          ),
          hintText: widget.hintText,
          suffixIcon: widget.showSuffix
              ? widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : const SizedBox.shrink()
              : widget.trailing,
          prefixIcon: Icon(
            widget.leading,
            color: widget.leadingColor,
            size: 24.sp, // Taille d'icône constante
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: 20.sp,
            color: widget.hintColor,
          ),
          filled: true,
          fillColor: ColorController().colorFive,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8.r), // Ajout d'un border radius constant
          ),
          // Assure que tous les bords ont le même style
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: ColorController().colorFour),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide:
                BorderSide(color: ColorController().colorFour, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

/*
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
      this.heigth = 70,
      this.hintColor = Colors.white,
      this.leadingColor = Colors.white,
      this.showSuffix = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.heigth.h,
        constraints: BoxConstraints(minHeight: widget.heigth.h),
      child: TextFormField(
        selectionHeightStyle: BoxHeightStyle.max,
        validator: (value) => value!.isEmpty ? "Veuillez remplir ce champs" : null,
        onChanged: (value){
          setState(() {

          });
        },
        //textAlign: TextAlign.center,
        controller: widget.controller,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 20.sp,
        ),

        obscureText: widget.hidePassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.h), // Ajoute un padding vertical constant
          isDense: false,
          labelStyle:
              GoogleFonts.signika(color: Colors.white, fontSize: 20.sp),
          hintText: widget.hintText,
          suffix: widget.showSuffix
              ? widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                      },
                      icon: const Icon(
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
    );
  }
}
*/
class TaskTextField extends StatelessWidget {
  final TextEditingController controller;

  final int maxLength;
  final int maxLines;
  const TaskTextField(
      {super.key,
      required this.controller,
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
        counterStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(
            //borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent)),
        filled: true,
        fillColor: ColorController().colorFive,
      ),
    );
  }
}
