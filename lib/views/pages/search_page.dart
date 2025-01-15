import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:task_management/services/data/get_user_datas.dart';
import 'package:task_management/services/shared_pref/search_history.dart';
import 'package:task_management/views/pages/task_page.dart';
import 'package:task_management/views/widgets/streams.dart';

import '../../controllers/color_controller.dart';
import '../../models/task.dart';
import '../../services/providers/task_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => setState(() {}),
                      style: GoogleFonts.inter(
                          fontSize: 17.sp, color: Colors.white),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Iconsax.search_normal,
                            color: Colors.grey,
                          ),
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () => setState(() {
                                        searchController.clear();
                                      }),
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  )),
                          hintText: "Rechercher une tache",
                          hintStyle: GoogleFonts.inter(
                              color: Colors.grey, fontSize: 17.sp),
                          fillColor: ColorController().colorFive,
                          filled: true,
                          border: const OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: filterTask,
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      color: ColorController().colorFour,
                      child: const Icon(Iconsax.filter),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
      body: searchController.text.isEmpty
          ? FutureBuilder(
              future: SearchHistory().getSearchHistory(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorController().colorFour,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text(
                      "Votre historique de recherche est vide",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                List<String> oldSearch = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Text(
                        "Recherches récentes",
                        style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: oldSearch.length,
                          itemBuilder: (_, index) {
                            String old = oldSearch[index];
                            return ListTile(
                                trailing: IconButton(
                                    onPressed: () => removeSearch(old),
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    )),
                                title: Text(
                                  old,
                                  style: const TextStyle(color: Colors.white),
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                );
              })
          : TasksStreamBuilder(
              stream: getTaskType(taskProvider.currentFilter),
              builder: (tasks) {
                List<Task> matched = tasks
                    .where((task) => task.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
                return (matched.isEmpty)
                    ? const Center(
                        child: Text(
                          "Aucune tache trouvée",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ListView.builder(
                          itemCount: matched.length,
                          itemBuilder: (_, index) {
                            Task currentTask = matched[index];
                            return ListTile(
                                onTap: () async {
                                  await SearchHistory()
                                      .saveSearch(currentTask.name);
                                  setState(() {
                                    searchController.clear();
                                    FocusScope.of(context).unfocus();
                                  });
                                  final route = MaterialPageRoute(builder: (_) {
                                    return TaskPage(task: currentTask);
                                  });
                                  Navigator.push(context, route);
                                },
                                title: Text(
                                  currentTask.name,
                                  style: const TextStyle(color: Colors.white),
                                ));
                          },
                        ),
                      );
              }),
    );
  }

  void filterTask() async {
    FocusScope.of(context).unfocus();

    await showModalBottomSheet(
        showDragHandle: true,
        backgroundColor: ColorController().colorFive,
        elevation: 5,
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (_) {
          return Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: ColorController().colorFive,
            ),
            child: Consumer<TaskProvider>(builder: (context, provider, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Toutes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        Radio<String>(
                          value: "all",
                          groupValue: provider.currentFilter,
                          onChanged: (String? value) {
                            provider.updateFilter(value!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'A faire',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          width: 35.w,
                        ),
                        Radio<String>(
                          value: "todo",
                          groupValue: provider.currentFilter,
                          onChanged: (String? value) {
                            provider.updateFilter(value!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Row(
                      //mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          'En cours',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Radio<String>(
                          value: "on-progress",
                          groupValue: provider.currentFilter,
                          onChanged: (String? value) {
                            provider.updateFilter(value!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'done',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          width: 40.w,
                        ),
                        Radio<String>(
                          value: "done",
                          groupValue: provider.currentFilter,
                          onChanged: (String? value) {
                            provider.updateFilter(value!);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTaskType(String filter) {
    GetUserDatas userDatas = GetUserDatas();
    switch (filter) {
      case "all":
        return userDatas.getAllTasks();
      case "todo":
        return userDatas.getTodoTasks();
      case "done":
        return userDatas.getDoneTasks();
      default:
        return userDatas.getOnprogressTasks();
    }
  }

  void removeSearch(String taskName) async {
    await SearchHistory().deleteOneSearchHistory(taskName);
    setState(() {});
  }
}
