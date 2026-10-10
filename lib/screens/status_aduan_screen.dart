import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusAduanScreen extends StatefulWidget {
  const StatusAduanScreen({super.key});

  @override
  State<StatusAduanScreen> createState() => _StatusAduanScreenState();
}

class _StatusAduanScreenState extends State<StatusAduanScreen> {
  String statusDipilih = 'Semua';

  final List<String> senaraiStatus = [
    'Semua',
    'Baru',
    'Dalam Tindakan',
    'Selesai',
    'Ditolak',
  ];

  final CollectionReference<Map<String, dynamic>> aduanCollection =
      FirebaseFirestore.instance.collection('aduan');

  Color warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
  return Colors.orange;

case 'dalam tindakan':
  return const Color(0xff003B73);

case 'selesai':
  return Colors.green;

case 'ditolak':
  return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData ikonStatus(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Icons.fiber_new_rounded;

      case 'dalam tindakan':
        return Icons.build_circle_rounded;

      case 'selesai':
        return Icons.check_circle_rounded;

      case 'ditolak':
        return Icons.cancel_rounded;

      default:
        return Icons.info_rounded;
    }
  }

  String formatTarikh(dynamic nilaiTarikh) {
    if (nilaiTarikh is! Timestamp) {
      return 'Tiada tarikh';
    }

    final DateTime tarikh = nilaiTarikh.toDate();

    const List<String> bulan = [
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

    return '${tarikh.day} ${bulan[tarikh.month - 1]} ${tarikh.year}';
  }
Widget paparanGambar(Map<String, dynamic> data) {

  final String? gambarBase64 = data['gambarBase64'];

  if (gambarBase64 == null || gambarBase64.isEmpty) {
    return const SizedBox();
  }

  try {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 15),

        const Text(
          'Gambar Aduan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.memory(
            base64Decode(gambarBase64),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),

      ],
    );

  } catch (e) {

    return const Text(
      'Gambar tidak dapat dipaparkan',
      style: TextStyle(
        color: Colors.red,
      ),
    );

  }
}
  void bukaButiranAduan(
    String documentId,
    Map<String, dynamic> data,
  ) {
    final String masalah = data['masalah']?.toString() ?? 'Tiada maklumat';
    final String kategori = data['kategori']?.toString() ?? '-';
    final String lokasi = data['lokasi']?.toString() ?? '-';
    final String nama = data['nama']?.toString() ?? '-';
    final String status = data['status']?.toString() ?? 'Baru';
    final String tarikh = formatTarikh(data['tarikh']);

    final Color statusColor = warnaStatus(status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 22),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                Text(
                  masalah,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'ID: $documentId',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                barisMaklumat(
                  icon: Icons.person_rounded,
                  label: 'Nama',
                  nilai: nama,
                ),

                barisMaklumat(
                  icon: Icons.category_rounded,
                  label: 'Kategori',
                  nilai: kategori,
                ),

                barisMaklumat(
                  icon: Icons.location_on_rounded,
                  label: 'Lokasi',
                  nilai: lokasi,
                ),

                barisMaklumat(
                  icon: Icons.calendar_month_rounded,
                  label: 'Tarikh',
                  nilai: tarikh,
                ),

                const SizedBox(height: 20),

paparanGambar(data),

const SizedBox(height:20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        ikonStatus(status),
                        color: statusColor,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
               ),

const SizedBox(height:20),

const Text(
  'Sejarah Status',
  style: TextStyle(
    fontSize:16,
    fontWeight:FontWeight.bold,
  ),
),

const SizedBox(height:12),

paparanTimeline(data),

const SizedBox(height:20),
if(data['remark'] != null &&
   data['remark'].toString().isNotEmpty)

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


const Text(
  'Catatan ICT',
  style: TextStyle(
    fontSize:16,
    fontWeight:FontWeight.bold,
  ),
),


const SizedBox(height:10),


Container(

width:
double.infinity,


padding:
const EdgeInsets.all(15),


decoration:

BoxDecoration(

color:
const Color(0xffF5F7FA),

borderRadius:
BorderRadius.circular(15),

border:

Border.all(
color: Colors.grey.shade200,
),

),


child:

Text(

data['remark'].toString(),

style:

const TextStyle(

fontSize:15,

),

),

),

],
),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget paparanTimeline(Map<String,dynamic> data){

final history =
data['statusHistory'] as List<dynamic>?;


if(history == null || history.isEmpty){

return Container(

padding:
const EdgeInsets.all(15),

decoration:

BoxDecoration(

color:
Colors.grey.shade100,

borderRadius:
BorderRadius.circular(15),

),

child:

const Text(
'Tiada sejarah status',
style:
TextStyle(
color: Colors.grey,
),
),

);

}


return Column(

children:

history.map((item){

final String status =
item['status'] ?? '';

final String message =
item['message'] ?? '';

return Container(

margin:
const EdgeInsets.only(bottom:12),


child:

Row(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


Icon(

Icons.check_circle,

color:
warnaStatus(status),

),


const SizedBox(width:12),


Expanded(

child:

Container(

padding:
const EdgeInsets.all(14),


decoration:

BoxDecoration(

color:
warnaStatus(status)
.withValues(alpha:0.1),

borderRadius:
BorderRadius.circular(15),

),


child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


Text(

status,

style:

TextStyle(

fontWeight:
FontWeight.bold,

color:
warnaStatus(status),

),

),


const SizedBox(height:5),


Text(

message,

style:

const TextStyle(

fontSize:14,

),

),


const SizedBox(height:5),


Text(

formatTarikh(item['tarikh']),

style:

TextStyle(

fontSize:12,

color:
Colors.grey.shade600,

),

),


],

),

),

),


],

),

);

}).toList(),

);

}

  Widget barisMaklumat({
    required IconData icon,
    required String label,
    required String nilai,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Status Aduan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor:
const Color(0xff003B73),
      ),
      body: Column(
        children: [
           const SizedBox(height:20),
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

          Icons.track_changes_rounded,

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

              'Semak Status Aduan',

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

              'Pantau perkembangan laporan ICT anda',

              style:

              TextStyle(

                color:
                Colors.white70,

                fontSize:13,

              ),

            ),


          ],

        ),

      )



    ],

  ),

),

          const SizedBox(height: 16),

          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: senaraiStatus.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 8);
              },
              itemBuilder:(context,index){

final String statusItem =
senaraiStatus[index];


final bool dipilih =
statusDipilih == statusItem;

                return ChoiceChip(

  label:

  Text(statusItem),


  selected:

  dipilih,


  showCheckmark:

  false,


  selectedColor:

  warnaStatus(statusItem)
      .withValues(
      alpha:0.15
  ),



  backgroundColor:

  Colors.white,



  side:

  BorderSide(

    color:

    dipilih

        ? warnaStatus(statusItem)

        : Colors.grey.shade300,

  ),



  labelStyle:

  TextStyle(

    color:

    dipilih

        ? warnaStatus(statusItem)

        : Colors.black87,


    fontWeight:

    FontWeight.w600,

  ),




  onSelected:(value){


    setState((){


      statusDipilih =

      statusItem;


    });


  },


);
  
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: aduanCollection
    .where(
      'uid',
      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
    )
    .orderBy(
      'tarikh',
      descending: true,
    )
    .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return paparanRalat(snapshot.error.toString());
                }

                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    semuaDokumen = snapshot.data?.docs ?? [];

                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    dokumenDitapis = semuaDokumen.where((doc) {
                  final String status =
                      doc.data()['status']?.toString() ?? 'Baru';

                  if (statusDipilih == 'Semua') {
                    return true;
                  }

                  return status.toLowerCase() ==
                      statusDipilih.toLowerCase();
                }).toList();

                if (dokumenDitapis.isEmpty) {
                  return paparanKosong();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: dokumenDitapis.length,
                  itemBuilder: (context, index) {
                    final document = dokumenDitapis[index];

                    return kadAduan(
                      document.id,
                      document.data(),
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

  Widget kadAduan(
    String documentId,
    Map<String, dynamic> data,
  ) {
    final String masalah =
        data['masalah']?.toString() ?? 'Tiada maklumat masalah';

    final String kategori = data['kategori']?.toString() ?? '-';
    final String lokasi = data['lokasi']?.toString() ?? '-';
    final String nama = data['nama']?.toString() ?? '-';
    final String status = data['status']?.toString() ?? 'Baru';
    final String tarikh = formatTarikh(data['tarikh']);

    final Color statusColor = warnaStatus(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          bukaButiranAduan(
            documentId,
            data,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      ikonStatus(status),
                      color: statusColor,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          masalah,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          kategori,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(
                    Icons.person_outline_rounded,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      nama,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      lokasi,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    tarikh,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paparanKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 14),
          const Text(
            'Tiada aduan dijumpai',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tiada aduan dengan status $statusDipilih.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget paparanRalat(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 65,
            ),
            const SizedBox(height: 14),
            const Text(
              'Gagal mengambil data aduan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}