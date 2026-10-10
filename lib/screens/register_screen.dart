import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


 bool loading = false;

bool showPassword = false;


  Future<void> register() async {

    String nama = namaController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();


    if (nama.isEmpty || email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sila lengkapkan semua maklumat'),
        ),
      );

      return;
    }


    // Semak email KYPJ
    if (!email.endsWith('@kuypj.edu.my')) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sila gunakan email KUYPJ sahaja'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }


    try {

      setState(() {
        loading = true;
      });


      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({

        'nama': nama,
        'email': email,
        'role': 'staff',
        'createdAt': Timestamp.now(),

      });



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berjaya'),
          backgroundColor: Colors.green,
        ),
      );


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );


    } on FirebaseAuthException catch(e) {


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Ralat berlaku'),
          backgroundColor: Colors.red,
        ),
      );


    } finally {

      setState(() {
        loading = false;
      });

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

                  blurRadius:

                  20,

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

                  'Daftar Akaun',

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

                  'e-Aduan ICT KUYPJ',

                  style:

                  TextStyle(

                    color:

                    Colors.grey,

                  ),

                ),





                const SizedBox(height:30),





                TextField(

                  controller:
                  namaController,


                  decoration:

                  InputDecoration(

                    labelText:

                    'Nama',


                    prefixIcon:

                    const Icon(Icons.person),


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
                  emailController,


                  decoration:

                  InputDecoration(

                    labelText:

                    'Email KUYPJ',


                    prefixIcon:

                    const Icon(Icons.email),


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





                SizedBox(

                  width:

                  double.infinity,


                  height:

                  55,



                  child:

                  ElevatedButton(


                    onPressed:

                    loading ? null : register,



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

                      'DAFTAR',

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

                    Navigator.pop(context);

                  },


                  child:

                  const Text(

                    'Sudah ada akaun? Login',

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