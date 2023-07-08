import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';

class DataTableDemo extends StatefulWidget {
  final String uid;
  final String name;
  final int rollno;
  DataTableDemo({required this.uid,required this.name,required  this.rollno});
  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  DataTableDemoState();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('IITB Hospital'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('DoctorsInfo').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: snapshot.data!.docs.map((document) {
                String id=document.id;
                var name = document['name'];
                var specialization = document['specialization'];
                return Row(
                  children:[
                    Column(
                    children:[Padding(padding: EdgeInsets.all(10),
                    child: Text(name+'('+specialization+')'))]),
                    Spacer(),
                    Column(
                        children:[ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        shape: StadiumBorder(),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,

                          MaterialPageRoute(

                              builder: (context) => Appointment(
                                docdata(id,name,document['mon'],document['tue'],document['wed'],document['thu'],document['fri'],document['sat'],document['sun'],document['monslots'].length,document['tueslots'].length,document['wedslots'].length,document['thuslots'].length,document['frislots'].length,document['satslots'].length,document['sunslots'].length),widget.uid,widget.name,widget.rollno
                              )),
                        );
                      },
                      child: Text('Book Appointment'),
                    )
                    ])
                  ]);
              }).toList(),
            );
          }),
    );
  }
}

class docdata{
  docdata(this.id,this.name,this.mon,this.tue,this.wed,this.thu,this.fri,this.sat,this.sun,this.monslots,this.tueslots,this.wedslots,this.thuslots,this.frislots,this.satslots,this.sunslots);
  final String id;
  final String name;
  final String mon;
  final String tue;
  final String wed;
  final String thu;
  final String fri;
  final String sat;
  final String sun;
  final int monslots;
  final int tueslots;
  final int wedslots;
  final int thuslots;
  final int frislots;
  final int satslots;
  final int sunslots;
}

class Appointment extends StatefulWidget {
  docdata data;
  String uid;
  String name;
  int rollno;
  Appointment(this.data,this.uid,this.name,this.rollno);
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('IITB Hospital'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //DropdownButtonApp(),
          PaginatedDataTable(
            showCheckboxColumn: false,
            header: Text('Schedule'),
            rowsPerPage: 7,
            columns: [
              DataColumn(label: Text('Day')),
              DataColumn(label: Text('Timings')),
              DataColumn(label: Text(''))
            ],
            source: _DataSource(context, <_Row>[
              _Row(
                  'Monday',
                  widget.data.mon,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      print(widget.data.mon);
                      List<String> Time = widget.data.mon.split("-");
                      List<String> FromTime = Time[0].split(":");
                      List<String> ToTime = Time[1].split(":");
                      int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
                      print(TimeInMins);
                      if(widget.data.monslots<TimeInMins) {
                        await DatabaseService(uid: widget.data.id)
                            .updateUserData2(widget.name, widget.rollno,widget.uid, 'monslots');
                        await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'monday', widget.data.mon);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Successful"),
                                content: Text("Appointment Booked"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text("Slots are full"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      },
                    child: Text('Book'),
                  )
              ),
              _Row(
                'Tuesday',
                widget.data.tue,
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      print(widget.data.tue);
                      List<String> Time = widget.data.tue.split("-");
                      List<String> FromTime = Time[0].split(":");
                      List<String> ToTime = Time[1].split(":");
                      int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
                      print(TimeInMins);
                      if(widget.data.tueslots<TimeInMins) {
                        await DatabaseService(uid: widget.data.id)
                            .updateUserData2(widget.name, widget.rollno,widget.uid, 'tueslots');
                        await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'tuesday', widget.data.tue);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Successful"),
                                content: Text("Appointment Booked"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text("Slots are full"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text('Book'),
                  )
              ),
              _Row(
                'Wednesday',
                widget.data.wed,
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      print(widget.data.wed);
                      List<String> Time = widget.data.wed.split("-");
                      List<String> FromTime = Time[0].split(":");
                      List<String> ToTime = Time[1].split(":");
                      int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
                      print(TimeInMins);
                      if(widget.data.wedslots<TimeInMins) {
                        await DatabaseService(uid: widget.data.id)
                            .updateUserData2(widget.name, widget.rollno,widget.uid, 'wedslots');
                        await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'wednesday', widget.data.wed);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Successful"),
                                content: Text("Appointment Booked"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text("Slots are full"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text('Book'),
                  )
              ),
              _Row(
                'Thursday',
                widget.data.thu,
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      print(widget.data.thu);
                      List<String> Time = widget.data.thu.split("-");
                      List<String> FromTime = Time[0].split(":");
                      List<String> ToTime = Time[1].split(":");
                      int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
                      print(TimeInMins);
                      if(widget.data.thuslots<TimeInMins) {
                        await DatabaseService(uid: widget.data.id)
                            .updateUserData2(widget.name, widget.rollno,widget.uid, 'thuslots');
                        await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'thursday', widget.data.thu);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Successful"),
                                content: Text("Appointment Booked"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text("Slots are full"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text('Book'),
                  )
              ),
              _Row(
                'Friday',
                widget.data.fri,
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      print(widget.data.fri);
                      List<String> Time = widget.data.fri.split("-");
                      List<String> FromTime = Time[0].split(":");
                      List<String> ToTime = Time[1].split(":");
                      int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
                      print(TimeInMins);
                      if(widget.data.frislots<TimeInMins) {
                        await DatabaseService(uid: widget.data.id)
                            .updateUserData2(widget.name, widget.rollno,widget.uid, 'frislots');
                        await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'friday', widget.data.fri);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Successful"),
                                content: Text("Appointment Booked"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text("Slots are full"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text('Book'),
                  )
              ),
              _Row(
                'Saturday',
                widget.data.sat,
                  ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () async {
                      print(widget.data.sat);
                      List<String> Time = widget.data.sat.split("-");
                      List<String> FromTime = Time[0].split(":");
                      List<String> ToTime = Time[1].split(":");
                      int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
                      print(TimeInMins);
                      if(widget.data.satslots<TimeInMins) {
                        await DatabaseService(uid: widget.data.id)
                            .updateUserData2(widget.name, widget.rollno,widget.uid, 'satslots');
                        await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'saturday', widget.data.sat);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Successful"),
                                content: Text("Appointment Booked"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: Text("Slots are full"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      shape: StadiumBorder(),
                                    ),
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text('Book'),
                  )
              ),
              _Row(
                'Sunday',
                widget.data.sun,
                  ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black87,
    shape: StadiumBorder(),
    ),
    onPressed: () async {
    print(widget.data.sun);
    List<String> Time = widget.data.sun.split("-");
    List<String> FromTime = Time[0].split(":");
    List<String> ToTime = Time[1].split(":");
    int TimeInMins = ((int.parse(ToTime[0])-int.parse(FromTime[0]))*60 + (int.parse(ToTime[1])-int.parse(FromTime[1])))~/10;
    print(TimeInMins);
    if(widget.data.sunslots<TimeInMins) {
    await DatabaseService(uid: widget.data.id)
        .updateUserData2(widget.name, widget.rollno,widget.uid, 'sunslots');
    await Patient(widget.uid).addpatientCollection(widget.data.id,widget.data.name, 'sunday', widget.data.sun);
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: const Text("Successful"),
    content: Text("Appointment Booked"),
    actions: [
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black87,
    shape: StadiumBorder(),
    ),
    child: const Text("Ok"),
    onPressed: () {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    },
    )
    ],
    );
    });
    }
    else{
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: const Text("Error"),
    content: Text("Slots are full"),
    actions: [
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black87,
    shape: StadiumBorder(),
    ),
    child: const Text("Ok"),
    onPressed: () {
    Navigator.of(context).pop();
    },
    )
    ],
    );
    });
    }
    },
    child: Text('Book'),
    )
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class _Row {
  _Row(
      this.day,
      this.timings,
      this.appointments
      );

  final String day;
  final String timings;
  final ElevatedButton appointments;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this._rows);

  final BuildContext context;
  List<_Row> _rows;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(row.day)),
        DataCell(Text(row.timings)),
        DataCell(row.appointments)
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}