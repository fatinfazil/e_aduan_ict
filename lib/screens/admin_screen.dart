import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

import 'admin_aduan_screen.dart';



class AdminScreen extends StatefulWidget {

  const AdminScreen({super.key});


  @override
  State<AdminScreen> createState() => _AdminScreenState();

}


class _AdminScreenState extends State<AdminScreen> {

DateTime selectedMonth = DateTime.now();

  int kiraStatus(
      List<QueryDocumentSnapshot> docs,
      String status
      ){

    return docs
        .where(
            (doc) =>
        doc['status'] == status
    )
        .length;

  }


  @override
  Widget build(BuildContext context) {


   return Scaffold(

      drawer: Drawer(

        child: Column(

          children:[


            UserAccountsDrawerHeader(

              decoration:

              const BoxDecoration(

                gradient:

                LinearGradient(

                  colors:[

                    Color(0xff003B73),

                    Color(0xff00509E),

                  ],

                ),

              ),

              accountName:

              const Text(
                'Admin ICT',
              ),

              accountEmail:

              const Text(
                'Pengurusan Sistem Aduan',
              ),


              currentAccountPicture:

              const CircleAvatar(

                backgroundColor:
                Colors.white,

                child:

                Icon(

                  Icons.admin_panel_settings,

                  color:
                  Color(0xff003B73),

                  size:40,

                ),

              ),

            ),


            ListTile(

              leading:
              const Icon(Icons.dashboard),

              title:
              const Text('Dashboard'),

              onTap:(){

                Navigator.pop(context);

              },

            ),



            ListTile(

              leading:
              const Icon(Icons.assignment),

              title:
              const Text('Semua Aduan'),

              onTap:(){

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder:(context)=>

                    const AdminAduanScreen(),

                  ),

                );

              },

            ),



            const Spacer(),



            ListTile(

              leading:
              const Icon(
                Icons.logout,
                color:Colors.red,
              ),

              title:

              const Text(
                'Logout',
                style:
                TextStyle(
                  color:Colors.red,
                ),
              ),

             onTap:(){

  Navigator.pop(context);


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

          ),


        ],

      );

    },

  );

},

            ),


          ],

        ),

      ),


      backgroundColor:
      const Color(0xffF5F7FA),



      appBar: AppBar(

  title: const Text(
    'Admin Dashboard',
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),

  centerTitle:true,

  backgroundColor:
const Color(0xff003B73),


  actions:[

  IconButton(

    icon:
    const Icon(Icons.logout),


   onPressed:(){

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

          ),


        ],

      );

    },

  );

},

  ),

],


),






      body:

SingleChildScrollView(

child:

Padding(

padding:
const EdgeInsets.all(20),


child:

Column(



          crossAxisAlignment:

          CrossAxisAlignment.start,



          children:[




            Container(

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
BorderRadius.circular(20),


),


child:

Row(

children:[


const Icon(

Icons.admin_panel_settings,

color:
Colors.white,

size:45,

),


const SizedBox(width:15),


Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


const Text(

'Selamat Datang',

style:

TextStyle(

color:
Colors.white,

fontSize:16,

),

),



Text(

'Admin ICT',

style:

TextStyle(

color:
Colors.white,

fontSize:22,

fontWeight:
FontWeight.bold,

),

),



],

),


],


),

),




            const SizedBox(height:25),







            StreamBuilder<QuerySnapshot>(


              stream:


              FirebaseFirestore.instance

                  .collection('aduan')

                  .snapshots(),





              builder:(context,snapshot){



                if(!snapshot.hasData){


                  return const Center(

                    child:
                    CircularProgressIndicator(),

                  );


                }




                List<QueryDocumentSnapshot> docs =

                snapshot.data!.docs;







                return GridView.count(

  shrinkWrap:true,

  physics:
  const NeverScrollableScrollPhysics(),

  crossAxisCount:2,

  crossAxisSpacing:15,

  mainAxisSpacing:15,

  childAspectRatio: 1.3,




                  children:[






                    dashboardCard(

                      'Jumlah Aduan',

                      docs.length.toString(),

                      Icons.assignment,

                      Colors.blue,

                    ),







                    dashboardCard(

                      'Aduan Baru',

                      kiraStatus(
                          docs,
                          'Baru'
                      ).toString(),

                      Icons.warning,

                      Colors.orange,

                    ),







                    dashboardCard(

                      'Dalam Tindakan',

                      kiraStatus(
                          docs,
                          'Dalam Tindakan'
                      ).toString(),

                      Icons.pending_actions,

                      Colors.blue,

                    ),







                    dashboardCard(

                      'Selesai',

                      kiraStatus(
                          docs,
                          'Selesai'
                      ).toString(),

                      Icons.check_circle,

                      Colors.green,

                    ),





                  ],


                );



              },


            ),






            const SizedBox(height:30),

            Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children:[


const Text(

'Prestasi Bulanan',

style:

TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold,

),

),



GestureDetector(

onTap:(){

  pilihBulan();

},


child:

Container(

padding:
const EdgeInsets.all(10),


decoration:

BoxDecoration(

color:
const Color(0xff003B73),

borderRadius:
BorderRadius.circular(12),

),


child:

const Icon(

Icons.calendar_month,

color:
Colors.white,

size:22,

),

),

),


],

),

const SizedBox(height:8),



const SizedBox(height:15),


MonthlyReport(selectedMonth),

const SizedBox(height:25),


SizedBox(


              width:
              double.infinity,



              height:
              55,





              child:


              ElevatedButton.icon(



                onPressed:(){



                  Navigator.push(


                    context,


                    MaterialPageRoute(


                      builder:(context)=>

                      const AdminAduanScreen(),


                    ),


                  );


                },



                icon:

                const Icon(
                  Icons.list,
                ),




                label:

                const Text(

                  'Lihat Semua Aduan',

                  style:

                  TextStyle(

                    fontSize:16,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),




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



              ),


            ),




                   ],

        ),

      ),
  
    )
   );

  }








  Widget dashboardCard(

      String title,

      String value,

      IconData icon,

      Color color

      ){

        



    return Container(



      padding:
      const EdgeInsets.all(12),





     decoration:

BoxDecoration(

color:
Colors.white,


border:

Border.all(

color:
color.withValues(alpha:0.25),

),


borderRadius:

BorderRadius.circular(18),





        boxShadow:[

BoxShadow(

color:
color.withValues(alpha:0.15),

blurRadius:
15,

offset:
const Offset(0,6),

),

],



      ),






      child:


      Column(



        mainAxisAlignment:

        MainAxisAlignment.center,



        children:[





          Icon(

            icon,

            size:28,

            color:color,

          ),






          const SizedBox(height:10),





          Text(


            value,


            style:

            const TextStyle(


              fontSize:22,


              fontWeight:
              FontWeight.bold,


            ),


          ),






          Text(


            title,


            textAlign:
            TextAlign.center,



            style:

            const TextStyle(


              color:
              Colors.grey,


            ),



          ),




        ],



      ),



    );


  }
Widget MonthlyReport(DateTime month){

  return StreamBuilder<QuerySnapshot>(

    stream:
    FirebaseFirestore.instance
        .collection('aduan')
        .snapshots(),


    builder:(context,snapshot){


      if(!snapshot.hasData){

        return const CircularProgressIndicator();

      }


      Map<String, Map<String,int>> bulan = {};



      for(var doc in snapshot.data!.docs){


        final data =
        doc.data() as Map<String,dynamic>;



        Timestamp? tarikh =
        data['tarikh'];



        if(tarikh != null){


          DateTime date =
          tarikh.toDate();


          String key =
          '${date.month}/${date.year}';



          bulan.putIfAbsent(key, () => {

            'jumlah':0,
            'baru':0,
            'proses':0,
            'selesai':0,

          });



          bulan[key]!['jumlah'] =
          bulan[key]!['jumlah']! + 1;



          if(data['status']=='Baru'){

            bulan[key]!['baru'] =
            bulan[key]!['baru']! + 1;

          }


          if(data['status']=='Dalam Tindakan'){

            bulan[key]!['proses'] =
            bulan[key]!['proses']! + 1;

          }


          if(data['status']=='Selesai'){

            bulan[key]!['selesai'] =
            bulan[key]!['selesai']! + 1;

          }


        }

      }



      String selectedKey =
'${month.month}/${month.year}';


Map<String,int> dataBulan = {

  'jumlah':0,
  'baru':0,
  'proses':0,
  'selesai':0,

};


if(bulan.containsKey(selectedKey)){

  dataBulan = bulan[selectedKey]!;

}


      return Column(

  children:[

    buildMonthlyCard(

      month.month,

      month.year,

      dataBulan,

    ),

  ],

);


    },

  );


}

void pilihBulan() async {

  int selectedYear = selectedMonth.year;


  DateTime? result = await showDialog<DateTime>(

    context: context,

    builder:(context){

      return StatefulBuilder(

        builder:(context,setDialogState){


          return AlertDialog(

            shape:

            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(20),

            ),


            title:

            const Text(

              'Pilih Bulan',

              style:

              TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            ),



            content:

            SizedBox(

              width:330,

              height:380,


              child:

              Column(

                children:[


                  DropdownButton<int>(

                    value:selectedYear,


                    items:

                    List.generate(

                      5,

                      (index){

                        int year =
DateTime.now().year + index;


                        return DropdownMenuItem(

                          value:year,

                          child:Text(

                            year.toString(),

                          ),

                        );

                      },

                    ),


                    onChanged:(value){


                      setDialogState((){

                        selectedYear = value!;

                      });


                    },

                  ),



                  const SizedBox(height:20),



                  Expanded(

                    child:

                    GridView.count(

                      crossAxisCount:3,


                      mainAxisSpacing:10,

                      crossAxisSpacing:10,


                      children:


                      List.generate(12,(index){


                        int bulan=index+1;


                        return InkWell(


                          borderRadius:

                          BorderRadius.circular(12),


                          onTap:(){


                            Navigator.pop(

                              context,


                              DateTime(

                                selectedYear,

                                bulan,

                              ),

                            );


                          },


                          child:

                          Container(


                            alignment:

                            Alignment.center,


                            decoration:

                            BoxDecoration(

                              color:

                              const Color(0xff003B73),

                              borderRadius:

                              BorderRadius.circular(12),

                            ),



                            child:

                            Text(

                              [

                                'JAN',

                                'FEB',

                                'MAC',

                                'APR',

                                'MEI',

                                'JUN',

                                'JUL',

                                'OGOS',

                                'SEP',

                                'OKT',

                                'NOV',

                                'DIS'

                              ][index],


                              style:

                              const TextStyle(

                                color:
                                Colors.white,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),


                          ),

                        );


                      }),

                    ),

                  ),

                ],

              ),

            ),

          );


        },

      );


    },

  );



  if(result != null){

    setState((){

      selectedMonth=result;

    });

  }

}
Widget buildMonthlyCard(
int bulan,
int tahun,
Map<String,int> data
){

String namaBulan = [

'',
'JANUARI',
'FEBRUARI',
'MAC',
'APRIL',
'MEI',
'JUN',
'JULAI',
'OGOS',
'SEPTEMBER',
'OKTOBER',
'NOVEMBER',
'DISEMBER'

][bulan];


int jumlah = data['jumlah'] ?? 0;
int selesai = data['selesai'] ?? 0;


double progress = jumlah == 0
    ? 0
    : selesai / jumlah;



return Container(

padding:
const EdgeInsets.all(22),


decoration:

BoxDecoration(

gradient:

const LinearGradient(

colors:[

Color(0xff003B73),

Color(0xff0066B3),

],

begin:
Alignment.topLeft,

end:
Alignment.bottomRight,

),


borderRadius:
BorderRadius.circular(25),


boxShadow:[

BoxShadow(

color:
Colors.black.withValues(alpha:0.15),

blurRadius:15,

offset:
const Offset(0,8),

)

],

),



child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[



Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[


Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

'$namaBulan $tahun',

style:

const TextStyle(

color:
Colors.white70,

fontSize:14,

),

),


const SizedBox(height:5),


const Text(

'Prestasi Aduan',

style:

TextStyle(

color:
Colors.white,

fontSize:22,

fontWeight:
FontWeight.bold,

),

),


],

),



Container(

padding:
const EdgeInsets.all(10),


decoration:

BoxDecoration(

color:
Colors.white24,

borderRadius:
BorderRadius.circular(12),

),


child:

const Icon(

Icons.bar_chart,

color:
Colors.white,

),

)

],

),



const SizedBox(height:25),




Text(

jumlah.toString(),

style:

const TextStyle(

color:
Colors.white,

fontSize:45,

fontWeight:
FontWeight.bold,

),

),


const Text(

'Jumlah Aduan Bulan Ini',

style:

TextStyle(

color:
Colors.white70,

),

),



const SizedBox(height:25),



Row(

children:[


Expanded(

child:

statusBox(

'Baru',

data['baru'] ?? 0,

Colors.orange,

),

),


const SizedBox(width:10),


Expanded(

child:

statusBox(

'Proses',

data['proses'] ?? 0,

Colors.blue,

),

),


const SizedBox(width:10),


Expanded(

child:

statusBox(

'Selesai',

data['selesai'] ?? 0,

Colors.green,

),

),


],

),




const SizedBox(height:25),




Text(

'Selesai ${(progress*100).toInt()}%',

style:

const TextStyle(

color:
Colors.white,

fontWeight:
FontWeight.bold,

),

),



const SizedBox(height:10),



ClipRRect(

borderRadius:
BorderRadius.circular(20),


child:

LinearProgressIndicator(

value:
progress,

minHeight:10,

backgroundColor:
Colors.white24,

valueColor:

const AlwaysStoppedAnimation(

Colors.green,

),

),

),


],

),

);


}

Widget statusBox(
String title,
int value,
Color color
){

return Container(

width:90,

padding:
const EdgeInsets.all(10),


decoration:

BoxDecoration(

color:
Colors.white.withValues(alpha:0.95),

borderRadius:
BorderRadius.circular(15),

),


child:

Column(

children:[


Text(

value.toString(),

style:

TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

color:
color,

),

),


const SizedBox(height:5),


Text(

title,

style:

const TextStyle(

fontSize:12,

color:
Colors.grey,

),

),


],

),

);

}
}