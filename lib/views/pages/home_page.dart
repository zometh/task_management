
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/services/providers/navigation_provider.dart';
import 'package:task_management/views/pages/home.dart';
import 'package:task_management/views/pages/more_page.dart';
import 'package:task_management/views/pages/search_page.dart';
import 'package:task_management/views/pages/user_page.dart';
import 'package:task_management/views/widgets/bottom_navigation.dart';

import '../../controllers/color_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [Home(), UserPage(), SearchPage(), MorePage()];


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
        floatingActionButton: (provider.currentIndex != 1)
        ? FloatingActionButton(
          shape: const OvalBorder(),
          onPressed: () => Navigator.pushNamed(context, '/add_task'),
          backgroundColor: ColorController().colorFour,
          child: Icon(
            Icons.add,
            color: ColorController().eightColor,
            size: 35.sp,
          ),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        bottomNavigationBar: const CustomBottomNavigation());
  }








}
