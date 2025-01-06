import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/services/formatters/format_text.dart';
import 'package:task_management/views/pages/tasks_view.dart';
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
          return DefaultTabController(
            length: _tabController.length,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(165.h),
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
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(FormatText().formatTitle(user.prenom),
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.normal,

                                          )),
                                      Text(FormatText().formatTitle(user.nom),
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.normal,

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
                          tabBar()
                        ],
                      ),
                    ),
                  )),

              body: TabBarView(
                controller: _tabController,
                children: menus,
              ),
            ),
          );
        });
  }
  TabBar tabBar(){
    return TabBar(
      padding: EdgeInsets.only(right: 15.w),
      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
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
    );
  }

}
