import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_management/services/data/get_user_datas.dart';
import 'package:task_management/services/shared_pref/SharedPref.dart';
import 'package:task_management/views/pages/custom_appbar.dart';
import 'package:task_management/views/pages/task_page.dart';
import 'package:task_management/views/widgets/streams.dart';

import '../../controllers/color_controller.dart';
import '../../models/task.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchController;
  @override
  void initState(){
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
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(130.h),
          child: SafeArea(child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 50.h,),
               TextField(
                          controller: searchController,
                          onChanged: (value) => setState(() {

                          }),
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            color: Colors.white
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.search_normal, color: Colors.grey,),
                            suffixIcon: searchController.text.isEmpty
                                    ? null : IconButton(
                                                                    onPressed: () => setState(() {
                                                                      searchController.clear();
                                                                    }),
                                                                    icon: const Icon(Icons.clear, color: Colors.white,)
                                                                ),
                            hintText: "Rechercher une tache",
                            hintStyle: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 17.sp
                            ),
                            fillColor: ColorController().colorFive,
                            filled: true,
                            border: OutlineInputBorder()
                          ),
                        )


              ],
            ),
          )),
      ),
      body: searchController.text.isEmpty
            ? FutureBuilder(
          future: SharedPref().getSearchHistory(),
          builder: (_, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(
                  color: ColorController().colorFour,
                ),
              );
            }
            if(!snapshot.hasData || snapshot.data == null){
              return const Center(
                child: Text("Votre historique de recherche est vide", style: TextStyle(color: Colors.white),),
              );
            }
            List<String> oldSearch = snapshot.data!;
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Text("Recherches récentes",
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),

                  ),
                  SizedBox(height: 15.h,),
                  Expanded(
                    child: ListView.builder(

                      itemCount: oldSearch.length,
                      itemBuilder: (_, index){
                        String old = oldSearch[index];
                        return ListTile(

                            trailing: IconButton(
                                onPressed: () => removeSearch(old),
                                icon: const Icon(Icons.clear, color: Colors.white,)
                            ),
                            title: Text(old, style: const TextStyle(color: Colors.white),));
                      },
                    ),
                  )
                ],
              ),
            );
          }
      )
          : TasksStreamBuilder(
          stream: GetUserDatas().getAllTasks(),
          builder: (tasks){
            List<Task> matched = tasks.where(
                (task) => task.name.toLowerCase().contains(searchController.text.toLowerCase())
            ).toList();
            return (matched.isEmpty) ?
               const Center(
                child: Text("Aucune tache trouvée", style: TextStyle(color: Colors.white),),
              )

             : Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
               child: ListView.builder(
                itemCount: matched.length,
                itemBuilder: (_, index){
                  Task currentTask = matched[index];
                  return ListTile(
                      onTap: () async{
                        await SharedPref().saveSearch(currentTask.name);
                        setState(() {
                          searchController.clear();
                          FocusScope.of(context).unfocus();
                        });
                        final route = MaterialPageRoute(builder: (_){
                          return TaskPage(task: currentTask);
                        });
                        Navigator.push(context, route);
                      },
                      title: Text(currentTask.name, style: TextStyle(color: Colors.white),));
                },
                           ),
             );
          }
      ),
      );

  }
  void removeSearch(String taskName) async{
    await SharedPref().deleteOneSearchHistory(taskName);
    setState(() {

    });
  }
}
