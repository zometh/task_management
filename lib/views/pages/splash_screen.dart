import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/color_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorController().colorSixth,
      appBar: AppBar(
        backgroundColor: ColorController().colorSixth,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "lib/assets/imgs/logo.png",
              height: 60.92.h,
              width: 139.w,
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Container(
                width: 350.w,
                height: 270.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  "lib/assets/imgs/Character.png",
                  height: 60.92.h,
                  width: 139.w,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Gérer vos taches avec ",
              style: GoogleFonts.montserrat(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "DayTask",
              style: GoogleFonts.montserrat(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: ColorController().colorFour),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  width: size.width * 0.75,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorController().colorFour,
                  ),
                  child: Text(
                    "Commencer",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
