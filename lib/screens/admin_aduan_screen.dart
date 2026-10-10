import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_detail_screen.dart';


class AdminAduanScreen extends StatefulWidget {

  const AdminAduanScreen({super.key});


  @override
  State<AdminAduanScreen> createState() =>
      _AdminAduanScreenState();

}



class _AdminAduanScreenState
    extends State<AdminAduanScreen> {


  String selectedStatus = 'Semua';


  String searchText = '';


  final TextEditingController searchController =
  TextEditingController();



  final List<String> statusFilter = [

    'Semua',
    'Baru',
    'Dalam Tindakan',
    'Selesai',
    'Ditolak',

  ];





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






  String namaBulan(int bulan){

    const bulanList = [

      '',
      'Januari',
      'Februari',
      'Mac',
      'April',
      'Mei',
      'Jun',
      'Julai',
      'Ogos',
      'September',
      'Oktober',
      'November',
      'Disember',

    ];


    return bulanList[bulan];

  }





  String formatTarikh(dynamic tarikh){


    if(tarikh == null){

      return '-';

    }



    if(tarikh is Timestamp){


      DateTime date =
      tarikh.toDate();


      return

      '${date.day} ${namaBulan(date.month)} ${date.year}';


    }


    return '-';


  }






  String formatMasa(dynamic tarikh){


    if(tarikh is Timestamp){


      DateTime date =
      tarikh.toDate();


      return

      '${date.hour.toString().padLeft(2,'0')}:'
      '${date.minute.toString().padLeft(2,'0')}';


    }


    return '-';


  }






  IconData iconStatus(String status){


    switch(status){


      case 'Baru':

        return Icons.notifications_active;


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






  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xffF5F7FA),




      appBar: AppBar(


        title:

        const Text(

          'Semua Aduan',

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


      Column(


        children:[




          const SizedBox(height:15),






          Padding(


            padding:

            const EdgeInsets.symmetric(
              horizontal:15,
            ),



            child:


            TextField(


              controller:
              searchController,



              decoration:


              InputDecoration(


                hintText:

                'Cari nama / masalah aduan...',



                prefixIcon:

                const Icon(
                  Icons.search,
                ),




                filled:true,



                fillColor:
                Colors.white,




                border:

                OutlineInputBorder(


                  borderRadius:

                  BorderRadius.circular(15),



                  borderSide:
                  BorderSide.none,


                ),


              ),




              onChanged:(value){


                setState((){


                  searchText =
                      value.toLowerCase();


                });


              },



            ),


          ),







          const SizedBox(height:12),






          SizedBox(


            height:45,



            child:


            ListView.builder(


              scrollDirection:
              Axis.horizontal,



              padding:

              const EdgeInsets.symmetric(
                horizontal:15,
              ),



              itemCount:

              statusFilter.length,



              itemBuilder:(context,index){


                String item =
                statusFilter[index];



                bool selected =
                    selectedStatus == item;



                return Padding(


                  padding:

                  const EdgeInsets.only(
                    right:10,
                  ),



                  child:


                  ChoiceChip(


                    label:

                    Text(item),



                    selected:

                    selected,



                    selectedColor:

                    warnaStatus(item)
                        .withValues(
                        alpha:0.2
                    ),




                    labelStyle:

                    TextStyle(


                      color:

                      selected

                      ?

                      warnaStatus(item)

                      :

                      Colors.black,



                      fontWeight:
                      FontWeight.bold,


                    ),




                    onSelected:(value){


                      setState((){


                        selectedStatus =
                            item;


                      });


                    },


                  ),


                );


              },


            ),


          ),





          const SizedBox(height:10),






          Expanded(


            child:


            StreamBuilder<QuerySnapshot>(


              stream:


              FirebaseFirestore.instance

              .collection('aduan')

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


                  return emptyState();


                }




                List<QueryDocumentSnapshot> docs =

                snapshot.data!.docs;



                if(selectedStatus != 'Semua'){


                  docs = docs.where((doc){


                    return doc['status']
                        ==
                        selectedStatus;


                  }).toList();


                }




                if(searchText.isNotEmpty){


                  docs = docs.where((doc){


                    var data =
                    doc.data()
                    as Map<String,dynamic>;



                    return

                    data['nama']
                        .toString()
                        .toLowerCase()
                        .contains(searchText)

                    ||

                    data['masalah']
                        .toString()
                        .toLowerCase()
                        .contains(searchText);



                  }).toList();


                }




                Map<String,List<QueryDocumentSnapshot>> kumpulan = {};



                for(var doc in docs){


                  var data =
                  doc.data()
                  as Map<String,dynamic>;



                  Timestamp? time =
                  data['tarikh'];



                  if(time != null){


                    DateTime date =
                    time.toDate();



                    String key =
                    '${namaBulan(date.month)} ${date.year}';



                    kumpulan.putIfAbsent(
                        key,
                        ()=>[]
                    );


                    kumpulan[key]!.add(doc);


                  }


                }
                                return ListView(

                  padding:
                  const EdgeInsets.all(16),


                  children:

                  kumpulan.entries.map((entry){


                    return Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,


                      children:[



                       Container(

  margin:
  const EdgeInsets.only(
    bottom:15,
  ),

  padding:
  const EdgeInsets.symmetric(
    horizontal:16,
    vertical:12,
  ),

  decoration:

  BoxDecoration(

    color:
    const Color(0xff003B73),

    borderRadius:
    BorderRadius.circular(15),

    boxShadow:[

      BoxShadow(

        color:
        Colors.black12,

        blurRadius:6,

        offset:
        const Offset(0,3),

      ),

    ],

  ),


  child:

  Row(

    children:[


      const Icon(

        Icons.calendar_month,

        color:
        Colors.white,

        size:22,

      ),


      const SizedBox(width:10),



      Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[


          Text(

            entry.key.toUpperCase(),

            style:

            const TextStyle(

              color:
              Colors.white,

              fontSize:16,

              fontWeight:
              FontWeight.bold,

            ),

          ),


          const Text(

            'Senarai aduan bulan ini',

            style:

            TextStyle(

              color:
              Colors.white70,

              fontSize:12,

            ),

          ),


        ],

      ),


    ],

  ),

),




                        ...entry.value.map((doc){



                          var data =
                          doc.data()
                          as Map<String,dynamic>;



                          String status =
                          data['status']
                          ??
                          'Baru';




                          return GestureDetector(


                            onTap:(){


                              Navigator.push(


                                context,


                                MaterialPageRoute(


                                  builder:(context)=>

                                  AdminDetailScreen(

                                    documentId:
                                    doc.id,


                                    data:
                                    data,


                                  ),


                                ),


                              );


                            },



                            child:


                            Container(


                              margin:

                              const EdgeInsets.only(
                                bottom:15,
                              ),




                              padding:

                              const EdgeInsets.all(18),




                              decoration:

                              BoxDecoration(


                                color:
                                Colors.white,



                                borderRadius:

                                BorderRadius.circular(20),




                                boxShadow:[


                                  BoxShadow(


                                    color:

                                    Colors.black12,


                                    blurRadius:8,


                                    offset:

                                    const Offset(0,4),


                                  ),


                                ],


                              ),





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


                                          data['masalah']
                                          ??
                                          'Tiada masalah',



                                          style:

                                          const TextStyle(


                                            fontSize:17,


                                            fontWeight:

                                            FontWeight.bold,


                                          ),


                                        ),


                                      ),





                                      Container(


                                        padding:

                                        const EdgeInsets.symmetric(


                                          horizontal:12,


                                          vertical:6,


                                        ),




                                        decoration:


                                        BoxDecoration(


                                          color:

                                          warnaStatus(status)
                                              .withValues(
                                              alpha:0.15
                                          ),



                                          borderRadius:

                                          BorderRadius.circular(20),



                                        ),




                                        child:


                                        Text(


                                          status,


                                          style:


                                          TextStyle(


                                            color:

                                            warnaStatus(status),



                                            fontSize:12,


                                            fontWeight:

                                            FontWeight.bold,


                                          ),


                                        ),


                                      ),



                                    ],


                                  ),







                                  const SizedBox(height:15),





                                  Row(


                                    children:[



                                      const Icon(

                                        Icons.person,

                                        size:18,

                                        color:
                                        Colors.grey,

                                      ),



                                      const SizedBox(width:8),



                                      Text(

                                        data['nama']
                                        ??
                                        '-',

                                      ),


                                    ],


                                  ),






                                  const SizedBox(height:8),





                                  Row(


                                    children:[


                                      const Icon(

                                        Icons.category,

                                        size:18,

                                        color:
                                        Colors.grey,

                                      ),



                                      const SizedBox(width:8),



                                      Text(

                                        data['kategori']
                                        ??
                                        '-',

                                      ),



                                    ],


                                  ),






                                  const SizedBox(height:8),






                                  Row(


                                    children:[



                                      const Icon(

                                        Icons.location_on,

                                        size:18,

                                        color:
                                        Colors.grey,

                                      ),




                                      const SizedBox(width:8),




                                      Expanded(


                                        child:


                                        Text(

                                          data['lokasi']
                                          ??
                                          '-',

                                        ),


                                      ),


                                    ],


                                  ),







                                  const SizedBox(height:15),






                                  Divider(

                                    color:
                                    Colors.grey.shade200,

                                  ),







                                  Row(


                                    mainAxisAlignment:

                                    MainAxisAlignment.spaceBetween,



                                    children:[





                                      Row(


                                        children:[


                                          Icon(

                                            Icons.calendar_month,

                                            size:16,

                                            color:

                                            Colors.grey.shade600,

                                          ),



                                          const SizedBox(width:5),



                                          Text(

                                            formatTarikh(
                                                data['tarikh']
                                            ),


                                            style:

                                            TextStyle(

                                              fontSize:13,

                                              color:

                                              Colors.grey.shade700,

                                            ),


                                          ),



                                        ],


                                      ),





                                      Row(


                                        children:[


                                          Icon(

                                            Icons.access_time,

                                            size:16,

                                            color:

                                            Colors.grey.shade600,

                                          ),



                                          const SizedBox(width:5),




                                          Text(

                                            formatMasa(
                                                data['tarikh']
                                            ),


                                            style:

                                            TextStyle(

                                              fontSize:13,

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


                          );



                        }).toList(),




                        const SizedBox(height:10),


                      ],


                    );


                  }).toList(),


                );


              },


            ),


          ),


        ],


      ),


    );


  }







  Widget emptyState(){


    return Center(


      child:

      Column(

        mainAxisAlignment:

        MainAxisAlignment.center,


        children:[



          Icon(

            Icons.assignment_outlined,

            size:70,

            color:
            Colors.grey.shade400,

          ),




          const SizedBox(height:15),




          const Text(

            'Tiada Aduan',

            style:

            TextStyle(

              fontSize:20,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          const SizedBox(height:5),




          Text(

            'Belum ada rekod aduan ditemui.',

            style:

            TextStyle(

              color:
              Colors.grey,

            ),

          ),



        ],

      ),


    );


  }



}