import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'aduan_screen.dart';
import 'aduan_saya_screen.dart';
import 'profile_screen.dart';


class MainNavigation extends StatefulWidget {

  const MainNavigation({super.key});


  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();

}



class _MainNavigationState extends State<MainNavigation> {


  int currentIndex = 0;



  final List<Widget> pages = [

    const HomeScreen(),

    const AduanScreen(),

    const AduanSayaScreen(),

    const ProfileScreen(),

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: pages[currentIndex],



      bottomNavigationBar: NavigationBar(

  selectedIndex: currentIndex,


  backgroundColor: Colors.white,


  elevation: 5,


  indicatorColor:
      Colors.blue.shade100,


  onDestinationSelected: (index){

    setState((){

      currentIndex = index;

    });

  },


  destinations: const [


    NavigationDestination(

      icon: Icon(
        Icons.home_outlined,
      ),

      selectedIcon: Icon(
        Icons.home,
      ),

      label: 'Home',

    ),



    NavigationDestination(

      icon: Icon(
        Icons.add_circle_outline,
      ),

      selectedIcon: Icon(
        Icons.add_circle,
      ),

      label: 'Aduan',

    ),



    NavigationDestination(

      icon: Icon(
        Icons.assignment_outlined,
      ),

      selectedIcon: Icon(
        Icons.assignment,
      ),

      label: 'Aduan Saya',

    ),



    NavigationDestination(

      icon: Icon(
        Icons.person_outline,
      ),

      selectedIcon: Icon(
        Icons.person,
      ),

      label: 'Profil',

    ),


  ],

),


    );

  }

}