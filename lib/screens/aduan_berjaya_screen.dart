import 'package:flutter/material.dart';


class AduanBerjayaScreen extends StatelessWidget {

  final String aduanID;
  final String kategori;
  final String subKategori;
  final String lokasi;
  final String tarikh;


  const AduanBerjayaScreen({

    super.key,

    required this.aduanID,
    required this.kategori,
    required this.subKategori,
    required this.lokasi,
    required this.tarikh,

  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          'Aduan Berjaya'
        ),

        backgroundColor:
        Colors.blue[900],

      ),


      body:

      Padding(

        padding:
        const EdgeInsets.all(20),


        child:

        Column(

          children:[


            const SizedBox(height:30),



            const Icon(

              Icons.check_circle,

              color:
              Colors.green,

              size:80,

            ),



            const SizedBox(height:20),



            const Text(

              'Aduan Berjaya Dihantar',

              style:

              TextStyle(

                fontSize:22,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),



            const Text(

              'Aduan anda telah diterima oleh Unit ICT KUYPJ',

              textAlign:
              TextAlign.center,

            ),



            const SizedBox(height:30),



            Card(

              child:

              Padding(

                padding:
                const EdgeInsets.all(15),


                child:

                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[


                    Text(
                      'No. Aduan: $aduanID'
                    ),


                    const SizedBox(height:10),


                    Text(
                      'Tarikh: $tarikh'
                    ),


                    const SizedBox(height:10),


                    Text(
                      'Kategori: $kategori'
                    ),


                    const SizedBox(height:10),


                    Text(
                      'Jenis Kerosakan: $subKategori'
                    ),


                    const SizedBox(height:10),


                    Text(
                      'Lokasi: $lokasi'
                    ),


                    const SizedBox(height:10),


                    const Text(
                      'Status: Baharu'
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

}