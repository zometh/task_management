import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:task_management/services/providers/navigation_provider.dart';
import 'package:task_management/views/pages/home.dart';
import 'package:task_management/views/pages/more_page.dart';
import 'package:task_management/views/pages/search_page.dart';
import 'package:task_management/views/pages/user_page.dart';
import 'package:task_management/views/widgets/bottom_navigation.dart';
import 'package:task_management/views/widgets/button.dart';

import '../../controllers/color_controller.dart';
import '../widgets/custom_textField.dart';
import '../widgets/custom_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [Home(), UserPage(), SearchPage(), MorePage()];
  late TextEditingController title;
  late TextEditingController description;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = TextEditingController();
    description = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NavigationProvider provider =
        Provider.of<NavigationProvider>(context, listen: true);
    return Scaffold(
        backgroundColor: ColorController().colorSixth,
        body: IndexedStack(
          index: provider.currentIndex,
          children: pages,
        ),
        floatingActionButton: FloatingActionButton(
          shape: const OvalBorder(),
          onPressed: showBottomSheet,
          backgroundColor: ColorController().colorFour,
          child: Icon(
            Icons.add,
            color: ColorController().eightColor,
            size: 35.sp,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        bottomNavigationBar: const CustomBottomNavigation());
  }

  showBottomSheet() {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        showDragHandle: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
        context: context,
        builder: (_) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3.0,
                sigmaY: 3.0,
              ),
              child: Container(
                height: size.height * 0.7,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: ColorController().eightColor),
                child: taskForm(),
              ));
        });
  }

  Widget taskForm() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            TaskTextField(controller: title, hintText: "Nom de la tache"),
            SizedBox(
              height: 5.h,
            ),
            TaskTextField(
                maxLines: 5,
                maxLength: 1000,
                controller: description,
                hintText: "Description"),
            addButton()
          ],
        ),
      ),
    );
  }

  Widget addButton() {
    return GestureDetector(
      onTap: addTask,
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: ColorController().colorFour,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: isLoading
              ? Row(
                  children: [
                    Text(
                      "Ajout en cours",
                      style: TextStyle(
                          fontFamily: 'PliatExtended',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                    CircularProgressIndicator(
                      color: ColorController().colorSixth,
                    )
                  ],
                )
              : Text(
                  "Ajouter",
                  style: TextStyle(
                      fontFamily: 'PliatExtended',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
        ),
      ),
    );
  }

  addTask() async {
    String titleContent = title.text;
    String descriptionContent = description.text;
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final String code = uid +
            titleContent +
            DateTime.now().toString() +
            Random().nextInt(9999).toString();
        await FirebaseFirestore.instance.collection('tasks').doc(code).set({
          "name": titleContent,
          "description": descriptionContent,
          "id": code,
          "idUser": uid,
          "date": Timestamp.now(),
          "state": 3
        }).then((onValue) {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Task added")));
          }
        });
      } catch (e) {
        debugPrint(e.toString());
        isLoading = false;
      }
    }
  }
}
