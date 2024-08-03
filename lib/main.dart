import 'package:flutter/material.dart';
import 'climate.dart';
// import 'ui/climate.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
     home:  Scaffold(
       appBar: AppBar(
           centerTitle: true,
           title: Text(
        'Weather App',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 6.0,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
           ),
           flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff20002c), Color(0xffcbb4d4), Color(0xff20002c)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
           ),
           actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          color: Colors.white,
          iconSize: 25,
        )
           ],
         ),
       body: Climate(),
       backgroundColor: Color(0xff20002c),
     ),
  ));
}
