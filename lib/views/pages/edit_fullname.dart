import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/models/user_mine.dart';
import 'package:task_management/views/pages/custom_appbar.dart';

import '../widgets/button.dart';
import '../widgets/custom_textField.dart';
import '../widgets/custom_title.dart';
import '../widgets/vertical_spacer.dart';

class EditFullNamePage extends StatefulWidget {
  final UserMine userMine;
  const EditFullNamePage({super.key, required this.userMine});

  @override
  State<EditFullNamePage> createState() => _EditFullNamePageState();
}

class _EditFullNamePageState extends State<EditFullNamePage> {
  UserMine get user => widget.userMine;

  late TextEditingController prenom;
  late TextEditingController nom;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    nom = TextEditingController(text: user.nom);
    prenom = TextEditingController(text: user.prenom);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    prenom.dispose();

    nom.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "Modifier nom complet"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50.h,),
            CustomTextField(
              leading: Icons.account_circle,
              controller: prenom,
              hintText: "Prénom",
            ),
            VerticalSpacer(
              height: 27,
            ),
            CustomTextField(
              leading: Icons.account_circle,
              controller: nom,
              hintText: "Nom",
            ),
            VerticalSpacer(
              height: 27,
            ),
        GestureDetector(
          onTap: _update,
          child: CustomButton(
              widget: CustomTitle(
                text: "Modifier",
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              )))
          ],
        ),
      ),
    );
  }
  _update() async{
    try{
      String firstname = prenom.text.trim();
      String lastname = nom.text.trim();
      await FirebaseFirestore.instance.
    collection('users').doc(user.id)
      .update({
        'prenom': firstname,
        'nom': lastname
      }).then((onValue){
        Navigator.pop(context);
      });
    }catch (e){
      debugPrint(e.toString());
    }
  }
}
