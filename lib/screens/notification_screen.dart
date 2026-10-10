import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationScreen extends StatelessWidget {

  const NotificationScreen({super.key});


  Color warnaStatus(String status){

    switch(status){

      case 'Baru':
        return Colors.orange;

      case 'Dalam Tindakan':
        return const Color(0xff003B73);

      case 'Selesai':
        return Colors.green;

      case 'Ditolak':
        return Colors.red;

      default:
        return Colors.grey;

    }

  }



  String formatTarikh(dynamic tarikh){

    if(tarikh == null){
      return '-';
    }


    if(tarikh is Timestamp){

      DateTime date =
      tarikh.toDate();


      return
      '${date.day}/${date.month}/${date.year} '
      '${date.hour}:${date.minute.toString().padLeft(2,'0')}';

    }


    return '-';

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xffF5F7FA),


      appBar: AppBar(

        title:
        const Text(

          'Notifikasi Aduan',

          style:
          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),


        centerTitle:true,


        backgroundColor:
        const Color(0xff003B73),


        foregroundColor:
        Colors.white,

      ),



      body:

      StreamBuilder<QuerySnapshot>(


        stream:

        FirebaseFirestore.instance
        .collection('notifications')
        .where(
          'userId',
          isEqualTo:
          FirebaseAuth.instance.currentUser!.uid,
        )
        .snapshots(),



        builder:(context,snapshot){


          if(snapshot.connectionState ==
          ConnectionState.waiting){

            return const Center(

              child:
              CircularProgressIndicator(),

            );

          }



          if(snapshot.hasError){

            return Center(

              child:
              Text(
                snapshot.error.toString(),
              ),

            );

          }



          if(snapshot.data == null ||
          snapshot.data!.docs.isEmpty){


            return Center(

              child:

              Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children:[


                  Icon(

                    Icons.notifications_none_rounded,

                    size:80,

                    color:
                    Colors.grey.shade400,

                  ),



                  const SizedBox(height:15),



                  const Text(

                    'Tiada Notifikasi',

                    style:

                    TextStyle(

                      fontSize:22,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:8),



                  Text(

                    'Anda belum menerima\nkemas kini aduan.',

                    textAlign:
                    TextAlign.center,

                    style:

                    TextStyle(

                      color:
                      Colors.grey.shade600,

                    ),

                  ),



                ],

              ),

            );


          }



          return ListView.builder(

                        padding:
            const EdgeInsets.all(16),


            itemCount:
            snapshot.data!.docs.length,



            itemBuilder:(context,index){


              final doc =
              snapshot.data!.docs[index];


              final data =
              doc.data()
              as Map<String,dynamic>;



              final String status =
              data['status']?.toString() ?? '';




              return GestureDetector(

                onTap: () async {


                  try {


                    await FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(doc.id)
                    .set({

                      'read':true,

                    },
                    SetOptions(
                      merge:true,
                    ));


                    print(
                    "READ UPDATED"
                    );


                  }catch(e){

                    print(
                    "ERROR READ: $e"
                    );

                  }


                },


                child:


                Container(


                  margin:

                  const EdgeInsets.only(
                    bottom:16,
                  ),



                  decoration:

                  BoxDecoration(


                    color:

                    data['read'] == true

                    ?

                    Colors.white

                    :

                    const Color(0xffEAF3FF),



                    borderRadius:

                    BorderRadius.circular(20),



                    boxShadow:[


                      BoxShadow(

                        color:
                        Colors.black12,

                        blurRadius:10,

                        offset:
                        const Offset(0,5),

                      )


                    ],


                  ),



                  child:

                  Padding(

                    padding:
                    const EdgeInsets.all(18),



                    child:

                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,



                      children:[



                        Row(

                          children:[



                            Container(

                              width:55,

                              height:55,


                              decoration:

                              BoxDecoration(

                                gradient:

                                LinearGradient(

                                  colors:[

                                    warnaStatus(status),

                                    warnaStatus(status)
                                    .withValues(
                                      alpha:0.6,
                                    ),

                                  ],

                                ),


                                shape:
                                BoxShape.circle,


                              ),



                              child:

                              const Icon(

                                Icons.notifications_active,

                                color:
                                Colors.white,

                                size:28,

                              ),

                            ),




                            const SizedBox(width:15),




                            Expanded(

                              child:

                              Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,


                                children:[



                                  Row(

                                    children:[


                                      Expanded(

                                        child:

                                        Text(

                                          data['title']
                                          ??
                                          'Notifikasi',


                                          style:

                                          const TextStyle(

                                            fontSize:17,

                                            fontWeight:
                                            FontWeight.bold,

                                          ),

                                        ),

                                      ),



                                      if(data['read'] != true)

                                      Container(

                                        padding:

                                        const EdgeInsets.symmetric(

                                          horizontal:8,

                                          vertical:4,

                                        ),



                                        decoration:

                                        BoxDecoration(

                                          color:
                                          Colors.red,

                                          borderRadius:
                                          BorderRadius.circular(20),

                                        ),



                                        child:

                                        const Text(

                                          'BARU',

                                          style:

                                          TextStyle(

                                            color:
                                            Colors.white,

                                            fontSize:10,

                                            fontWeight:
                                            FontWeight.bold,

                                          ),

                                        ),

                                      ),


                                    ],

                                  ),




                                  const SizedBox(height:5),




                                  Text(

                                    status,


                                    style:

                                    TextStyle(

                                      color:
                                      warnaStatus(status),

                                      fontWeight:
                                      FontWeight.bold,

                                    ),

                                  ),



                                ],

                              ),

                            ),



                          ],

                        ),





                        const SizedBox(height:18),





                        Text(

                          data['message'] ?? '',


                          style:

                          TextStyle(

                            fontSize:15,

                            color:
                            Colors.grey.shade700,

                            height:1.4,

                          ),

                        ),





                        const SizedBox(height:15),




                        Divider(

                          color:
                          Colors.grey.shade200,

                        ),





                        Row(

                          children:[



                            Icon(

                              Icons.access_time,

                              size:16,

                              color:
                              Colors.grey.shade500,

                            ),



                            const SizedBox(width:8),




                            Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,


                              children:[



                                Text(

                                  'Kemaskini terbaru',

                                  style:

                                  TextStyle(

                                    fontSize:12,

                                    color:
                                    Colors.grey.shade500,

                                  ),

                                ),




                                Text(

                                  formatTarikh(
                                    data['tarikh'],
                                  ),


                                  style:

                                  TextStyle(

                                    fontSize:13,

                                    fontWeight:
                                    FontWeight.bold,

                                    color:
                                    Colors.grey.shade700,

                                  ),

                                ),



                              ],

                            ),



                          ],

                        ),



                      ],

                    ),

                  ),

                ),


              );


            },

          );


        },


      ),


    );


  }


}