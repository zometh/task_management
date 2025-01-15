import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_management/services/data/get_user_datas.dart';
import 'package:task_management/services/formatters/format_text.dart';
import 'package:task_management/services/messages/snack_messages.dart';
import 'package:task_management/views/pages/custom_appbar.dart';

import '../widgets/button.dart';
import '../widgets/custom_textField.dart';
import '../widgets/custom_title.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController email;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(appBarTitle: "Renitialiser mot de passe"),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 50.h),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.lock_reset_outlined,
                      color: Colors.white,
                      size: 130,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  CustomTextField(
                    leading: Iconsax.user_tag,
                    controller: email,
                    hintText: "Adresse email",
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (key.currentState!.validate()) _resetPassword();
                    },
                    child: CustomButton(
                        widget: CustomTitle(
                      text: "Renitialiser",
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                ],
              ),
            )));
  }

  _resetPassword() async {
    String mail = email.text.trim();
    if (EmailValidator.validate(mail)) {
      bool isExistMail = await GetUserDatas().isExistMail(email.text.trim());
      if (isExistMail) {
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: email.text.trim())
              .then((onValue) {
            SnackMessage(
              texte:
                  "Un lien pour réinitialiser votre mot de passe sera envoyé à votre adresse e-mail.",
              context,
            ).showMessage();
          });
        } on FirebaseAuthException catch (e) {
          SnackMessage(
                  texte: FormatText().getMessageFromErrorCode(e.code),
                  context,
                  color: Colors.white,
                  backgroundColor: Colors.red)
              .showMessage();
        }
      } else {
        SnackMessage(
                texte:
                    "L'adresse e-mail saisie ne correspond à aucun compte existant. Nous vous invitons à créer un compte.",
                context,
                color: Colors.white,
                backgroundColor: Colors.red)
            .showMessage();
      }
    } else {
      SnackMessage(
              texte: "L'adresse e-mail est incorrect.",
              context,
              color: Colors.white,
              backgroundColor: Colors.red)
          .showMessage();
    }
  }
}
