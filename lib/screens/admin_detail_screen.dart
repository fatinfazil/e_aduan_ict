import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AdminDetailScreen extends StatefulWidget {

  final String documentId;
  final Map<String,dynamic> data;


  const AdminDetailScreen({

    super.key,

    required this.documentId,

    required this.data,

  });



  @override
  State<AdminDetailScreen> createState() =>
      _AdminDetailScreenState();

}






class _AdminDetailScreenState
    extends State<AdminDetailScreen> {


  late String status;

  String remark = '';




  final List<String> statusList = [

    'Baru',

    'Dalam Tindakan',

    'Selesai',

    'Ditolak',

  ];





  @override
  void initState(){

    super.initState();


    status =
        widget.data['status'] ?? 'Baru';


    remark =
        widget.data['remark'] ?? '';

  }







  Color statusColor(String status){


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







  IconData statusIcon(String status){


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







  String getStatusMessage(String status){


    switch(status){


      case 'Baru':

        return 'Aduan telah diterima oleh ICT';



      case 'Dalam Tindakan':

        return 'Aduan sedang diproses oleh pihak ICT';



      case 'Selesai':

        return 'Aduan telah selesai diselesaikan';



      case 'Ditolak':

        return 'Aduan tidak dapat diproses';



      default:

        return '';

    }


  }








  Future<void> updateStatus() async {


    await FirebaseFirestore.instance
    .collection('aduan')
    .doc(widget.documentId)
    .update({

  'status': status,

  'statusMessage':
  getStatusMessage(status),

  'remark': remark,

  'updatedAt':
  Timestamp.now(),

  'statusHistory': FieldValue.arrayUnion([

  {
    'status': status,
    'message': getStatusMessage(status),
    'tarikh': Timestamp.now(),
  }

]),


});

   try {

  print("MULA CREATE NOTIFICATION");

  await FirebaseFirestore.instance
      .collection('notifications')
      .add({

    'userId': widget.data['uid'],

    'title':
    'Aduan ICT Dikemaskini',

    'message':
    'Status aduan anda telah berubah kepada $status',

    'status':
    status,

    'tarikh':
    Timestamp.now(),

    'read':
    false,

  });

  print("NOTIFICATION BERJAYA");


} catch(e) {

  print("ERROR NOTIFICATION: $e");

}



    if(!mounted) return;


showDialog(

context: context,

barrierDismissible:false,


builder:(context){

return AlertDialog(

backgroundColor:
Colors.white,


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(25),

),


content:

Column(

mainAxisSize:
MainAxisSize.min,


children:[


Container(

width:80,

height:80,


decoration:

const BoxDecoration(

color:
Color(0xffE8F5E9),

shape:
BoxShape.circle,

),


child:

const Icon(

Icons.check_circle,

size:60,

color:
Colors.green,

),

),



const SizedBox(height:20),



const Text(

'Kemaskini Berjaya',

style:

TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:10),



Text(

'Status aduan telah ditukar kepada:\n$status',

textAlign:
TextAlign.center,


style:

TextStyle(

color:
Colors.grey,

fontSize:15,

),

),



const SizedBox(height:25),



SizedBox(

width:
double.infinity,


child:

ElevatedButton(

style:

ElevatedButton.styleFrom(

backgroundColor:
const Color(0xff003B73),

foregroundColor:
Colors.white,


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(12),

),

),


onPressed:(){

Navigator.pop(context);

Navigator.pop(context);

},


child:

const Text(

'OK',

),

),

),



],

),

);


},

);
  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
const Color(0xffF5F7FA),





      appBar: AppBar(


        title:

        const Text(

          'Detail Aduan',

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

      SingleChildScrollView(


        padding:

        const EdgeInsets.all(20),



        child:


        Column(


          crossAxisAlignment:

          CrossAxisAlignment.start,



          children:[

            Container(

padding:
const EdgeInsets.all(18),


margin:
const EdgeInsets.only(bottom:20),


decoration:

BoxDecoration(

color:
statusColor(status)
.withValues(alpha:0.15),


borderRadius:
BorderRadius.circular(20),


),


child:

Row(

children:[


Icon(

statusIcon(status),

color:
statusColor(status),

size:40,

),


const SizedBox(width:15),


Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


const Text(

'Status Aduan',

style:

TextStyle(

color:
Colors.grey,

),

),



Text(

status,

style:

TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

color:
statusColor(status),

),

),


],

),


],


),

),



            infoCard(
              'Nama Pengadu',
              widget.data['nama'],
            ),



            infoCard(
              'Email',
              widget.data['email'],
            ),



            infoCard(
              'Kategori',
              widget.data['kategori'],
            ),



            infoCard(
              'Lokasi',
              widget.data['lokasi'],
            ),



            infoCard(
              'Masalah',
              widget.data['masalah'],
            ),




            if(widget.data['gambarBase64'] != null &&
                widget.data['gambarBase64']
                    .toString()
                    .isNotEmpty)

              imageCard(),




            const SizedBox(height:25),




            const Text(

              'Kemaskini Status',

              style:

              TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:12),



            DropdownButtonFormField<String>(

              initialValue: status,


              decoration:

              InputDecoration(


                labelText:

                'Status Aduan',



                filled:true,


                fillColor:

                Colors.white,



                border:

                OutlineInputBorder(

                  borderRadius:

                  BorderRadius.circular(15),

                ),

              ),



              items:

              statusList.map((item){


                return DropdownMenuItem(


                  value:item,


                  child:

                  Row(

                    children:[


                      Icon(

                        statusIcon(item),

                        color:
                        statusColor(item),

                        size:18,

                      ),



                      const SizedBox(width:8),



                      Text(

                        item,

                        style:

                        TextStyle(

                          color:
                          statusColor(item),

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),


                    ],

                  ),


                );


              }).toList(),



              onChanged:(value){


                setState((){

                  status =
                  value!;

                });


              },


            ),



            const SizedBox(height:20),
            const Text(

              'Catatan ICT',

              style:

              TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),




            TextFormField(

              initialValue: remark,


              maxLines:4,


              decoration:

              InputDecoration(

                hintText:
                'Masukkan catatan untuk pengadu...',


                filled:true,


                fillColor:
                Colors.white,


                border:

                OutlineInputBorder(

                  borderRadius:

                  BorderRadius.circular(15),

                ),

              ),



              onChanged:(value){

                remark = value;

              },


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

                updateStatus,



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

const Row(

mainAxisAlignment:
MainAxisAlignment.center,

children:[

Icon(
Icons.save,
),

SizedBox(width:8),

Text(
'KEMASKINI STATUS',
),

],

),


              ),


            ),



          ],


        ),


      ),


    );


  }







  Widget imageCard(){


    return Container(


      width:

      double.infinity,



      margin:

      const EdgeInsets.only(

        bottom:16,

      ),



      padding:

      const EdgeInsets.all(16),




      decoration:

BoxDecoration(

color:
Colors.white,


border:

Border.all(

color:
const Color(0xffE0E6ED),

),


borderRadius:

BorderRadius.circular(18),


),




      child:

      Column(



        crossAxisAlignment:

        CrossAxisAlignment.start,



        children:[




          const Text(


            'Bukti Gambar Kerosakan',


            style:

            TextStyle(


              color:

              Colors.grey,


              fontSize:13,


            ),

          ),




          const SizedBox(height:12),






          ClipRRect(



            borderRadius:

            BorderRadius.circular(15),




            child:

            Image.memory(



              base64Decode(


                widget.data['gambarBase64']
                    .toString(),


              ),




              width:

              double.infinity,



              height:

              220,



              fit:

              BoxFit.cover,


            ),



          ),



        ],


      ),


    );


  }







  Widget infoCard(String title, dynamic value){


    return Container(



      width:

      double.infinity,



      margin:

      const EdgeInsets.only(

        bottom:16,

      ),




      padding:

      const EdgeInsets.all(16),





      decoration:

      BoxDecoration(



        color:

        Colors.white,



        borderRadius:

        BorderRadius.circular(18),




        boxShadow:[


          BoxShadow(

            color:

            Colors.grey.shade200,


            blurRadius:

            8,

          ),


        ],


      ),




      child:

      Column(



        crossAxisAlignment:

        CrossAxisAlignment.start,



        children:[




          Text(



            title,



            style:

            const TextStyle(



              color:

              Colors.grey,



              fontSize:13,



            ),


          ),




          const SizedBox(height:6),





          Text(



            value?.toString() ?? '-',



            style:

            const TextStyle(



              fontSize:16,



              fontWeight:

              FontWeight.bold,



            ),


          ),



        ],


      ),


    );


  }


}