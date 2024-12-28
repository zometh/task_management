import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/services/providers/auth_provider.dart';
import 'package:task_management/services/shared_pref/SharedPref.dart';
import 'package:task_management/views/pages/task_view.dart';
import 'package:task_management/views/widgets/button.dart';
import 'package:task_management/views/widgets/custom_textField.dart';
import 'package:task_management/views/widgets/custom_title.dart';

import '../../models/user_mine.dart';
import '../../services/data/get_user_datas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menus = [
      const AllTaskPage(),
      const TasksOnProgressPage(),
      const TasksTodoPage(),
      const TasksDonePage()
    ];
    return StreamBuilder(
        stream: GetUserDatas().getConnectedUserInfos(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorController().colorFour,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Aucune information trouvée"),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text("Erreur: ${snapshot.error.toString()}"),
            );
          }
          final data = snapshot.data!.data();
          final UserMine user = UserMine.fromJson(data!);
          Size size = MediaQuery.of(context).size;
          return DefaultTabController(
            length: _tabController.length,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(200.h),
                  child: SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 28.h, left: 13.w, right: 13.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTitle(
                                    text: "Bienvenue!",
                                    fontSize: 18.9,
                                    color: ColorController().colorFour,
                                  ),
                                  Wrap(
                                    direction: Axis.vertical,
                                    children: [
                                      Text(user.prenom,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'PliatExtended',
                                            fontSize: 25.sp,
                                          )),
                                      Text(user.nom,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'PliatExtended',
                                            fontSize: 25.sp,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(user.imageUrl),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          TabBar(
                            padding: EdgeInsets.only(right: 15.w),
                            labelPadding: EdgeInsets.symmetric(horizontal: 0),
                            controller: _tabController,
                            indicatorColor: ColorController().colorFour,
                            dividerHeight: 0,
                            unselectedLabelStyle: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: 'PliatExtended',
                            ),
                            labelStyle: TextStyle(
                                fontFamily: 'PliatExtended',
                                fontSize: 13.sp,
                                color: ColorController().colorFour),
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: ColorController().colorFour),
                                insets: const EdgeInsets.all(5)),
                            automaticIndicatorColorAdjustment: true,
                            tabs: const [
                              Tab(
                                text: "Toutes",
                              ),
                              Tab(
                                text: "En cours",
                              ),
                              Tab(
                                text: "A faire",
                              ),
                              Tab(
                                text: "Terminées",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
              backgroundColor: ColorController().colorSixth,
              body: TabBarView(
                controller: _tabController,
                children: menus,
              ),
            ),
          );
        });
  }
}
