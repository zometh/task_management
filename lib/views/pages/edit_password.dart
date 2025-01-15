import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/models/user_mine.dart';
import 'package:task_management/services/messages/snack_messages.dart';
import 'package:task_management/views/pages/custom_appbar.dart';

import '../widgets/button.dart';
import '../widgets/custom_textField.dart';
import '../widgets/custom_title.dart';

class EditPassword extends StatefulWidget {
  final UserMine userMine;

  const EditPassword({super.key, required this.userMine});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  UserMine get user => widget.userMine;
  bool showPassword = false;
  bool showErrorMessage = false;
  bool _updating = false;
  late TextEditingController password;
  late TextEditingController newPassword;
  late TextEditingController confirmPassword;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    password = TextEditingController();
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    password.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "Modifier mot de passe"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Form(
          key: key,
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              CustomTextField(
                hintText: "Ancien mot de passe",
                leading: Icons.lock,
                hidePassword: showPassword,
                controller: password,
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword ? Iconsax.eye : Iconsax.eye_slash,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                hintText: "Nouveau mot de passe",
                leading: Icons.lock,
                hidePassword: showPassword,
                controller: newPassword,
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword ? Iconsax.eye : Iconsax.eye_slash,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              _updating
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorController().colorFour,
                      ),
                    )
                  : CustomTextField(
                      hintText: "Confirmation",
                      leading: Icons.lock,
                      hidePassword: showPassword,
                      controller: confirmPassword,
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            showPassword ? Iconsax.eye : Iconsax.eye_slash,
                            color: Colors.white,
                          )),
                    ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                  onTap: () {
                    if (key.currentState!.validate()) _updatePassword();
                  },
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
      ),
    );
  }

  _updatePassword() async {
    String _oldPassword = password.text;
    String _newPassword = newPassword.text;
    String _confirmNewPassword = confirmPassword.text;
    if (_newPassword == _confirmNewPassword) {
      try {
        setState(() {
          _updating = true;
        });
        User? _user = FirebaseAuth.instance.currentUser;
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email,
          password: _oldPassword,
        );

        await _user!.reauthenticateWithCredential(credential);
        await _user.updatePassword(_newPassword);
        Navigator.pop(context);
        SnackMessage(context,
                texte: "Mot de passe modifié avec succès",
                color: Colors.white,
                backgroundColor: Colors.green)
            .showMessage();
      } on FirebaseAuthException catch (e) {
        setState(() {
          _updating = false;
        });
        SnackMessage(context,
                texte: "Votre ancien mot de passe est incorrect",
                color: Colors.white,
                backgroundColor: Colors.red)
            .showMessage();
      }
    } else {
      confirmPassword.clear();
      SnackMessage(context,
              texte: "Les deux mots de passe ne correspondent pas",
              color: Colors.white,
              backgroundColor: Colors.red)
          .showMessage();
    }
  }
}
