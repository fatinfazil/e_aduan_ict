import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'register_screen.dart';
import 'admin_screen.dart';
import 'main_navigation.dart';
import 'reset_password_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool showPassword = false;


 Future<void> login() async {

  String email = emailController.text.trim();
  String password = passwordController.text.trim();


  if (email.isEmpty || password.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sila isi email dan password'),
      ),
    );

    return;
  }


  if (!email.endsWith('@kuypj.edu.my')) {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Sila gunakan email rasmi KUYPJ'),
      backgroundColor: Colors.red,
    ),
  );

  return;
}


  try {

    setState(() {
      loading = true;
    });


    // LOGIN FIREBASE AUTHENTICATION
    UserCredential userCredential =
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: email,
      password: password,
    );


    User user = userCredential.user!;



    // AMBIL DATA ROLE DARI FIRESTORE
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();



    if (!userDoc.exists) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Maklumat pengguna tidak dijumpai',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;

    }



    String role =
        userDoc['role'].toString().toLowerCase();



    print("ROLE USER: $role");

   String? token =
await FirebaseMessaging.instance.getToken();


print("FCM TOKEN: $token");


await FirebaseFirestore.instance
.collection('users')
.doc(user.uid)
.update({

  'fcmToken': token,

});



    // CHECK ROLE

    if (role == 'admin') {


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
              const AdminScreen(),

        ),

      );


    } else {


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
    const MainNavigation(),

        ),

      );


    }



  } on FirebaseAuthException catch(e) {


    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          e.message ?? 'Email atau password salah',
        ),

        backgroundColor: Colors.red,

      ),

    );


  } catch(e) {


    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          'Ralat: $e',
        ),

        backgroundColor: Colors.red,

      ),

    );


  } finally {


    if (mounted) {

      setState(() {
        loading = false;
      });

    }


  }

}
  @override
Widget build(BuildContext context) {

  return Scaffold(

    body:

    Container(

      decoration:

      const BoxDecoration(

        gradient:

        LinearGradient(

          colors:[

            Color(0xff003B73),

            Color(0xffF5F7FA),

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

        SingleChildScrollView(


          padding:
          const EdgeInsets.all(25),



          child:

          Container(


            padding:

            const EdgeInsets.all(25),



            decoration:

            BoxDecoration(


              color:

              Colors.white,



              borderRadius:

              BorderRadius.circular(25),



              boxShadow:[


                BoxShadow(

                  color:
                  Colors.black26,

                  blurRadius:20,

                  offset:
                  const Offset(0,10),

                ),


              ],


            ),




            child:

            Column(


              children:[




                Container(

                  padding:
                  const EdgeInsets.all(15),


                  decoration:

                  BoxDecoration(

                    color:
                    const Color(0xffF5F7FA),

                    borderRadius:
                    BorderRadius.circular(20),

                  ),


                  child:

                  Image.asset(

                    'lib/assets/images/kypj_logo.jpg',

                    height:100,

                  ),


                ),




                const SizedBox(height:25),




                const Text(

                  'e-Aduan ICT KUYPJ',

                  style:

                  TextStyle(

                    fontSize:26,

                    fontWeight:
                    FontWeight.bold,

                    color:
                    Color(0xff003B73),

                  ),

                ),





                const SizedBox(height:8),




                const Text(

                  'Sistem Aduan Kerosakan ICT',

                  style:

                  TextStyle(

                    color:
                    Colors.grey,

                    fontSize:15,

                  ),

                ),




                const SizedBox(height:30),





                TextField(

                  controller:
                  emailController,


                  decoration:

                  InputDecoration(

                    labelText:
                    'Email KUYPJ',


                    prefixIcon:

                    const Icon(

                      Icons.email,

                    ),



                    filled:true,

                    fillColor:
                    const Color(0xffF5F7FA),



                    border:

                    OutlineInputBorder(

                      borderRadius:

                      BorderRadius.circular(15),

                      borderSide:
                      BorderSide.none,

                    ),


                  ),


                ),




                const SizedBox(height:15),





                TextField(

  controller:
  passwordController,


  obscureText:
  !showPassword,


  decoration:

  InputDecoration(

                    labelText:
                    'Password',



                    prefixIcon:

                    const Icon(

                      Icons.lock,

                    ),

                    suffixIcon:

IconButton(

  icon:

  Icon(

    showPassword

    ? Icons.visibility

    : Icons.visibility_off,

    color:
const Color(0xff003B73),

  ),


  onPressed:(){

    setState((){

      showPassword =
      !showPassword;

    });

  },


),



                    filled:true,

                    fillColor:
                    const Color(0xffF5F7FA),



                    border:

                    OutlineInputBorder(

                      borderRadius:

                      BorderRadius.circular(15),

                      borderSide:
                      BorderSide.none,

                    ),


                  ),


                ),





                const SizedBox(height:25),

               Align(

  alignment: Alignment.centerRight,

  child: TextButton(

    onPressed: (){


      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (context)=>

          const ResetPasswordScreen(),

        ),

      );


    },


    child:

    const Text(

      'Lupa Password?',

      style:

      TextStyle(

        color:
        Color(0xff003B73),


      ),

    ),

  ),

),






                SizedBox(

                  width:
                  double.infinity,


                  height:
                  55,



                  child:

                  ElevatedButton(


                    onPressed:

                    loading
                    ? null
                    : login,



                    style:

                    ElevatedButton.styleFrom(


                      backgroundColor:

                      const Color(0xff003B73),



                      foregroundColor:

                      Colors.white,



                      shape:

                      RoundedRectangleBorder(

                        borderRadius:

                        BorderRadius.circular(15),

                      ),


                    ),



                    child:

                    loading

                    ?

                    const CircularProgressIndicator(

                      color:
                      Colors.white,

                    )


                    :

                    const Text(

                      'LOGIN',

                      style:

                      TextStyle(

                        fontSize:18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),


                  ),


                ),




                const SizedBox(height:15),





                TextButton(

                  onPressed:(){


                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:(context)=>
                        const RegisterScreen(),

                      ),

                    );


                  },


                  child:

                  const Text(

                    'Belum ada akaun? Daftar di sini',

                    style:

                    TextStyle(

                      color:
                      Color(0xff003B73),

                    ),

                  ),


                ),



              ],


            ),


          ),


        ),


      ),


    ),


  );

}

}