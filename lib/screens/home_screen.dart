import 'package:flutter/material.dart';
import 'aduan_screen.dart';
import 'aduan_saya_screen.dart';
import 'status_aduan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(

  title: const Text(
    'e-Aduan ICT KUYPJ',
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),

  centerTitle: true,

  backgroundColor:
  const Color(0xff003B73),

  elevation: 0,


  actions: [

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

print("UID LOGIN: ${FirebaseAuth.instance.currentUser!.uid}");
print("BADGE JUMLAH: ${snapshot.data?.docs.length}");
print("BADGE ERROR: ${snapshot.error}");


int jumlah = 0;


if(snapshot.hasData){

  jumlah = snapshot.data!.docs.where((doc){

    final data =
    doc.data()
    as Map<String,dynamic>;


    return data['read'] != true;

  }).length;

}

return Stack(

children:[


IconButton(

icon:

const Icon(

Icons.notifications_rounded,

color: Colors.white,

),


onPressed:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)=>

const NotificationScreen(),

),

);


},

),



if(jumlah > 0)


Positioned(

right:7,

top:7,


child:

Container(

padding:

const EdgeInsets.all(5),


constraints:

const BoxConstraints(

minWidth:20,

minHeight:20,

),


decoration:

const BoxDecoration(

color: Colors.red,

shape: BoxShape.circle,

),


child:

Text(

jumlah.toString(),

style:

const TextStyle(

color: Colors.white,

fontSize:11,

fontWeight: FontWeight.bold,

),

),

),

),


],

);


},


),

],

),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(

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

               child: Column(
  children: [

                  Icon(

Icons.account_circle,

size:80,

color:Colors.white,

),

                    SizedBox(height: 15),

                    StreamBuilder<DocumentSnapshot>(

stream:

FirebaseFirestore.instance
.collection('users')
.doc(
FirebaseAuth.instance.currentUser!.uid
)
.snapshots(),


builder:(context,snapshot){


String nama = 'Pengguna';


if(snapshot.hasData &&
snapshot.data!.exists){


final data =
snapshot.data!.data()
as Map<String,dynamic>;


nama =
data['nama'] ?? 'Pengguna';


}



return Text(

'Selamat Datang,\n$nama 👋',

textAlign:
TextAlign.center,


style:

const TextStyle(

color:
Colors.white,

fontSize:26,

fontWeight:
FontWeight.bold,

),

);


},

),
                

                    SizedBox(height: 8),

                    Text(
                      'Sistem Aduan Kerosakan ICT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height:10),


const SizedBox(height: 25),

UserDashboard(),
              const SizedBox(height: 30),


              // Buat Aduan
              MenuCard(
                icon: Icons.add_circle,
                title: 'Buat Aduan',
                subtitle: 'Laporkan masalah ICT',
              color:
const Color(0xff003B73),

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AduanScreen(),
                    ),
                  );

                },
              ),


              const SizedBox(height: 15),


        // Aduan Saya
MenuCard(
  icon: Icons.assignment,
  title: 'Aduan Saya',
  subtitle: 'Lihat rekod aduan anda',
  color: Colors.green,

  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AduanSayaScreen(),
      ),
    );

  },
),


              const SizedBox(height: 15),


              MenuCard(

  icon: Icons.track_changes_rounded,

  title: 'Status Aduan',

  subtitle: 'Semak perkembangan aduan',

  color: Colors.orange,


  onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) =>
            const StatusAduanScreen(),

      ),

    );

  },

),


            ],
          ),
        ),
      ),
    );
  }
}


// Widget Menu Card
class MenuCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;


  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  


  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [

            BoxShadow(
              color:
Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),

          ],

        ),


        child: Row(

          children: [

            Container(

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(

                color: color.withValues(alpha: 0.15),

                shape: BoxShape.circle,

              ),

              child: Icon(
                icon,
                color: color,
                size: 35,
              ),

            ),


            const SizedBox(width: 20),


            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height: 5),


                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),

                ],
              ),
            ),


            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),

          ],

        ),

      ),

    );

  }
}
class UserDashboard extends StatelessWidget {

  const UserDashboard({super.key});


  @override
  Widget build(BuildContext context) {


    final uid =
    FirebaseAuth.instance.currentUser!.uid;


    return StreamBuilder<QuerySnapshot>(

      stream:

      FirebaseFirestore.instance
      .collection('aduan')
      .where(
        'uid',
        isEqualTo: uid,
      )
      .snapshots(),


      builder:(context,snapshot){


        if(!snapshot.hasData){

          return const CircularProgressIndicator();

        }


        final docs =
        snapshot.data!.docs;


        int baru = 0;
        int proses = 0;
        int selesai = 0;



        for(var doc in docs){

          final status =
          doc['status'];


          if(status == 'Baru'){
            baru++;
          }

          else if(status == 'Dalam Tindakan'){
            proses++;
          }

          else if(status == 'Selesai'){
            selesai++;
          }

        }



        return Container(

          padding:
          const EdgeInsets.all(20),


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

                blurRadius:10,

                offset:
                const Offset(0,5),

              )

            ],

          ),


          child:

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[


              const Text(

                'Ringkasan Aduan Anda',

                style:

                TextStyle(

                  fontSize:20,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  Color(0xff003B73),

                ),

              ),



              const SizedBox(height:15),



              Row(

                children:[


                  dashboardMini(
                    'Jumlah',
                    docs.length,
                    Colors.blue,
                  ),


                  dashboardMini(
                    'Baru',
                    baru,
                    Colors.orange,
                  ),


                ],

              ),



              const SizedBox(height:15),



              Row(

                children:[


                  dashboardMini(
                    'Proses',
                    proses,
                    Colors.blue,
                  ),


                  dashboardMini(
                    'Selesai',
                    selesai,
                    Colors.green,
                  ),


                ],

              ),


            ],

          ),

        );


      },

    );


  }


  Widget dashboardMini(
      String title,
      int value,
      Color color
      ){


    return Expanded(

      child:

      Container(

        margin:
        const EdgeInsets.all(5),


        padding:
        const EdgeInsets.all(15),


        decoration:

        BoxDecoration(

          color:
          color.withValues(alpha:0.1),

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

                fontSize:26,

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

                fontSize:13,

              ),

            ),


          ],

        ),

      ),

    );


  }


}
