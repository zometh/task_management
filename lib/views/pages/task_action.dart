import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_management/enum/task_state.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/services/formatters/format_date.dart';
import 'package:task_management/views/pages/task_app_bar.dart';
import 'package:uuid/v4.dart';

import '../../controllers/color_controller.dart';
import '../widgets/custom_textField.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController title;
  late TextEditingController description;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   DateTime dateTime = DateTime.now();
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
    return Scaffold(
      appBar: TaskActionAppBar(title: "Ajout d'une tache", context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text("Nom de la tache",
                  style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TaskTextField(controller: title),

                Text("Description",
                  style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),SizedBox(
                  height: 5.h,
                ),
                TaskTextField(
                  maxLines: 5,
                  maxLength: 1000,
                  controller: description,

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Choisir la date", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),),
                    IconButton(onPressed: (){
                      _pickDate();
                    }, icon: Icon(Iconsax.calendar, color: ColorController().colorFour,)
                    ),


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),),

                    Text(FormatDate().formatTaskDate(dateTime),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                addButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget addButton() {
    return GestureDetector(
      onTap: addTask,
      child: Container(
        width: double.infinity,
        height: 55.h,
        decoration: BoxDecoration(
          color: ColorController().colorFour,
          borderRadius: BorderRadius.circular(5),
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
                fontSize: 19.sp),
          ),
        ),
      ),
    );
  }
  addTask() async {
    String titleContent = title.text.trim();
    String descriptionContent = description.text.trim();
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        String uuid = const UuidV4().generate();
        final String code = uid+uuid+
            DateTime.now().toString() +
            Random().nextInt(9999).toString();
        await FirebaseFirestore.instance.collection('tasks').doc(code).set({
          "name": titleContent,
          "description": descriptionContent,
          "id": code,
          "idUser": uid,
          "date": Timestamp.fromDate(dateTime),
          "state": 3
        }).then((onValue) {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar( SnackBar(content: const Text("Tache ajoutée", style: TextStyle(color: Colors.black),), backgroundColor: ColorController().colorFour,));
          }
        });
      } catch (e) {
        debugPrint(e.toString());
        isLoading = false;
      }
    }
  }
  _pickDate() async{
    DateTime? date = await showDatePicker(

      locale: const Locale("fr","FR"),
      barrierDismissible: false,
      helpText: "Choisir la date",
      initialEntryMode: DatePickerEntryMode.calendar,
      context: context, firstDate: DateTime.now(), lastDate: DateTime(2077),

    );
    if(date != null){
      setState(() {
        dateTime = date;
      });
    }
  }
}
class EditTask extends StatefulWidget {
  final Task task;
  const EditTask({super.key, required this.task});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
   Task get task => widget.task;
  late TextEditingController title;
  late TextEditingController description;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DateTime dateTime;
  bool isLoading = false;
   late int selectedOption;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = TextEditingController(text: task.name);
    description = TextEditingController(text: task.description);
    dateTime = task.date.toDate();
    selectedOption = getStateInt(task.state);

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
    return Scaffold(
      appBar: TaskActionAppBar(title: "Modifier la tache", context: context,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Form(
            key: formKey,
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text("Nom de la tache",
                style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TaskTextField(controller: title),

                Text("Description de la tache",
                  style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TaskTextField(
                    maxLines: 5,
                    maxLength: 1000,
                    controller: description,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Choisir la date", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp, color: Colors.white),),
                    IconButton(onPressed: (){
                      _pickDate();
                    }, icon: Icon(Iconsax.calendar, color: ColorController().colorFour,)
                    ),


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp, color: Colors.white),),

                    Text(FormatDate().formatTaskDate(dateTime),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp),
                    )
                  ],
                ),
                SizedBox(height: 10.h,),
                Text("Etat",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16.sp, color: Colors.white),
                ),
                Row(
                  children: [
                    Text('A faire',style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(width: 30.w,),
                    Radio<int>(
                      value: 3,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                          print("Selected Option: $selectedOption");
                        });
                      },
                    ),
                  ],
                ),
            Row(
              //mainAxisSize: MainAxisSize.min,

              children: [

                 Text('En cours',style: Theme.of(context).textTheme.titleMedium,),
                SizedBox(width: 17.w,),
                Radio<int>(
                  value: 2,
                  groupValue: selectedOption,
                  onChanged: (int? value) {
                    setState(() {
                      selectedOption = value!;
                      print("Selected Option: $selectedOption");
                    });
                  },
                ),
              ],
            ),
                Row(
                  children: [
                    Text('Terminée', style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(width: 17.w,),
                    Radio<int>(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                          print("Selected Option: $selectedOption");
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                editButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

   int getStateInt(TasksState value) {
     switch (value) {
       case TasksState.DONE:
         return 1;
       case TasksState.ON_PROGRESS:
         return 2;
       case TasksState.TO_DO:
         return 3;
     }


   }
  Widget editButton() {
    return GestureDetector(
      onTap: editTask,
      child: Container(
        width: double.infinity,
        height: 55.h,
        decoration: BoxDecoration(
          color: ColorController().colorFour,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: isLoading
              ? Row(
            children: [
              Text(
                "Modification en cours",
                style: TextStyle(
                    fontFamily: 'PliatExtended',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
              CircularProgressIndicator(
                color: ColorController().colorSixth,
              )
            ],
          )
              : Text(
            "Modifier",
            style: TextStyle(
                fontFamily: 'PliatExtended',
                fontWeight: FontWeight.bold,
                fontSize: 20.sp),
          ),
        ),
      ),
    );
  }
   editTask() async {
     String titleContent = title.text.trim();
     String descriptionContent = description.text.trim();
     if (formKey.currentState!.validate()) {
       try {
         isLoading = true;
         final String uid = FirebaseAuth.instance.currentUser!.uid;

         await FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
           "name": titleContent,
           "description": descriptionContent,
           "date": Timestamp.fromDate(dateTime),
           "state": selectedOption
         }).then((onValue) {
           if (mounted) {
             Navigator.pop(context);
             ScaffoldMessenger.of(context)
                 .showSnackBar( SnackBar(content: const Text("Tache modifiée", style: TextStyle(color: Colors.black)), backgroundColor: ColorController().colorFour,));
           }
         });
       } catch (e) {
         debugPrint(e.toString());
         isLoading = false;
       }
     }
   }
   _pickDate() async{
     DateTime? date = await showDatePicker(

       locale: const Locale("fr","FR"),
       barrierDismissible: false,
       helpText: "Choisir la date",
       initialEntryMode: DatePickerEntryMode.calendar,
       context: context, firstDate: DateTime.now(), lastDate: DateTime(2077),

     );
     if(date != null){
       setState(() {
         dateTime = date;
       });
     }
   }
}


