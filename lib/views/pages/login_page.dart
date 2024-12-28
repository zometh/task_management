import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/main.dart';
import 'package:task_management/services/providers/auth_provider.dart';
import 'package:task_management/services/shared_pref/SharedPref.dart';
import 'package:task_management/views/widgets/button.dart';
import 'package:task_management/views/widgets/custom_textField.dart';
import 'package:task_management/views/widgets/custom_title.dart';
import 'package:task_management/views/widgets/vertical_spacer.dart';

import '../../models/user_mine.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = true;
  bool _isLoading = false;
  late TextEditingController email;
  late TextEditingController password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorController().colorSixth,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 50.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              VerticalSpacer(
                height: 50.5,
              ),
              Center(
                child: Image.asset(
                  "lib/assets/imgs/logo.png",
                  height: 91.92.h,
                  width: 139.w,
                ),
              ),
              VerticalSpacer(
                height: 49,
              ),
              CustomTitle(text: "Bienvenue!"),
              VerticalSpacer(
                height: 23,
              ),
              CustomTextField(
                leading: Iconsax.user_tag,
                controller: email,
                hintText: "Adresse email",
              ),
              VerticalSpacer(
                height: 27,
              ),
              CustomTextField(
                hintText: "Mot de passe",
                leading: Iconsax.lock,
                hidePassword: showPassword,
                controller: password,
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword ? Iconsax.eye_slash : Iconsax.eye,
                      color: Colors.white,
                    )),
              ),
              VerticalSpacer(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTitle(
                    text: "Mot de passe oublié?",
                    fontSize: 16,
                    color: ColorController().colorThree,
                  )
                ],
              ),
              VerticalSpacer(
                height: 38,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorController().colorOne,
                      ),
                    )
                  : GestureDetector(
                      onTap: _login,
                      child: CustomButton(
                          widget: CustomTitle(
                        text: "Se connecter",
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
              VerticalSpacer(
                height: 38,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTitle(
                    text: "Vous n'avez pas de compte?",
                    color: ColorController().colorThree,
                    fontSize: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: CustomTitle(
                        text: "S'inscrire",
                        color: ColorController().colorFour,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String mail = email.text.trim();
      String pwd = password.text.trim();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd)
          .then((onValue) {});
    } catch (e) {
      _isLoading = false;
      debugPrint(e.toString());
    }
  }
}
