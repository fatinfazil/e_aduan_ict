import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'admin_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen>
with SingleTickerProviderStateMixin {


late AnimationController _controller;

late Animation<double> _fade;



@override
void initState(){

super.initState();


_controller = AnimationController(

vsync:this,

duration:
const Duration(seconds:2),

);


_fade = Tween<double>(

begin:0,

end:1,

).animate(_controller);



_controller.forward();



Timer(
  const Duration(seconds: 3),
  () async {

    User? user = FirebaseAuth.instance.currentUser;


    if (user == null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );


    } else {


      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();



      String role = userDoc['role'];



      if (role == 'admin') {


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminScreen(),
          ),
        );


      } else {


Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context)=> const MainScreen(),
),
);


}


    }

  },
);



}



@override
void dispose(){

_controller.dispose();

super.dispose();

}



@override
Widget build(BuildContext context){


return Scaffold(

body:

Container(


decoration:

const BoxDecoration(


gradient:

LinearGradient(

colors:[

Color(0xff001F3F),

Color(0xff003B73),

Color(0xff00509E),

],

begin:

Alignment.topCenter,

end:

Alignment.bottomCenter,

),

),



child:

Center(


child:

FadeTransition(


opacity:_fade,


child:

Column(


mainAxisAlignment:

MainAxisAlignment.center,


children:[



Container(

padding:

const EdgeInsets.all(20),


decoration:

BoxDecoration(

shape:

BoxShape.circle,


boxShadow:[

BoxShadow(

color:

Colors.white24,

blurRadius:

40,

spreadRadius:

10,

),

],

),



child:

Image.asset(

'lib/assets/images/kypj_logo.jpg',

height:90,

),

),




const SizedBox(height:40),




const Text(

'e-Aduan ICT KUYPJ',

style:

TextStyle(

color:

Colors.white,

fontSize:30,

fontWeight:

FontWeight.bold,

letterSpacing:1,

),

),




const SizedBox(height:12),




const Text(

'Sistem Aduan Kerosakan ICT',

style:

TextStyle(

color:

Colors.white70,

fontSize:16,

),

),





const SizedBox(height:40),





const SizedBox(height:15),





const SizedBox(

width:25,

height:25,


child:

CircularProgressIndicator(

strokeWidth:3,

color:

Colors.white,

),

),



],


),

),

),

),

);


}

}