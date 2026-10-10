import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'aduan_berjaya_screen.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';


class AduanScreen extends StatefulWidget {
  const AduanScreen({super.key});

  @override
  State<AduanScreen> createState() => _AduanScreenState();
}


class _AduanScreenState extends State<AduanScreen> {

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final masalahController = TextEditingController();

  List<File> gambarList = [];
List<Uint8List> gambarWebList = [];
List<String> gambarBase64List = [];

  String? kategori;
String? subKategori;
String? lokasi;

bool loadingNama = true;
bool sedangHantar = false;
Timer? draftTimer;


final kategoriList = [
  'Hardware',
  'Software',
  'Rangkaian',
  'Sistem & Akaun',
  'Peralatan Program',
];


final lokasiList = [
  'Blok Pentadbiran',
  'Blok Akademik',
  'Makmal Komputer',
  'Bilik Pensyarah',
  'Perpustakaan',
  'Kolej Kediaman',
  'Dewan / Bilik Seminar',
  'Lain-lain',
];

final Map<String, List<String>> subKategoriList = {

  'Hardware': [
    'Komputer / Laptop',
    'Monitor / LCD',
    'Keyboard',
    'Mouse',
    'Printer',
    'Scanner',
    'Speaker / Audio',
    'Kabel / Adapter',
  ],

  'Software': [
    'Windows',
    'Microsoft Office',
    'Aplikasi Sistem',
    'Driver',
    'Antivirus',
  ],

  'Rangkaian': [
    'WiFi',
    'Kabel LAN',
    'Internet',
    'Switch',
    'Access Point',
  ],

  'Sistem & Akaun': [
    'iCampus',
    'Akaun Pengguna',
    'Kata Laluan',
    'Akses Sistem',
  ],

  'Peralatan Program': [
    'LCD / Projektor',
    'Mikrofon',
    'Sistem Audio',
    'Laptop Program',
  ],

};



 @override
void initState() {

  super.initState();

  ambilNamaPengguna();

  loadDraft();

lokasiController.addListener(triggerDraftSave);

masalahController.addListener(triggerDraftSave);

}


  Future<void> ambilNamaPengguna() async {

    User? user = FirebaseAuth.instance.currentUser;


    if (user == null) {

      setState(() {
        loadingNama = false;
      });

      return;
    }



    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();



    if (userDoc.exists) {


      final data = userDoc.data()
          as Map<String, dynamic>;



      setState(() {

        namaController.text =
            data['nama'] ?? '';

        loadingNama = false;

      });



    } else {


      setState(() {

        loadingNama = false;

      });

    }}

      


Future<void> pilihGambar() async {

final ImagePicker picker = ImagePicker();


final List<XFile> images =
await picker.pickMultiImage(
imageQuality: 50,
);


if(images.length > 3){

ScaffoldMessenger.of(context)
.showSnackBar(

const SnackBar(
content:
Text(
'Maksimum 3 gambar sahaja dibenarkan'
),

),

);

return;

}


for(var image in images){


final extension =
image.path.split('.').last.toLowerCase();


if(extension != 'jpg' &&
extension != 'jpeg' &&
extension != 'png'){

ScaffoldMessenger.of(context)
.showSnackBar(

const SnackBar(
content:
Text(
'Hanya fail JPG, JPEG dan PNG dibenarkan'
),

),

);

return;

}


if(kIsWeb){

Uint8List bytes =
await image.readAsBytes();


gambarWebList.add(bytes);


gambarBase64List.add(
base64Encode(bytes)
);


}else{


File file =
File(image.path);


gambarList.add(file);


Uint8List bytes =
await file.readAsBytes();


gambarBase64List.add(
base64Encode(bytes)
);


}

}


setState((){});


triggerDraftSave();

}
Future<void> loadDraft() async {


User? user =
FirebaseAuth.instance.currentUser;


if(user == null) return;



DocumentSnapshot draft =
await FirebaseFirestore.instance
.collection('draft_aduan')
.doc(user.uid)
.get();



if(draft.exists){


final data =
draft.data()
as Map<String,dynamic>;



setState((){

  kategori =
data['kategori'];

subKategori =
data['subKategori'];

lokasi =
data['lokasi'];

lokasiController.text =
data['keteranganLokasi'] ?? '';


  masalahController.text =
  data['masalah'] ?? '';


  gambarBase64List =
List<String>.from(data['gambarBase64'] ?? []);

});




showDialog(

context:context,

builder:(context){


return Dialog(

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(25),

),


child:

Padding(

padding:
const EdgeInsets.all(25),


child:

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
Color(0xffEAF3FF),

shape:
BoxShape.circle,

),


child:

const Icon(

Icons.edit_document,

size:45,

color:
Color(0xff003B73),

),

),



const SizedBox(height:20),



const Text(

'Draf Aduan Dijumpai',

style:

TextStyle(

fontSize:22,

fontWeight:
FontWeight.bold,

color:
Color(0xff003B73),

),

),



const SizedBox(height:10),



const Text(

'Anda mempunyai draf aduan yang belum selesai.\n\nAnda boleh meneruskan pengisian atau membuang draf ini.',

textAlign:
TextAlign.center,

style:

TextStyle(

color:
Color(0xff555555),

fontSize:15,

height:1.5,

),

),



const SizedBox(height:25),



Row(

children:[


Expanded(

child:

OutlinedButton(

style:

OutlinedButton.styleFrom(

foregroundColor:
Colors.red,

side:

const BorderSide(

color:
Colors.red,

),

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(15),

),

),


onPressed:() async {

  User? user =
  FirebaseAuth.instance.currentUser;


  if(user != null){

    await FirebaseFirestore.instance
        .collection('draft_aduan')
        .doc(user.uid)
        .delete();

  }


  setState((){

    kategori = null;

    lokasiController.clear();

    masalahController.clear();

    gambarBase64List.clear();

gambarList.clear();

gambarWebList.clear();

  });


  Navigator.pop(context);


},


child:

const Text(

'Buang',

),

),

),



const SizedBox(width:10),



Expanded(

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
BorderRadius.circular(15),

),

),


onPressed:(){

Navigator.pop(context);

},


child:

const Text(

'Sambung',

),

),

),



],

),



],

),

),

);


}





);


}


}

void triggerDraftSave(){

  draftTimer?.cancel();


  draftTimer = Timer(

    const Duration(seconds:1),

    (){

      saveDraft();

    },

  );

}
Future<void> saveDraft() async {


User? user =
FirebaseAuth.instance.currentUser;


if(user == null) return;



// Jangan simpan kalau borang kosong

if(
kategori == null &&
lokasiController.text.trim().isEmpty &&
masalahController.text.trim().isEmpty &&
gambarBase64List.isEmpty
){

  // padam draft kosong kalau ada
  await FirebaseFirestore.instance
      .collection('draft_aduan')
      .doc(user.uid)
      .delete();

  return;

}


await FirebaseFirestore.instance
.collection('draft_aduan')
.doc(user.uid)
.set({

'kategori': kategori,

'subKategori': subKategori,

'lokasi': lokasi,

'keteranganLokasi':
lokasiController.text,

'masalah':
masalahController.text,

'gambarBase64': gambarBase64List,

'updatedAt':
Timestamp.now(),

});


}

  Future<void> hantarAduan() async {


    if (namaController.text.trim().isEmpty ||
    lokasi == null ||
    masalahController.text.trim().isEmpty ||
    kategori == null ||
    subKategori == null){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            'Sila lengkapkan semua maklumat',
          ),

        ),

      );


      return;

    }

      try {

setState(() {

  sedangHantar = true;

});


      User? user =
          FirebaseAuth.instance.currentUser;

      DocumentReference aduanRef =
await FirebaseFirestore.instance
.collection('aduan')
.add({

            


        'uid': user!.uid,

        'nama': namaController.text.trim(),

        'email': user.email,

        'kategori': kategori,

'subKategori': subKategori,

'lokasi': lokasi,

'keteranganLokasi':
lokasiController.text.trim(),

'masalah': masalahController.text.trim(),

        'status': 'Baru',

        'tarikh': Timestamp.now(),

        'gambarBase64': gambarBase64List,


      });
      
      await FirebaseFirestore.instance
    .collection('draft_aduan')
    .doc(user.uid)
    .delete();


      if (!mounted) return;



     Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(context)=>

AduanBerjayaScreen(

aduanID: aduanRef.id,

kategori: kategori!,

subKategori: subKategori!,

lokasi: lokasi!,

tarikh:
DateTime.now().toString(),

),

),

);

      masalahController.clear();


      setState(() {

  kategori = null;

  subKategori = null;

  lokasi = null;

  gambarList.clear();

gambarWebList.clear();

gambarBase64List.clear();

  sedangHantar = false;

});



    } catch (e) {


      if (!mounted) return;



      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            'Ralat: $e',
          ),

          backgroundColor: Colors.red,

        ),

      );

    }

  }



@override
void dispose() {

  draftTimer?.cancel();

  namaController.dispose();
  lokasiController.dispose();
  masalahController.dispose();

  super.dispose();

}





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
const Color(0xffF5F7FA),


      appBar: AppBar(

        title: const Text(
          'Buat Aduan ICT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        backgroundColor:
const Color(0xff003B73),

      ),



      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(20),


          child: Column(

            children: [



              const SizedBox(height:10),

              Container(

width:
double.infinity,


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

const Column(

children:[


Icon(

Icons.computer,

color:
Colors.white,

size: 25,

),



SizedBox(height:10),



Text(

'Buat Aduan ICT',

style:

TextStyle(

color:
Colors.white,

fontSize:22,

fontWeight:
FontWeight.bold,

),

),



Text(

'Laporkan kerosakan dengan mudah',

style:

TextStyle(

color:
Colors.white70,

),

),



],

),

),


const SizedBox(height:25),



              TextField(

                controller: namaController,

                readOnly: true,


               decoration: InputDecoration(

filled:true,

fillColor:
Colors.white,


 labelText: loadingNama
        ? 'Memuatkan nama...'
        : 'Nama Pengadu',

prefixIcon:
    const Icon(Icons.person),


border: OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),

              ),



              const SizedBox(height:15),



              DropdownButtonFormField<String>(

value: kategori,


                decoration: InputDecoration(

                  labelText:
                  'Kategori Masalah',


                  prefixIcon:
                  const Icon(Icons.category),


                  border: OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                  ),

                ),



                items: kategoriList.map((item){

                  return DropdownMenuItem(

                    value:item,

                    child:Text(item),

                  );

                }).toList(),



              onChanged:(value){

  setState((){

    kategori=value;
    subKategori=null;

  });


  triggerDraftSave();

},

              ),

              const SizedBox(height:15),

if(kategori != null)

DropdownButtonFormField<String>(

  value: subKategori,

  decoration: InputDecoration(

    labelText:'Jenis Kerosakan',

    prefixIcon:
    const Icon(Icons.build),

    border:
    OutlineInputBorder(

      borderRadius:
      BorderRadius.circular(15),

    ),

  ),


  items:

  subKategoriList[kategori]!.map((item){

    return DropdownMenuItem(

      value:item,

      child:Text(item),

    );

  }).toList(),



  onChanged:(value){

    setState((){

      subKategori=value;

    });

    triggerDraftSave();

  },

),



              const SizedBox(height:15),



              DropdownButtonFormField<String>(

  value: lokasi,

  decoration: InputDecoration(

    labelText:'Lokasi',

    prefixIcon:
    const Icon(Icons.location_on),

    border:
    OutlineInputBorder(

      borderRadius:
      BorderRadius.circular(15),

    ),

  ),


  items:

  lokasiList.map((item){

    return DropdownMenuItem(

      value:item,

      child:Text(item),

    );

  }).toList(),


  onChanged:(value){

    setState((){

      lokasi=value;

    });

    triggerDraftSave();

  },

),




              const SizedBox(height:15),



              TextField(

                controller:
                masalahController,


                maxLines:4,


                decoration: InputDecoration(

                  labelText:
                  'Pernyataan Masalah',


                  prefixIcon:
                  const Icon(Icons.description),


                  border: OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                  ),

                ),

              ),



const SizedBox(height:20),


GestureDetector(

  onTap: pilihGambar,


  child: Container(

    width: double.infinity,

    height: 80,


    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(15),

      border: Border.all(
        color: Colors.grey,
      ),

    ),


    child: (gambarList.isEmpty && gambarWebList.isEmpty)

        ? const Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Icon(
                Icons.add_a_photo,
               size:30,
                color: Colors.grey,
              ),

              SizedBox(height:5),

              Text(
'Tambah Gambar Kerosakan\n'
'JPG, JPEG, PNG | Maksimum 3 gambar',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 11,
color: Colors.grey,
),
),

            ],

          )


        : GridView.builder(

padding: const EdgeInsets.all(5),

gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount:3,
crossAxisSpacing:5,
mainAxisSpacing:5,
),

itemCount:
gambarList.length + gambarWebList.length,


itemBuilder:(context,index){

if(kIsWeb){

return Image.memory(
gambarWebList[index],
fit:BoxFit.cover,
);

}

return Image.file(
gambarList[index],
fit:BoxFit.cover,
);

},

),


  ),

),
              const SizedBox(height:25),



              SizedBox(

                width:double.infinity,

                height:55,


                child:ElevatedButton(

                  onPressed:
sedangHantar ? null : hantarAduan,


                  style:ElevatedButton.styleFrom(

                    backgroundColor:
                    Color(0xff003B73),


                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(15),

                    ),

                  ),



                  child:

  sedangHantar

  ?

  const CircularProgressIndicator(

    color: Colors.white,

  )

  :

  const Text(

    'Hantar Aduan',

    style:TextStyle(

      color:Colors.white,

      fontSize:18,

      fontWeight:
      FontWeight.bold,

    ),

  ),

),

              ),


            ],

          ),

        ),

      ),

    );

  }

}