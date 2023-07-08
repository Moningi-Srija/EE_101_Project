import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eeapp/pharmacy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database.dart';

class MedicalRecords extends StatefulWidget {
  String uid;

  MedicalRecords(this.uid);
  @override
  _MedicalRecordsState createState() => _MedicalRecordsState();
}
class _MedicalRecordsState extends State<MedicalRecords> {
  dynamic appointments;
  dynamic rollno;
  dynamic name;
  Future<dynamic> getData() async {

    final DocumentReference document =   FirebaseFirestore.instance.collection("PatientsInfo").doc(widget.uid);
    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        appointments=snapshot.get('Appointments');
        name=snapshot.get('name');
        rollno=snapshot.get('rollno');
        print(appointments);
      });
    });
  }

  @override
  void initState() {

    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Your Appointments'),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: IconButton(
              icon:const Icon(Icons.arrow_back),
              onPressed:() => Navigator.of(context).pop()
          ),
        ),
        body: ListView(
            children:<Card>[
              for(var appointment in appointments)
                if(appointment['visited'] == true)
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person_outlined),
                          title: Text(appointment['doctor']),
                          subtitle: Text(appointment['day']+" "+appointment['timeslot']),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Check Details'),
                              onPressed: () async {
                                var details="";
                                if(appointment['details']!=null){
                                  details=appointment['details'];
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisitDetails(appointment['doctor'],appointment['day'],appointment['timeslot'],details)), //appointment['report'])),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )]));
}}
class VisitDetails extends StatelessWidget{
  final String doctor;
  final String date;
  final String timeslot;
  final String details;
  // final String report;
  VisitDetails(this.doctor,this.date,this.timeslot,this.details);//,this.report);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Visit Details'),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed:() => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Doctor',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      doctor,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      date,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Timings',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      timeslot,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Details',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      details,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}