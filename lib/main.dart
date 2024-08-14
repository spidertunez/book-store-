
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Book.dart';

void main (){
  runApp(MyApp()) ;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false,
        home: Book(),
        initialRoute: '/book',
        routes: {
          '/book':(context) => Book(),
        }
    );
  }
}
