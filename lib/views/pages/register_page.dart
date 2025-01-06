import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/color_controller.dart';
import '../widgets/button.dart';
import '../widgets/custom_textField.dart';
import '../widgets/custom_title.dart';
import '../widgets/vertical_spacer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPassword = false;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController prenom;
  late TextEditingController nom;
  bool _isLaoding = false;
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    nom = TextEditingController();
    prenom = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    prenom.dispose();
    password.dispose();
    nom.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 50.h),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Image.asset(
                  "lib/assets/imgs/logo.png",
                  height: 40.h,
                  //width: 30.w,
                ),
              ),
              VerticalSpacer(
                height: 30.h,
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: (file == null)
                          ? const AssetImage(
                              "lib/assets/imgs/user_default.jpeg")
                          : FileImage(file!),
                      backgroundColor: Colors.blueGrey,
                    ),
                    VerticalSpacer(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: pickImage,
                        child: Text(
                          "Choisir une photo",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade200,
                          ),
                        ))
                  ],
                ),
              ),
              VerticalSpacer(
                height: 18,
              ),
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
              CustomTextField(
                leading: Icons.mail,
                controller: email,
                hintText: "email",
              ),
              VerticalSpacer(
                height: 27,
              ),
              CustomTextField(
                hintText: "Mot de passe",
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
              VerticalSpacer(
                height: 38,
              ),
              _isLaoding
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorController().colorOne,
                      ),
                    )
                  : GestureDetector(
                      onTap: _register,
                      child: CustomButton(
                          widget: CustomTitle(
                        text: "S'inscrire",
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
                    text: "Vous avez déja un compte?",
                    color: ColorController().colorThree,
                    fontSize: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CustomTitle(
                        text: "Se connecter",
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

  void _register() async {
    try {
      setState(() {
        _isLaoding = true;
      });
      String mail = email.text.trim();
      String pwd = password.text.trim();
      String firstname = prenom.text.trim();
      String lastname = nom.text.trim();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pwd);

      String uid = userCredential.user!.uid;

      File fileNew = (file == null
          ? await getImageFileFromAssets("lib/assets/imgs/user_default.jpeg")
          : file!);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filename = '${uid}_$timestamp.jpg';
      await Supabase.instance.client.storage
          .from('users_profiles')
          .upload(filename, fileNew, fileOptions: const FileOptions(upsert: true));
      final String imageUrl = Supabase.instance
          .client
          .storage
          .from('users_profiles')
          .getPublicUrl(filename);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'id': uid,
        "prenom": firstname,
        "nom": lastname,
        "email": userCredential.user!.email,
        "registerDate": Timestamp.now(),
        'imageUrl':imageUrl
      }).then((onValue) {
        if (mounted) Navigator.pop(context);
      });

      //Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLaoding = false;
      });
      debugPrint(e.toString());
    }
  }

  void pickImage() async {
    XFile? _file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_file != null) {
      setState(() {
        file = File(_file.path);
      });
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
