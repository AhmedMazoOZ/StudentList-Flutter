import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:studentdatabase/utilities/sql_helper.dart';
import 'package:studentdatabase/models/student.dart';
import 'package:sqflite/sql.dart';
import 'package:studentdatabase/Screns/student_list.dart';

class studentdetails extends StatefulWidget {
  Student student ;

  studentdetails(this.student);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // ignore: no_logic_in_create_state
    return Students(this.student);
  }
}

class Students extends State<studentdetails> {
  static var _state = ["successed", "failed"];
  Student student;
  SQL_Helper sql_helper = new SQL_Helper();
  String? newValue;

  Students(this.student);

  TextEditingController studentname = new TextEditingController();
  TextEditingController studentdetails = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

   TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    studentname.text = student.name!;
    studentdetails.text = student.description!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Result'),
              trailing: new DropdownButton<String>(
                  hint: Text('Choose'),
                  style: textStyle,
                  onChanged: (String? changedValue) {
                    newValue = changedValue;
                    setState(() {
                      newValue;
                      setPassingdata(newValue);
                      print("RRRRRRRRRe"+newValue!);
                    });
                  },
                  value: newValue,
                  items: <String>["successed", "failed"]
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList()),

            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: studentname,
                style: textStyle,
                onChanged: (value) {
                  student.name = value;
                },
                decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: studentdetails,
                style: textStyle,
                onChanged: (value) {
                  student.description = value;
                },
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'SAVE',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("User click save");
                        Save();
                      });
                    },
                  )),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                      child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      'Delete',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("User click Delete");
                        _delete();
                      });
                    },
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void setPassingdata(String ?Value) {
    switch (Value) {
      case "successed":
        student.pass = 1;
        print("ewrwerwerwr"+Value!+" "+student.pass.toString());
        break;
      case "failed":
        student.pass = 0;
        print("ewrwerwerwr"+Value!+" "+student.pass.toString());
        break;
    }
  }

  String getPassingdata(int Value) {
    String pass = "";
    switch (Value) {
      case 1:
        pass = _state[0];
        break;
      case 2:
        pass = _state[1];
        break;
    }
    return pass;
  }

  void Save() async {
    int? result;
    goback();
    student.date = DateFormat.yMMMd().format(DateTime.now());
    if (student.id == null) {
      result = await sql_helper.InsertStudent(student);
      debugPrint("Done + 1");
      showAlertDialog("Congratulations", "Student has been saved successfully");
    } else {
      result = await sql_helper.UpdateStudent(student);
      debugPrint("Done + 2");
      showAlertDialog(
          "Congratulations", "Student has been updated successfully");
    }
    /*
    if (result == 0) {
      showAlertDialog("Sorry", "Student not saved");
    } else {
      showAlertDialog("Congratulations", "Student has been saved successfully");
    }
     */
  }

  void _delete() async {
    goback();
    int? result;
    if (student.id == null) {
      showAlertDialog("Ok Delete", "Student has been deleted successfully");
      return;
    }

    result = await sql_helper.DeleteStudent(student.id);
    if (result == 0) {
      showAlertDialog("Sorry", "Student not deleted ");
    } else {
      showAlertDialog("Ok Delete", "Student has been deleted successfully");
    }
  }

  void goback() {
    Navigator.pop(context, true);
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = new AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
