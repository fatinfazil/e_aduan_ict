import 'package:e_aduan_ict/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';





Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();


  runApp(
    const MyApp(),
  );

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,


      title: 'E-Aduan ICT KUYPJ',


     theme: ThemeData(

      useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(

    seedColor:
    const Color(0xff003B73),

  ),


  scaffoldBackgroundColor:
  const Color(0xffF5F7FA),


  appBarTheme:

  const AppBarTheme(

    backgroundColor:
    Color(0xff003B73),


    foregroundColor:
    Colors.white,


    elevation:0,


    centerTitle:true,

  ),


),

      home: const SplashScreen(),

    );

  }
  

}