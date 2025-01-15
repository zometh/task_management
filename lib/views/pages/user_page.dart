import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_management/services/data/get_user_datas.dart';
import 'package:task_management/services/formatters/format_text.dart';
import 'package:task_management/views/pages/custom_appbar.dart';
import 'package:task_management/views/pages/edit_fullname.dart';
import 'package:task_management/views/pages/edit_mail.dart';
import 'package:task_management/views/pages/edit_password.dart';
import 'package:task_management/views/widgets/user_page_tile.dart';

import '../../controllers/color_controller.dart';
import '../../models/user_mine.dart';
import '../../services/providers/navigation_provider.dart';
import '../widgets/button.dart';
import '../widgets/custom_title.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GetUserDatas().getConnectedUserInfos(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorController().colorFour,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Aucune information trouvée"),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text("Erreur: ${snapshot.error.toString()}"),
            );
          }
          final data = snapshot.data!.data();
          final UserMine user = UserMine.fromJson(data!);
          return Scaffold(
            appBar: CustomAppBar(appBarTitle: "Profil"),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 73,
                        backgroundColor: ColorController().colorFour,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: ColorController().colorFour,
                          backgroundImage: NetworkImage(user.imageUrl),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                  top: 110.h,
                                  left: 100.w,
                                  child: IconButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                  ColorController().colorFour),
                                          backgroundColor:
                                              const WidgetStatePropertyAll(
                                                  Colors.black)),
                                      onPressed: _pickImage,
                                      icon: const Icon(Iconsax.add_square)))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    UserPageTile(
                        iconData: Iconsax.user_add,
                        title: FormatText()
                            .formatTitle("${user.prenom} ${user.nom}"),
                        redirectPage: EditFullNamePage(userMine: user)),
                    SizedBox(
                      height: 12.h,
                    ),
                    UserPageTile(
                      iconData: Iconsax.user_tag,
                      title: user.email,
                      showEdit: false,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    UserPageTile(
                        iconData: Iconsax.lock,
                        title: "Mot de passe",
                        redirectPage: EditPassword(userMine: user)),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: showTaskDialog,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButton(
                              widget: CustomTitle(
                            text: "Se déconnecter",
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _disconnect() async {
    await FirebaseAuth.instance.signOut();
    Provider.of<NavigationProvider>(context, listen: false).changeIndex(0);
  }

  _pickImage() async {
    final XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (xFile != null) {
      setState(() {
        file = File(xFile.path);
      });
      confirmPicChange(file!);
    }
  }

  showTaskDialog() async {
    await showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: AlertDialog(
              backgroundColor: ColorController().colorSixth,
              content: Text(
                "Etes-vous sur de vouloir vous déconnecter?",
                style: GoogleFonts.signika(fontSize: 15, color: Colors.white),
              ),
              title: Text(
                "Déconnexion",
                style: GoogleFonts.signika(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _disconnect();
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  child: const Text(
                    "Oui",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  child: const Text(
                    "Non",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        });
  }

  confirmPicChange(File file) async {
    showBottomSheet(
        showDragHandle: true,
        backgroundColor: ColorController().colorFive,
        elevation: 10,
        context: context,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
                color: ColorController().colorFive,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 220.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(file!),
                ),
                SizedBox(
                  height: 12.h,
                ),
                GestureDetector(
                  onTap: () {
                    editProfileImage();
                  },
                  child: Container(
                    width: 110,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: ColorController().colorFour,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Confirmer",
                        style: TextStyle(
                            fontFamily: 'PliatExtended',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  editProfileImage() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filename =
          '${uid}_$timestamp.jpg'; // Ajout du timestamp et extension
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final String? previousImageUrl = userDoc.data()?['imageUrl'];

      if (previousImageUrl != null && previousImageUrl.isNotEmpty) {
        // Extraire le nom du fichier à partir de l'URL
        final Uri uri = Uri.parse(previousImageUrl);
        final String previousFilename = uri.pathSegments.last;

        // Supprimer l'image précédente de Supabase
        await Supabase.instance.client.storage
            .from("users_profiles")
            .remove([previousFilename]);
      }

      // 1. Upload l'image sur Supabase avec le nouveau nom
      await Supabase.instance.client.storage.from("users_profiles").upload(
          filename, file!,
          fileOptions: const FileOptions(upsert: true));

      // 2. Obtenir l'URL publique de l'image
      final String imageUrl = Supabase.instance.client.storage
          .from('users_profiles')
          .getPublicUrl(filename);

      // 3. Mettre à jour l'URL dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'imageUrl': imageUrl});
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
