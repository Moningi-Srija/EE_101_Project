import 'dart:collection';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'database.dart';

import 'database.dart';

class DSignInPage extends StatefulWidget {
  const DSignInPage({super.key});
  static final String _title = 'IITB Hospital'.tr;

  @override
  State<DSignInPage> createState() => _DSignInPageState();
}

class _DSignInPageState extends State<DSignInPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('IITB Hospital'.tr),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed:() => Navigator.of(context).pushReplacementNamed('/home'),
          ),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      'IITB Hospital'.tr,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )
                    ,),
                  Padding(
                    // alignment: Alignment.center,
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        'Doctor SignIn'.tr,
                        style: const TextStyle(fontSize: 20),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Email Address",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email Address';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email address!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        } else if (value.length < 6) {
                          return 'Password must be atleast 6 characters!';
                        }
                        return null;
                      },
                    ),
                   ),
                  // TextButton(
                  //   onPressed: () {
                  //     //forgot password screen
                  //   },
                  //   child: const Text(
                  //     'Forgot Password',
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<
                              Color>(Colors.black87)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          logInToFb();
                        }
                      },
                      child: Text('SignIn'.tr),
                    ),
                  ),
                ])
            )
        ));
  }

  void logInToFb() async{
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((result) async {
      isLoading = false;
      final ref = FirebaseDatabase.instance.reference();
      final snapshot = await ref.child('Users/${result.user!.uid}').get();
      if (snapshot.exists) {
        if (snapshot.value['role'] == 'doctor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorsHome(uid: snapshot.value['doctordoc'])),
          );
        }
        else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("No such doctor exists"),
                  actions: [
                    ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DSignInPage()),
                        );
                      },
                    )
                  ],
                );
              });
        }
      }
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/dsignin');
                  },
                )
              ],
            );
          });
    });
  }
}

class DoctorsHome extends StatelessWidget {
  // This widget is the root of your application.
  DoctorsHome({this.uid});
  final String? uid;
  @override
  //Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Doctor'.tr),
  //       centerTitle: true,
  //       backgroundColor: Colors.black87,
  //     ),
  //     body: Container(
  //       decoration: const BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage('assets/img4.jpeg'),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       child: const Center(
  //           child: Text('Home Screen')
  //       ),
  //     ),
  //     drawer: DoctorDrawer(uid!),
  //   );
  // }
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('IITB Hospital Doctor\'s Interface'.tr),
          centerTitle: true,
          backgroundColor: Colors.black87,
            leading: IconButton(
              icon:const Icon(Icons.logout),
                onPressed: () {
                  try{
                    FirebaseAuth.instance.signOut();
                  }catch(error){
                    print(error.toString());
                  }
                  Navigator.of(context).pushReplacementNamed('/home');
                }
            ),

        ),
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/img3.jpeg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Center(
        child: Table(
          children: [
            TableRow(
                children: [
                  SizedBox.fromSize(
                    size: Size(150,150), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // splash color
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DoctorsAvailability(uid!),
                            ));
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.group,size: 80.0,), // icon
                              Text("Update",style: TextStyle(fontSize: 22)), // text
                              Text("Availability",style: TextStyle(fontSize: 22)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 150,width: 10,),
                  SizedBox.fromSize(
                    size: Size(150,150), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // splash color
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DoctorsAppointment(uid!),
                            ));
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.approval,size: 80.0,), // icon
                              Text("View",style: TextStyle(fontSize: 22)), // text
                              Text("Appointments",style: TextStyle(fontSize: 22)), // text

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ]
            ),
            TableRow(
                children: [

                  SizedBox(height: 15,width: 150,),
                  //SizedBox(height: 25,width: 10,),
                  SizedBox(height: 15,width: 150,),

                ]
            ),
            TableRow(
                children: [

                  SizedBox.fromSize(
                    size: Size(150,150), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.menu_book,size: 80.0,), // icon
                              Text("Reports",style: TextStyle(fontSize: 25)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 150,width: 10,),
                  SizedBox.fromSize(
                    size: Size(150,150), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // splash color
                          onTap: () {}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.app_registration,size: 80.0,), // icon
                              Text("Reimburse",style: TextStyle(fontSize: 25)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
            TableRow(
                children: [

                  SizedBox(height: 15,width: 150,),
                  //SizedBox(height: 25,width: 10,),
                  SizedBox(height: 15,width: 150,),

                ]
            ),
            TableRow(
                children: [

                  SizedBox.fromSize(
                    size: Size(150,150), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // splash color
                          onTap: () {

                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.local_pharmacy,size: 80.0,), // icon
                              Text("Lab Order",style: TextStyle(fontSize: 25)), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: 150,width: 10,),
                  SizedBox.fromSize(
                    size: Size(150,150), // button width and height
                    child: ClipRect(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // splash color
                          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentInfo()));}, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.money,size: 80.0,), // icon
                              Text("Student",style: TextStyle(fontSize: 25)),
                              Text("Information",style: TextStyle(fontSize: 25))// text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ]
            ),
          ],
        ),
      )));
    }
}

class DoctorDrawer extends StatelessWidget {
  final String uid;
  DoctorDrawer(this.uid);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          children: <Widget>[
            Container(
              // padding: padding,
              child: Column(
                children: [
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Doctors Availability'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DoctorsAvailability(uid),
                      ));
                    },
                  ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.approval),
                    title: Text('Doctors Appointment'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DoctorsAppointment(uid),
                      ));
                    },
                  ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.app_registration),
                    title: Text('Reports'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {

                    },
                  ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.money),
                    title: Text('Reimburse'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {

                    },
                  ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text('Lab Order'.tr),
                    onTap: () {

                    },
                  ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Student Information'.tr),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign out'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DoctorsAvailability extends StatefulWidget{
  final String uid;
  DoctorsAvailability(this.uid);
  @override
  _DoctorsAvailabilityState createState() => _DoctorsAvailabilityState();
}

class _DoctorsAvailabilityState extends State<DoctorsAvailability> {
  TextEditingController timeinput = TextEditingController();
  @override
  void initState() {
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: true,
      title: Text('IITB Hospital'.tr),
  centerTitle: true,
  backgroundColor: Colors.black87,
  leading: IconButton(
  icon:const Icon(Icons.arrow_back),
  onPressed:() => Navigator.of(context).pop()
  ),
  ),
      body:DataTableDemos(widget.uid),);
  }
}

class TimeField extends StatefulWidget {
  String day;
  final String uid;
  TimeField(this.day,this.uid);
  _TimeFieldState createState() => _TimeFieldState();
}
class _TimeFieldState extends State<TimeField>{
  TextEditingController fromtimeinput = TextEditingController();
  TextEditingController totimeinput = TextEditingController();

  @override
  void initState() {
    fromtimeinput.text = ""; //set the initial value of text field
    totimeinput.text="";
    super.initState();
  }
  @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        SizedBox(
            width:40,
            child:Text(widget.day,style: TextStyle(fontSize: 18),)),
        Spacer(),
        SizedBox(
        width:90,
        child:TextField(
        controller: fromtimeinput, //editing controller of this TextField
        decoration: InputDecoration(
            icon: Icon(Icons.timer), //icon of text field
            labelText: "" //label text of field
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
          );

          if (pickedTime != null) {
            //print(pickedTime.format(context)); //output 10:51 PM
            //DateTime parsedTime = DateFormat.jm().parse(
              //  pickedTime.format(context).toString());
//converting to DateTime so that we can further format on different pattern.
            //print(parsedTime); //output 1970-01-01 22:53:00.000
            //String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
            //print(formattedTime); //output 14:59:00
//DateFormat() is from intl package, you can format the time on any pattern you need.

            setState(() {
              fromtimeinput.text = pickedTime.format(context);//formattedTime.substring(0,5); //set the value of text field.
            });
          } else {
            print("Time is not selected");
          }
        })),
          SizedBox(
    width:90,
       child:   TextField(
              controller:totimeinput, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "" //label text of field
              ),
              readOnly: true, //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                if (pickedTime != null) {
                  setState(() {
                    totimeinput.text = pickedTime.format(context);//formattedTime.substring(0,5); //set the value of text field.
                  });
                } else {
                  print("Time is not selected");
                }
              })),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              shape: StadiumBorder(),
            ),
            onPressed: () async {
              await DatabaseService(uid:widget.uid).updateUserData('${fromtimeinput.text}-${totimeinput.text}',widget.day);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(""),
                      content: Text("Schedule Updated"),
                      actions: [
                        TextButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
            child: Text('Update'),
          )

          ]);
    }
  }


class DataTableDemos extends StatelessWidget {
  final String uid;
  DataTableDemos(this.uid);
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView(
        padding: const EdgeInsets.all(40),
        children: [
          //DropdownButtonApp(),

          TimeField('mon',uid),
          TimeField('tue',uid),
          TimeField('wed',uid),
          TimeField('thu',uid),
          TimeField('fri',uid),
          TimeField('sat',uid),
          TimeField('sun',uid),
    //
    //       PaginatedDataTable(
    //         columnSpacing: 25,
    //         showCheckboxColumn: false,
    //         header: Text('Update Availability'),
    //         rowsPerPage: 7,
    //         columns: [
    //           DataColumn(label:Text('Day')),
    //           DataColumn(label: Text('From')),
    //           DataColumn(label: Text('To')),
    //           DataColumn(label: Text('Update'))
    //         ],
    //         source: _DataSource(context, <_Row>[
    //           _Row(
    //               'Mon',
    //               TimeField(),
    //               TimeField(),
    //       ElevatedButton(
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: Colors.black87,
    //           shape: StadiumBorder(),
    //         ),
    //         onPressed: () async {
    //           await DatabaseService(uid: 'doc0').updateUserData('1-10::10','mon');
    //           },
    //         child: Text('Update'),
    //       )),
    //           _Row(
    //               'Tue',
    //               TimeField(),
    //               TimeField(),
    //               ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    // backgroundColor: Colors.black87,
    // shape: StadiumBorder(),
    // ),
    // onPressed: () {},
    // child: Text('Update'),
    // )
    //           ),
    //           _Row(
    //               'Wed',
    //               TimeField(),
    //               TimeField(),
    // ElevatedButton(
    // style: ElevatedButton.styleFrom(
    // backgroundColor: Colors.black87,
    // shape: StadiumBorder(),
    // ),
    // onPressed: () {},
    // child: Text('Update'),
    // )
    //           ),
    //           _Row(
    //               'Thu',
    //               TimeField(),
    //               TimeField(),
    // ElevatedButton(
    // style: ElevatedButton.styleFrom(
    // backgroundColor: Colors.black87,
    // shape: StadiumBorder(),
    // ),
    // onPressed: () {},
    // child: Text('Update'),
    // )
    //           ),
    //           _Row(
    //               'Fri',
    //               TimeField(),
    //               TimeField(),
    // ElevatedButton(
    // style: ElevatedButton.styleFrom(
    // backgroundColor: Colors.black87,
    // shape: StadiumBorder(),
    // ),
    // onPressed: () {},
    // child: Text('Update'),
    // )
    //           ),
    //           _Row(
    //               'Sat',
    //               TimeField(),
    //               TimeField(),
    // ElevatedButton(
    // style: ElevatedButton.styleFrom(
    // backgroundColor: Colors.black87,
    // shape: StadiumBorder(),
    // ),
    // onPressed: () {},
    // child: Text('Update'),
    // )
    //             ),
    //           _Row(
    //               'Sun',
    //               TimeField(),
    //               TimeField(),
    // ElevatedButton(
    // style: ElevatedButton.styleFrom(
    // backgroundColor: Colors.black87,
    // shape: StadiumBorder(),
    // ),
    // onPressed: () {},
    // child: Text('Update'),
    // )
    // ),
    //         ]),
    //       ),
        ],
      ),
      );
  }
}
//
// class _Row {
//   _Row(
//       this.name,
//       this.from,
//       this.to,
//       this.update,
//       );
//
//   final String name;
//   final TimeField from;
//   final TimeField to;
//   final ElevatedButton update;
//
//   //
//   // bool selected = false;
// }

// class _DataSource extends DataTableSource {
//   _DataSource(this.context, this._rows);
//
//   final BuildContext context;
//   List<_Row> _rows;
//
//   @override
//   DataRow getRow(int index) {
//     assert(index >= 0);
//     final row = _rows[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(row.name)),
//         DataCell(row.from),
//         DataCell(row.to),
//         DataCell(row.update)
//       ],
//     );
//   }
//
//   @override
//   int get rowCount => _rows.length;
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   // TODO: implement selectedRowCount
//   int get selectedRowCount => 0;
//
//
//   //
//   // @override
//   // int get selectedRowCount => _selectedCount;
// }

class DoctorsAppointment extends StatefulWidget {
  String uid;
  DoctorsAppointment(this.uid);
  @override
  _DoctorsAppointmentState createState() => _DoctorsAppointmentState();
}
class _DoctorsAppointmentState extends State<DoctorsAppointment> {
  dynamic appointments;
  dynamic name;
  dynamic time;
  Future<dynamic> getData() async {

    final DocumentReference document =   FirebaseFirestore.instance.collection("DoctorsInfo").doc(widget.uid);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        DateTime date = DateTime.now();
        appointments=snapshot.get(DateFormat('EEEE').format(date).toLowerCase().substring(0,3)+'slots');
        name=snapshot.get('name');
        time=snapshot.get(DateFormat('EEEE').format(date).toLowerCase().substring(0,3));
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
        title: Text('Today\'s Appointments'.tr),
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

             Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person_outlined),
              title: Text(appointment['name']),
              subtitle: Text(appointment['rollno'].toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('VISITED'),
                  onPressed: () async {
                    DateTime date = DateTime.now();
                    print(appointment['id']);
                    await DatabaseService(uid: widget.uid)
                        .deleteAppointment(appointment['id'],appointment['name'], appointment['rollno'],DateFormat('EEEE').format(date).toLowerCase().substring(0,3)+'slots');
                         await Patient(appointment['id']).adddetails(widget.uid, name, DateFormat('EEEE').format(date).toLowerCase(), time, "https://firebasestorage.googleapis.com/v0/b/medibuddy-4e526.appspot.com/o/files%2FIMG-20221110-WA0000.jpg?alt=media&token=54f6ebb6-c565-4a61-b0f6-cf82116d08bb");
                    Navigator.pop(context);
                         Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DoctorsAppointment(widget.uid),
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      )]));

  }
}

class StudentInfo extends StatefulWidget{
  @override
  StudentInfo();
  _StudentInfoState createState() => _StudentInfoState();
}
class _StudentInfoState extends State<StudentInfo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  dynamic student;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student's Information"),
          backgroundColor: Colors.black87,
        ),
        body: Column(
            children:[Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Student's Email",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                     padding: EdgeInsets.all(20.0),
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.black87,
                         //onPrimary: Colors.black,
                       ),
                       onPressed: () async {
                        final DocumentReference document =   FirebaseFirestore.instance.collection("PatientsInfo").doc(emailController.text);
                        bool exists;
                        await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
                            exists=snapshot.exists;
                            if(exists) {
                            student = snapshot;
                            print(student['name']);
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentsInfo(student.id,student['name'],student['age'],student['rollno'])), //appointment['report'])),
                            );
                          }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(""),
                                      content: Text("Patient with the following email does not exists, check the email and try again"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                        });

                      },
                      child:Text('Search'),
                     ))
            ])))]));

  }
}

class StudentsInfo extends StatelessWidget{
  final String name;
  final String age;
  final String phone;
  final String uid;
  StudentsInfo(this.uid,this.name,this.age,this.phone);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acount',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Student Information'),
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
                      'Name',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Age',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      age,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      uid,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Phone Number',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      phone,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}