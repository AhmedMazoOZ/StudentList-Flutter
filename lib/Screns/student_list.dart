import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentdatabase/Screns/student_details.dart';
import 'dart:async';
import 'package:studentdatabase/utilities/sql_helper.dart';
import 'package:studentdatabase/models/student.dart';
import 'package:sqflite/sql.dart';

class StudentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StudentState();
  }
}

class StudentState extends State<StudentList> {
  SQL_Helper sql_helper = new SQL_Helper();
  List<Student>? studentlist;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (studentlist == null) {
      studentlist = <Student>[];
      updatelistview();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("StudentList"),
      ),
      body: getStudentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Onpressedclick(Student(" ", " ", 0, " "));
        },
        tooltip: "Add Student",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getStudentList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.1,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isPassed(studentlist![position].pass),
                child: getIcon(studentlist![position].pass),
              ),
              title: Text(studentlist![position].name!),
              subtitle: Text(studentlist![position].description! +
                  "|" +
                  studentlist![position].date!),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  delete(context, this.studentlist![position]);
                  updatelistview();
                },
              ),
              onTap: () {
                Onpressedclick(this.studentlist![position]);
              },
            ),
          );
        });
  }

  Color isPassed(int? value) {
    switch (value) {
      case 1:
        return Colors.amber;
        break;
      case 0:
        return Colors.red;
        break;
      default:
        return Colors.amber;
    }
  }

  Icon getIcon(int? value) {
    switch (value) {
      case 1:
        return Icon(Icons.check);
        break;
      case 0:
        return Icon(Icons.close);
        break;
      default:
        return Icon(Icons.check);
    }
  }

  void delete(BuildContext buildContext, Student? student) async {
    int? result = await sql_helper.DeleteStudent(student!.id);
    if (result != 0) {
      showsenckbar(buildContext, "Student deleted");
    }
  }

  void showsenckbar(BuildContext buildContext, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    Scaffold.of(buildContext).showSnackBar(snackBar);
  }

  void Onpressedclick(Student student) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return studentdetails(student);
    }));

    if (result) {
      updatelistview();
    }
  }

  void updatelistview() {
    final Future<Database> db = sql_helper.initializedDatabase();
    db.then((value) => db);
    Future<List<Student>> students = sql_helper.getstudentlist();
    students.then((thelist) {
      setState(() {
        this.studentlist = thelist;
        this.count = thelist.length;
      });
    });
  }
}
