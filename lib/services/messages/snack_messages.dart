
import 'package:flutter/material.dart';
import 'package:task_management/controllers/color_controller.dart';
class SnackMessage{
  final Color color;
  final String texte;
  final Color closeIconColor;
  late  Color backgroundColor ;
  final BuildContext context;
   SnackMessage(this.context, {required this.texte,this.closeIconColor = Colors.white, this.color = Colors.black, Color? backgroundColor}): backgroundColor = backgroundColor ?? ColorController().colorFour;
   showMessage(){
     ScaffoldMessenger.of(context).clearSnackBars();
     SnackBar snackBar = SnackBar(
       behavior: SnackBarBehavior.floating,
       content: Text(texte,
     style: TextStyle(color: color),
     ),
     elevation: 5,
       showCloseIcon: true,
       closeIconColor: closeIconColor,
       backgroundColor: backgroundColor,

     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
}