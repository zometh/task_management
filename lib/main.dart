import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_management/controllers/color_controller.dart';
import 'package:task_management/services/providers/navigation_provider.dart';
import 'package:task_management/views/pages/task_action.dart';
import 'package:task_management/views/pages/index.dart';
import 'package:task_management/views/pages/login_page.dart';
import 'package:task_management/views/pages/register_page.dart';
import 'package:task_management/views/pages/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jrwtnpxjysxvuzvutuzn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impyd3RucHhqeXN4dnV6dnV0dXpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQxMTY4MTYsImV4cCI6MjA0OTY5MjgxNn0.IZe6BDhWKHech3SHmiOqmTyFcH4g5Qo-X6iQEQIwRyw',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavigationProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color primary = ColorController().colorFour;
    String fontFamily = 'PliatExtended';
    ButtonStyle buttonStyle = ButtonStyle(
      //side: WidgetStatePropertyAll(BorderSide(color: ColorController().colorFour)),
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.titleMedium),
      foregroundColor: WidgetStatePropertyAll(ColorController().colorFour)

    );
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('fr')
          ],

          initialRoute: '/',
          routes: {
            '/': (_) => const IndexPage(),
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
            '/splash': (_) => const SplashScreen(),
            '/add_task': (_) => const AddTaskPage()
          },
          debugShowCheckedModeBanner: false,
          title: 'Gestion des tâches',
          theme: ThemeData(


            scaffoldBackgroundColor: ColorController().colorSixth,
            datePickerTheme:  DatePickerThemeData(
              cancelButtonStyle: buttonStyle,
              confirmButtonStyle: buttonStyle,
              backgroundColor: ColorController().eightColor,
              todayForegroundColor: WidgetStatePropertyAll(Colors.black),
              todayBackgroundColor: WidgetStatePropertyAll(ColorController().colorFour),
              yearOverlayColor: WidgetStatePropertyAll(ColorController().colorFour),
              dayForegroundColor: WidgetStatePropertyAll(ColorController().colorFour) /*Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorController().colorFour)*/,
              dividerColor: ColorController().colorFour,
yearForegroundColor: WidgetStatePropertyAll(ColorController().colorFour) ,
              weekdayStyle: TextStyle(color: ColorController().colorFour),
              yearStyle: TextStyle(color: ColorController().colorFour),
              
              headerBackgroundColor: ColorController().eightColor,
              headerForegroundColor: ColorController().colorFour,
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                  fontSize: 25.sp,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
              titleMedium: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
              titleSmall: TextStyle(
                fontSize: 16.sp,
                fontFamily: fontFamily,
                  fontWeight: FontWeight.bold,
                color: Colors.white
              )
            ),
            platform: TargetPlatform.iOS,
            primaryColor: primary,
            colorScheme:
                ColorScheme.fromSeed(seedColor: primary, primary: primary),
            useMaterial3: true,
          ),
        );
      },
      child: const LoginPage(),
    );
  }
}
