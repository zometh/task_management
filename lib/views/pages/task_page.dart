import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_management/controllers/color_controller.dart';

import 'package:task_management/models/task.dart';
import 'package:task_management/services/formatters/format_date.dart';
import 'package:task_management/views/pages/task_action.dart';

import '../../services/formatters/format_text.dart';
class TaskPage extends StatelessWidget {
  final Task task;
  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h), 
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(

              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.arrow_left_2, color: Colors.white,)),
                Text("Détails de la tâche", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20.sp),),

              ],
            ),
            ),
          )),
        

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 57.h,),
            Text(FormatText().formatDescription(task.name) ,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 21.sp
            ),
            ),
            SizedBox(height: 30.h,),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      color: ColorController().colorFour,
                      width: 47.w,
                      height: 47.w,
                      child: Icon(Iconsax.calendar_1, size: 24.w,),
                    ),
                    SizedBox(width: 8.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date prévue",
                        style: GoogleFonts.inter(fontSize: 12.sp,
                          color: ColorController().colorThree

                        ),
                        ),
                        Text(FormatDate().formatTaskDate(task.date.toDate()),
                          style: GoogleFonts.inter(fontSize: 17.sp,
                              color: Colors.white,
                            fontWeight: FontWeight.w700

                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20.h,),
            Text("Détails de la tâche",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              color: Colors.white,
            ),
            ),
            SizedBox(height: 5.h,),
            Text(task.description,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50.h,),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorController().colorFour,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: TextButton.icon(
                  onPressed: shareTask,
                  label: Text("Partager",
                      style: TextStyle(
                          fontFamily: 'PliatExtended',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18.sp))
                  ,
                  icon: const Icon(Icons.share, color: Colors.black,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> shareTask() async {
    final String shareText = """
Tâche: ${task.name}
Date prévue: ${FormatDate().formatTaskDate(task.date.toDate())}
Description: ${task.description}
""";
    await Share.share(shareText);
  }
}
