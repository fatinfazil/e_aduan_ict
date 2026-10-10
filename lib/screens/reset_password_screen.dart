import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ResetPasswordScreen extends StatefulWidget {

  const ResetPasswordScreen({super.key});


  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();

}



class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {


  final emailController =
      TextEditingController();


  bool loading = false;



  Future<void> resetPassword() async {


    if(emailController.text.trim().isEmpty){

      ScaffoldMessenger.of(context)
      .showSnackBar(

        const SnackBar(

          content:
          Text(
            'Sila masukkan email KUYPJ',
          ),

          backgroundColor:
          Colors.red,

        ),

      );

      return;

    }



    try {


      setState((){

        loading = true;

      });



      await FirebaseAuth.instance
      .sendPasswordResetEmail(

        email:
        emailController.text.trim(),

      );



      setState((){

        loading = false;

      });



      ScaffoldMessenger.of(context)
      .showSnackBar(

        const SnackBar(

          content:

          Text(
            'Link reset password telah dihantar',
          ),

          backgroundColor:
          Colors.green,

        ),

      );



    } on FirebaseAuthException catch(e){


      setState((){

        loading = false;

      });



      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content:

          Text(
            e.message ??
            'Email tidak dijumpai',
          ),

          backgroundColor:
          Colors.red,

        ),

      );


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

                    const Icon(

                      Icons.lock_reset,

                      size:90,

                      color:

                      Color(0xff003B73),

                    ),

                  ),




                  const SizedBox(height:25),





                  const Text(

                    'Reset Password',

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

                    'Masukkan email KUYPJ anda untuk menerima link reset password.',

                    textAlign:

                    TextAlign.center,


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



                      filled:

                      true,


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

                      loading

                      ?

                      null

                      :

                      resetPassword,



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

                        'HANTAR LINK RESET',

                        style:

                        TextStyle(

                          fontSize:16,

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

                      'Kembali ke Login',

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