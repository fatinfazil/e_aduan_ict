import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';


class EditAduanScreen extends StatefulWidget {

  final String docId;
  final Map<String,dynamic> data;


  const EditAduanScreen({
    super.key,
    required this.docId,
    required this.data,
  });


  @override
  State<EditAduanScreen> createState() =>
      _EditAduanScreenState();

}



class _EditAduanScreenState extends State<EditAduanScreen>{


late TextEditingController lokasiController;
late TextEditingController masalahController;


String? kategori;

String? gambarBase64;

Uint8List? gambarBaru;



final kategoriList=[

'Komputer',
'Printer',
'Internet',
'Perisian / Software',
'Lain-lain',

];



@override
void initState(){

super.initState();


lokasiController =
TextEditingController(
text: widget.data['lokasi'] ?? ''
);


masalahController =
TextEditingController(
text: widget.data['masalah'] ?? ''
);


kategori =
widget.data['kategori'];

gambarBase64 =
widget.data['gambarBase64'];

}

@override
void dispose(){

  lokasiController.dispose();

  masalahController.dispose();

  super.dispose();

}

Future<void> pilihGambar() async {

final ImagePicker picker = ImagePicker();


final XFile? image =
await picker.pickImage(
source: ImageSource.gallery,
imageQuality:50,
);


if(image != null){

gambarBaru =
await image.readAsBytes();


setState((){

gambarBase64 =
base64Encode(gambarBaru!);

});

}


}

Future<void> updateAduan() async {


await FirebaseFirestore.instance

.collection('aduan')

.doc(widget.docId)

.update({

'kategori': kategori,

'lokasi':
lokasiController.text,

'masalah':
masalahController.text,

'gambarBase64':
gambarBase64 ?? '',

});



if(mounted){


showDialog(

context:context,

builder:(context){

return AlertDialog(

shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(20),

),


title:

const Text(
'Aduan Dikemaskini'
),


content:

const Text(
'Maklumat aduan berjaya dikemaskini.'
),


actions:[


TextButton(

onPressed:(){

// tutup popup
Navigator.pop(context);


// keluar dari Edit Screen
Navigator.pop(context, true);


},

child:

const Text(
'OK'
),

)

],
);

},

);


}


}


@override
Widget build(BuildContext context){

return Scaffold(

backgroundColor:
const Color(0xffF5F7FA),


appBar: AppBar(

title:
const Text(
'Edit Aduan',
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

SingleChildScrollView(

child:

Padding(

padding:
const EdgeInsets.all(20),


child:

Column(

children:[



// HEADER

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


boxShadow:[

BoxShadow(

color:
Colors.black.withValues(alpha:0.15),

blurRadius:10,

offset:
const Offset(0,5),

),

],

),



child:

const Column(

children:[


Icon(

Icons.edit_document,

color:
Colors.white,

size:45,

),


SizedBox(height:10),



Text(

'Kemaskini Aduan ICT',

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

'Ubah maklumat aduan anda',

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





// FORM CARD

Container(

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
Colors.black.withValues(alpha:0.08),

blurRadius:10,

offset:
const Offset(0,5),

)

],

),



child:

Column(

children:[



DropdownButtonFormField<String>(

value:kategori,


items:

kategoriList.map((e){

return DropdownMenuItem(

value:e,

child:
Text(e),

);

}).toList(),



onChanged:(value){

setState((){

kategori=value;

});

},



decoration:

InputDecoration(

labelText:
'Kategori Masalah',


prefixIcon:

const Icon(
Icons.category,
),


border:

OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),

),




const SizedBox(height:18),




TextField(

controller:
lokasiController,


decoration:

InputDecoration(

labelText:
'Lokasi',


prefixIcon:

const Icon(
Icons.location_on,
),



border:

OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),

),




const SizedBox(height:18),





TextField(

controller:
masalahController,


maxLines:5,


decoration:

InputDecoration(

labelText:
'Penerangan Masalah',


prefixIcon:

const Icon(
Icons.description,
),



border:

OutlineInputBorder(

borderRadius:
BorderRadius.circular(15),

),

),

),
const SizedBox(height:18),


Align(

alignment: Alignment.centerLeft,

child:

Text(

'Gambar Aduan',

style:

TextStyle(

fontSize:16,

fontWeight:
FontWeight.bold,

color:
Color(0xff003B73),

),

),

),


const SizedBox(height:10),

GestureDetector(

onTap: pilihGambar,


child:

Container(

height:180,

width:double.infinity,


decoration:

BoxDecoration(

color:
const Color(0xffF8FAFC),


borderRadius:
BorderRadius.circular(18),


border:

Border.all(

color:
const Color(0xffD0D7DE),

width:1,

),


boxShadow:[

BoxShadow(

color:
Colors.black.withValues(alpha:0.05),

blurRadius:8,

offset:
const Offset(0,4),

)

],

),



child:

gambarBase64 != null &&
gambarBase64!.isNotEmpty


?

ClipRRect(

borderRadius:
BorderRadius.circular(15),


child:

Image.memory(

base64Decode(
gambarBase64!
),

fit:
BoxFit.cover,

),

)



:

Column(

mainAxisAlignment:
MainAxisAlignment.center,


children:[


const Icon(

Icons.add_a_photo,

size:45,

color:Colors.grey,

),


const SizedBox(height:10),


const Text(
'Tukar gambar',
),

],

),


),

),

const SizedBox(height:35),





SizedBox(

width:
double.infinity,


height:
55,


child:

ElevatedButton(


onPressed:updateAduan,


style:

ElevatedButton.styleFrom(

backgroundColor:
const Color(0xff003B73),


shape:

RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(15),

),

),



child:

const Text(

'SIMPAN PERUBAHAN',

style:

TextStyle(

color:
Colors.white,

fontSize:17,

fontWeight:
FontWeight.bold,

),

),


),


),




],

),


),



],

),

),

),


);


}

}