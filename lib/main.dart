import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentdatabase/Screns/student_list.dart';
import 'package:studentdatabase/Screns/student_details.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
  // print("Start project");
  // getfilecontent();
  // print("End of project");
}

getfilecontent() async{
  String filecontent=await downloadfile();
print(filecontent);
}

Future<String> downloadfile(){
  Future<String> future=Future.delayed(Duration(seconds: 6),(){
    return "Internet File downloaded";
  });

  return future;

}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Students List",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan
      ),
      home: StudentList(),
    );
  }
  
}


