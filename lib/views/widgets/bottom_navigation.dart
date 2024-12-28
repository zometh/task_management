import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/main.dart';
import 'package:task_management/services/providers/navigation_provider.dart';

import '../pages/home.dart';
import '../pages/more_page.dart';
import '../pages/user_page.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        label: "Accueil",
        tooltip: "Page d'accueil",
        icon: Icon(
          Iconsax.home,
        )),
    BottomNavigationBarItem(
        label: "Mon compte",
        icon: Icon(
          Iconsax.user,
        ),
        tooltip: "Mon compte"),
    BottomNavigationBarItem(
        label: "Rechercher",
        icon: Icon(
          Iconsax.search_normal,
        ),
        tooltip: "Rechercher"),
    BottomNavigationBarItem(
        label: "Plus",
        icon: Icon(
          Iconsax.more,
        ),
        tooltip: "Plus"),
  ];

  @override
  Widget build(BuildContext context) {
    NavigationProvider provider =
        Provider.of<NavigationProvider>(context, listen: true);
    return BottomNavigationBar(
      elevation: 10,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ColorController().colorFour,
      backgroundColor: ColorController().eightColor,
      currentIndex: provider.currentIndex,
      selectedIconTheme: IconThemeData(color: ColorController().colorFour),
      items: items,
      onTap: (newIndex) {
        context.read<NavigationProvider>().changeIndex(newIndex);
      },
    );
  }
}
