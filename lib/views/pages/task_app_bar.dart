import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
class TaskActionAppBar extends PreferredSize {
  final String title;
  final BuildContext context;

  TaskActionAppBar({super.key, required this.title, required this.context})
      : super(
      preferredSize: Size.fromHeight(100.h),
      child: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Iconsax.arrow_left_2, color: Colors.white,)),
                  Text(title, style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 16.sp),),
                  //const SizedBox()
                ],
              )
          )
      )
  );
}
