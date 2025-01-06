import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/enum/task_state.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/services/formatters/format_date.dart';
import 'package:task_management/services/formatters/format_text.dart';
import 'package:task_management/views/pages/task_action.dart';
import 'package:task_management/views/pages/task_page.dart';
class TaskTile extends StatefulWidget {
  final Task task;
  const TaskTile({super.key, required this.task});
  @override
  State<TaskTile> createState() => _TaskTileState();
}
class _TaskTileState extends State<TaskTile>{
  Task get task => widget.task;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        final route = MaterialPageRoute(builder: (_){
          return TaskPage(task: task);
        });
        Navigator.push(context, route);
      },
      child: Card(
        color: ColorController().colorFive,
        child: SizedBox(
          height: 100.h,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(FormatText().formatDescription(task.name),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18.sp),

                        ),
                        SizedBox(height: 7.h,),
                        Text(FormatText().formatDescription(task.description.toLowerCase()),
                          style: GoogleFonts.inter(color: Colors.white,

                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 7.h,),
                        Text( "Date prévue : ${FormatDate().formatTaskDate(task.date.toDate())}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                        )
                      ],
                    ),
                     Column(
                       children: [

                        PopupMenuButton(
                          onSelected: (value){
                            switch(value){
                              case 'edit':
                                final route = MaterialPageRoute(builder: (_) => EditTask(task: task));
                                Navigator.push(context, route);
                              case 'delete':
                                showTaskDialog();

                            }
                          },
                          style: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(10),
                            overlayColor: WidgetStatePropertyAll(ColorController().colorFour),
                          ),
                          iconColor: Colors.white,
                            color: ColorController().colorSixth,
                            itemBuilder: (_){
                             return <PopupMenuEntry<String>>[

                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit, color: Colors.blue),
                                      title: Text('Modifier', style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete, color: Colors.red),
                                    title: Text('Supprimer', style: TextStyle(color: Colors.white),),
                                  ),
                                ),

                              ];
                        }),
                         CircleAvatar(backgroundColor: getColorByState(task.state),radius: 10,)
                       ],
                     )
                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );

  }
  showTaskDialog() async{
    await showDialog(

        barrierDismissible: false,
        context: context, builder: (_){
      return BackdropFilter(filter: ImageFilter.blur(
        sigmaY: 5,
        sigmaX: 5
      ),
      child: AlertDialog(

        backgroundColor: ColorController().colorSixth,
        content: Text("Etes-vous sur de vouloir supprimer cette tache?",
          style: GoogleFonts.signika(fontSize: 15, color: Colors.white),
        ),
        title: Text("Supprimer une tache",
          style: GoogleFonts.signika(fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          ElevatedButton(onPressed: (){
            removeTask();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tache supprimée!", style: TextStyle(color: Colors.white70)), backgroundColor: Colors.green,));

          },
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.red)
            ), child: const Text("Oui",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ),
          ElevatedButton(onPressed: () => Navigator.pop(context),
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.blue)
            ), child: const Text("Non",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          ),
        ],
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      );
    });
  }
  removeTask() async{
    try{
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).delete().then((onValue){




      });
    }catch (e){
      debugPrint(e.toString());
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Une erreur est survenue, veuillez ressayer plus-tard!", style: TextStyle(color: Colors.black)), backgroundColor: ColorController().colorFour,));
    }
  }
  Color getColorByState(TasksState state){
    switch(state){
      case TasksState.TO_DO : return ColorController().toDoColor;
      case TasksState.ON_PROGRESS: return ColorController().onProgressColor;
      
      case TasksState.DONE: return ColorController().doneColor;
    }
  }


}
