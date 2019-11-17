import 'package:flutter/material.dart';
import 'screens/homepage.dart';

void main() => runApp(AttendanceApp());




class AttendanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans', decoration: TextDecoration.none,)
      ),
      home: HomePage(),
    );
  }
}