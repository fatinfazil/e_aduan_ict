import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';


class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});


  void logout(BuildContext context) {

    showDialog(

      context: context,

      builder:(context){

        return AlertDialog(

          shape:

          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(20),

          ),


          title:

          const Text(

            'Log Keluar',

            style:

            TextStyle(

              fontWeight:
              FontWeight.bold,

            ),

          ),


          content:

          const Text(

            'Anda pasti mahu log keluar daripada sistem?',

          ),



          actions:[


            TextButton(

              onPressed:(){

                Navigator.pop(context);

              },

              child:

              const Text(

                'Batal',

              ),

            ),



            ElevatedButton(

              style:

              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.red,

                foregroundColor:
                Colors.white,

                shape:

                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(12),

                ),

              ),


              onPressed:() async {


                await FirebaseAuth.instance.signOut();


                Navigator.pushAndRemoveUntil(

                  context,

                  MaterialPageRoute(

                    builder:(context)=>

                    const LoginScreen(),

                  ),

                  (route)=>false,

                );


              },


              child:

              const Text(

                'Logout',

              ),

            )


          ],

        );

      },

    );

  }




  @override
  Widget build(BuildContext context) {


    User? user =
    FirebaseAuth.instance.currentUser;



    return Scaffold(


      backgroundColor:
      const Color(0xffF5F7FA),



      appBar:

      AppBar(

        title:

        const Text(

          'Profil Saya',

          style:

          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

        centerTitle:true,

        backgroundColor:

        const Color(0xff003B73),

      ),




      body:

      Padding(

        padding:

        const EdgeInsets.all(20),



        child:

        Column(

          children:[



            Container(

              width:
              double.infinity,


              padding:
              const EdgeInsets.all(25),



              decoration:

              BoxDecoration(


                gradient:

                const LinearGradient(

                  colors:[

                    Color(0xff003B73),

                    Color(0xff00509E),

                  ],

                ),


                borderRadius:

                BorderRadius.circular(25),



                boxShadow:[

                  BoxShadow(

                    color:

                    Colors.black.withValues(alpha:0.15),

                    blurRadius:10,

                    offset:

                    const Offset(0,5),

                  )

                ],

              ),




              child:

              Column(

                children:[



                  Container(

                    padding:

                    const EdgeInsets.all(5),


                    decoration:

                    const BoxDecoration(

                      color:Colors.white,

                      shape:BoxShape.circle,

                    ),


                    child:

                    const CircleAvatar(

                      radius:42,

                      backgroundColor:

                      Color(0xffEAF2FF),

                      child:

                      Icon(

                        Icons.person,

                        size:55,

                        color:

                        Color(0xff003B73),

                      ),

                    ),

                  ),



                  const SizedBox(height:15),



                  Text(

                    user?.email ??
                        'Pengguna',

                    textAlign:
                    TextAlign.center,


                    style:

                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize:18,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:8),



                  Container(

                    padding:

                    const EdgeInsets.symmetric(

                      horizontal:15,

                      vertical:6,

                    ),


                    decoration:

                    BoxDecoration(

                      color:

                      Colors.white.withValues(alpha:0.15),

                      borderRadius:

                      BorderRadius.circular(20),

                    ),


                    child:

                    const Text(

                      'Pengguna Sistem Aduan ICT',

                      style:

                      TextStyle(

                        color:
                        Colors.white,

                        fontSize:13,

                      ),

                    ),

                  )


                ],

              ),

            ),




            const SizedBox(height:25),




            Container(

              decoration:

              BoxDecoration(

                color:
                Colors.white,

                borderRadius:

                BorderRadius.circular(20),


                boxShadow:[

                  BoxShadow(

                    color:

                    Colors.grey.shade200,

                    blurRadius:8,

                  )

                ],

              ),


              child:

              ListTile(

                contentPadding:

                const EdgeInsets.all(16),


                leading:

                Container(

                  padding:

                  const EdgeInsets.all(12),


                  decoration:

                  BoxDecoration(

                    color:

                    const Color(0xff003B73)
                        .withValues(alpha:0.1),

                    shape:
                    BoxShape.circle,

                  ),


                  child:

                  const Icon(

                    Icons.email_rounded,

                    color:

                    Color(0xff003B73),

                  ),

                ),



                title:

                const Text(

                  'Email',

                  style:

                  TextStyle(

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                subtitle:

                Text(

                  user?.email ?? '-',

                ),


              ),

            ),





            const Spacer(),




            SizedBox(

              width:
              double.infinity,


              height:
              55,



              child:

              ElevatedButton.icon(

                icon:

                const Icon(

                  Icons.logout,

                ),



                label:

                const Text(

                  'LOGOUT',

                  style:

                  TextStyle(

                    fontSize:17,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                style:

                ElevatedButton.styleFrom(

                  backgroundColor:

                  Colors.red,

                  foregroundColor:

                  Colors.white,


                  shape:

                  RoundedRectangleBorder(

                    borderRadius:

                    BorderRadius.circular(18),

                  ),

                ),



                onPressed:(){

                  logout(context);

                },


              ),

            )


          ],

        ),

      ),


    );

  }


}