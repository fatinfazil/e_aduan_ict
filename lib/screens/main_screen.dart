import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'aduan_saya_screen.dart';
import 'status_aduan_screen.dart';
import 'profile_screen.dart';


class MainScreen extends StatefulWidget {

  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();

}



class _MainScreenState extends State<MainScreen>{


int currentIndex = 0;



final List<Widget> pages = const [

  HomeScreen(),

  AduanSayaScreen(),

  StatusAduanScreen(),

  ProfileScreen(),

];



@override
Widget build(BuildContext context){


return Scaffold(

body: pages[currentIndex],



bottomNavigationBar: BottomNavigationBar(

backgroundColor: Colors.white,

selectedItemColor:
const Color(0xff003B73),

unselectedItemColor:
Colors.grey,

type: BottomNavigationBarType.fixed,


currentIndex: currentIndex,


onTap: (index){

setState(() {

currentIndex = index;

});

},



items: const [


BottomNavigationBarItem(

icon: Icon(Icons.home),

label: 'Utama',

),



BottomNavigationBarItem(

icon: Icon(Icons.assignment),

label: 'Aduan',

),



BottomNavigationBarItem(

icon: Icon(Icons.track_changes),

label: 'Status',

),

BottomNavigationBarItem(

icon: Icon(Icons.person),

label: 'Profil',

),


],


),


);


}


}