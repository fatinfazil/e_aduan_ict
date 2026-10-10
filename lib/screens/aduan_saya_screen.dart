import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_aduan_screen.dart';


class AduanSayaScreen extends StatefulWidget {

  const AduanSayaScreen({super.key});


  @override
  State<AduanSayaScreen> createState() => _AduanSayaScreenState();

}


class _AduanSayaScreenState extends State<AduanSayaScreen> {




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



  IconData iconStatus(String status){

    switch(status){

      case 'Baru':
        return Icons.notifications;

      case 'Dalam Tindakan':
        return Icons.pending_actions;

      case 'Selesai':
        return Icons.check_circle;

      case 'Ditolak':
        return Icons.cancel;

      default:
        return Icons.info;
    }

  }

Future<void> deleteAduan(String id) async {

  await FirebaseFirestore.instance
      .collection('aduan')
      .doc(id)
      .delete();


  if(mounted){

    setState(() {});

  }


}



  @override
Widget build(BuildContext context) {

return Scaffold(

backgroundColor:
const Color(0xffF5F7FA),

appBar: AppBar(

title:
const Text(
'Aduan Saya',
style:
TextStyle(
fontWeight: FontWeight.bold,
),
),

centerTitle:true,

backgroundColor:
const Color(0xff003B73),

),


body:


      Column(

        children:[


          const SizedBox(height:16),


          Container(

            margin:
            const EdgeInsets.symmetric(
              horizontal:16,
            ),

            padding:
            const EdgeInsets.all(20),


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

            Row(

              children:[


                Container(

                  padding:
                  const EdgeInsets.all(14),

                  decoration:

                  BoxDecoration(

                    color:
                    Colors.white.withValues(alpha:0.15),

                    shape:
                    BoxShape.circle,

                  ),


                  child:

                  const Icon(

                    Icons.assignment_rounded,

                    color:
                    Colors.white,

                    size:40,

                  ),

                ),



                const SizedBox(width:15),



                const Expanded(

                  child:

                  Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children:[


                      Text(

                        'Senarai Aduan Saya',

                        style:

                        TextStyle(

                          color:
                          Colors.white,

                          fontSize:20,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),



                      SizedBox(height:6),



                      Text(

                        'Semak perkembangan laporan ICT anda',

                        style:

                        TextStyle(

                          color:
                          Colors.white70,

                        ),

                      ),


                    ],

                  ),

                )


              ],

            ),

          ),



          const SizedBox(height:12),




          Expanded(

            child:

            StreamBuilder<QuerySnapshot>(


              stream:

              FirebaseFirestore.instance

                  .collection('aduan')

                  .where(

                'uid',

                isEqualTo:
                FirebaseAuth.instance.currentUser!.uid,

              )

                  .orderBy(

                'tarikh',

                descending:true,

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



                if(!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty){

                  return const Center(

                    child:

                    Text(
                      'Tiada aduan ditemui',
                      style:
                      TextStyle(
                        fontSize:18,
                      ),
                    ),

                  );

                }




                return ListView.builder(

                  padding:
                  const EdgeInsets.all(16),


                  itemCount:
                  snapshot.data!.docs.length,



                  itemBuilder:(context,index){


                    final data =
                    snapshot.data!.docs[index]
                        .data()
                    as Map<String,dynamic>;

                    final docId =
snapshot.data!.docs[index].id;



                    String status =
                    data['status'] ?? 'Baru';



                    return Card(


                      elevation:3,


                      margin:
                      const EdgeInsets.only(
                        bottom:15,
                      ),


                      shape:

                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                      ),



                      child:

                      Padding(

                        padding:
                        const EdgeInsets.all(16),


                        child:

                        Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,


                          children:[



                            Text(

                              data['masalah'] ?? '-',

                              style:

                              const TextStyle(

                                fontSize:18,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),



                            const SizedBox(height:10),



                            Text(
                              'Nama: ${data['nama'] ?? '-'}',
                            ),


                            Text(
                              'Kategori: ${data['kategori'] ?? '-'}',
                            ),


                            Text(
                              'Lokasi: ${data['lokasi'] ?? '-'}',
                            ),



                            const SizedBox(height:15),



                            if(data['gambarBase64'] != null &&
                                data['gambarBase64']
                                    .toString()
                                    .isNotEmpty)

                              ClipRRect(

                                borderRadius:
                                BorderRadius.circular(15),


                                child:

                                Image.memory(

                                  base64Decode(

                                    data['gambarBase64']
                                        .toString(),

                                  ),

                                  width:
                                  double.infinity,

                                  height:
                                  180,

                                  fit:
                                  BoxFit.cover,

                                ),

                              ),



                            const SizedBox(height:15),



                            Container(

                              padding:

                              const EdgeInsets.symmetric(

                                horizontal:15,

                                vertical:8,

                              ),


                              decoration:

                              BoxDecoration(

                                color:

                                warnaStatus(status)
                                    .withValues(alpha:0.15),


                                borderRadius:

                                BorderRadius.circular(25),

                              ),



                              child:

                              Row(

                                mainAxisSize:
                                MainAxisSize.min,


                                children:[


                                  Icon(

                                    iconStatus(status),

                                    size:18,

                                    color:
                                    warnaStatus(status),

                                  ),


                                  const SizedBox(width:8),



                                  Text(

                                    status,

                                    style:

                                    TextStyle(

                                      color:
                                      warnaStatus(status),

                                      fontWeight:
                                      FontWeight.bold,

                                    ),

                                  )

                                ],

                              ),

                            ),



                            if(data['statusMessage'] != null &&
                                data['statusMessage']
                                    .toString()
                                    .isNotEmpty)

                              Padding(

                                padding:

                                const EdgeInsets.only(
                                  top:10,
                                ),

                                child:

                                Text(

                                  data['statusMessage'],

                                  style:

                                  const TextStyle(

                                    color:
                                    Colors.grey,

                                    fontStyle:
                                    FontStyle.italic,

                                  ),

                                ),

                              ),


// DELETE BUTTON

if(status == 'Baru')

Row(

mainAxisAlignment:
MainAxisAlignment.end,

children:[

IconButton(

icon:
const Icon(
Icons.edit,
color: Colors.blue,
),


onPressed:(){

Navigator.push(

context,

MaterialPageRoute(

builder:(context)=>

EditAduanScreen(

docId:docId,

data:data,

),

),

).then((value){

setState((){});

});

},

),

IconButton(

icon:
const Icon(
Icons.delete,
color: Colors.red,
),


onPressed:() async {


bool? confirm = await showDialog<bool>(

context:context,

builder:(context){

return AlertDialog(

title:
const Text(
'Padam Aduan'
),


content:
const Text(
'Anda pasti mahu padam aduan ini?'
),


actions:[


TextButton(

onPressed:(){

Navigator.pop(context,false);

},

child:
const Text('Batal'),

),


TextButton(

onPressed:(){

Navigator.pop(context,true);

},

child:
const Text('Padam'),

),


],


);

},


);


if(confirm == true){

print(docId);

await deleteAduan(docId);

}

},


),


],

),
                          ]

                        ),
                      

                      ),

                    );


                  },

                );

              },

            ),

          ),


                ],

      ),

    );

  }

}