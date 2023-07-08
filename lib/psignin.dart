import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eeapp/pharmacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import './drawer.dart';
import 'Account.dart';
import 'billing.dart';
import 'database.dart';
import 'email_signup.dart';
import './docav.dart';
import './appointment.dart';
import 'medicalbook.dart';
import 'package:intl/intl.dart';

class SignInPage extends StatefulWidget {
  @override
  SignInPageBody createState() => SignInPageBody();
}
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

// class DataTableDemo extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor\'s Availability'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           //DropdownButtonApp(),
//           PaginatedDataTable(
//             showCheckboxColumn: false,
//             header: Text('Doctor\'s Availability'),
//             rowsPerPage: 8,
//             columns: [
//               DataColumn(label: Text('Doctor')),
//               DataColumn(label: Text('')),
//             ],
//             source: _DataSource(context, <_Row>[
//               _Row(
//                   'Rishi Naik',
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black87,
//                       shape: StadiumBorder(),
//                     ),
//                     onPressed: () {},
//                     child: Text('Check Availability'),
//                   )),
//               _Row(
//                   'Kushal',
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black87,
//                       shape: StadiumBorder(),
//                     ),
//                     onPressed: () {},
//                     child: Text('Check Availability'),
//                   )),
//               _Row(
//                   'Hrushi',
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black87,
//                       shape: StadiumBorder(),
//                     ),
//                     onPressed: () {},
//                     child: Text('Check Availability'),
//                   )),
//               _Row(
//                   'Prahasith',
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black87,
//                       shape: StadiumBorder(),
//                     ),
//                     onPressed: () {},
//                     child: Text('Check Availability'),
//                   )),
//               _Row(
//                   'Saketh',
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black87,
//                       shape: StadiumBorder(),
//                     ),
//                     onPressed: () {},
//                     child: Text('Check Availability'),
//                   )),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Row {
//   _Row(
//       this.valueA,
//       this.checkavailability,
//       );
//
//   final String valueA;
//   final ElevatedButton checkavailability;
//
//   bool selected = false;
// }
//
// class _DataSource extends DataTableSource {
//   _DataSource(this.context, this._rows);
//
//   final BuildContext context;
//   List<_Row> _rows;
//
//   int _selectedCount = 0;
//
//   @override
//   DataRow getRow(int index) {
//     assert(index >= 0);
//     final row = _rows[index];
//     return DataRow.byIndex(
//       index: index,
//       selected: row.selected,
//       onSelectChanged: (value) {
//         if (value == null) {
//           return;
//         }
//         if (row.selected != value) {
//           _selectedCount += value ? 1 : -1;
//           assert(_selectedCount >= 0);
//           row.selected = value;
//           notifyListeners();
//         }
//       },
//       cells: [
//         DataCell(Text(row.valueA)),
//         DataCell(row.checkavailability),
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
//   int get selectedRowCount => _selectedCount;
// }
class SignInPageBody extends State<SignInPage> {
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
                                'IITB Hospital',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30),
                              )
                          ,),
                  Padding(
                              // alignment: Alignment.center,
                              padding: const EdgeInsets.all(30),
                              child: const Text(
                                'Patient SignIn',
                                style: TextStyle(fontSize: 20),
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
                            padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
                            child: isLoading
                                ? CircularProgressIndicator()
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
                              child: Text('SignIn'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Does not have account?'),
                              TextButton(
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmailSignUp()),
                                  );
                                },
                              )
                            ],
                          ),

                      ])
                  )
                ));
  }

  void logInToFb() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((result) async {
      isLoading = false;
      final ref = FirebaseDatabase.instance.reference();
      final snapshot = await ref.child('Users/${result.user!.uid}').get();
      if (snapshot.exists) {
        print(snapshot.value['role']);
        if(snapshot.value['role']=='patient'){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PatientsHome(snapshot.value['email'],snapshot.value['name'],int.parse(snapshot.value['phone'].toString()),snapshot.value['age'])),
          );}
          else{
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("No such patient exists"),
                  actions: [
                    ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()),
                        );
                      },
                    )
                  ],
                );
              });
        }
      } else {
        print('No data available.');
      }
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/psignin');
                  },
                )
              ],
            );
          });
    });
  }
}

class reimburse extends StatelessWidget {
  reimburse({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
       home: Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed:() => Navigator.of(context).pop(),
          ),
        title: Text('Reimburse'),
        centerTitle: true,
        backgroundColor: Colors.black87,
       ),
       body: ReimburseBody(),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.black87,
        child: const Text('Back'),
      ),
       ) 
    );
  }
}
class ReimburseBody extends StatelessWidget{
  ReimburseBody({super.key});
  @override
  Widget build(BuildContext context){
    return Padding(
       padding: const EdgeInsets.all(30),
       child: ListView(children: <Widget>[
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: ElevatedButton(
              child: const Text('Submit Bill'),
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                //onPrimary: Colors.black,
              ),
            )),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: ElevatedButton(
              child: const Text('Current Status'),
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                //onPrimary: Colors.black,
              ),
            )),
            Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: ElevatedButton(
              child: const Text('Paid/Declined with reason'),
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                //onPrimary: Colors.black,
              ),
            )),
      ]),
    );
  }
}

class PatientDrawer extends StatelessWidget{
  final Uri ambulancenumber = Uri.parse('tel:9515599018');
  final Uri adminmail = Uri.parse('mailto:210050098@iitb.ac.in?subject=&body=');
  PatientDrawer(this.uid,this.name,this.rollno,this.age);
  final String uid;
  final String name;
  final int rollno;
  final String age;
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Material(
        child: ListView(
          children: <Widget>[
            Container(
              // padding: padding,
              child: Column(
                children : [
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Account'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminPage(uid,name,age,rollno.toString()),
                      ));
                    },
                  ),
                  // //const SizedBox(height : 30),
                  // ListTile(
                  //   leading: Icon(Icons.approval),
                  //   title: Text('FAQ'.tr),
                  //   hoverColor: Colors.grey,
                  //   onTap: () {
                  //
                  //   },
                  // ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.call),
                    title: Text('Contact us'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      launchUrl(ambulancenumber);
                    },
                  ),
                  //const SizedBox(height : 30),
                  ListTile(
                    leading: Icon(Icons.comment),
                    title: Text('Raise a complaint'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      launchUrl(adminmail);
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign out'.tr),
                    hoverColor: Colors.grey,
                    onTap: () {
                      try{
                        FirebaseAuth.instance.signOut();
                      }catch(error){
                        print(error.toString());
                      }
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

class PatientsHome extends StatelessWidget {
  //const PatientsHome({super.key});
  PatientsHome(this.uid,this.name,this.rollno,this.age);
  final String uid;
  final String name;
  final int rollno;
  final String age;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IITB Hospital Patients Interface'.tr),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img3.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Patientpage(uid:uid,name:name,rollno: rollno),
      ),
      drawer: PatientDrawer(uid,name,rollno,age),
    );
  }
}

class Patientpage extends StatelessWidget{

  final String uid;
  final String name;
  final int rollno;
  Patientpage({required this.uid,required this.name,required this.rollno});
  @override
  Widget build(BuildContext context) {

    return Center(
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
                            builder: (context) => DataTableDemo(uid:uid,name:name,rollno:rollno),
                          ));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.approval,size: 80.0,), // icon
                            Text("Book",style: TextStyle(fontSize: 22)), // text
                            Text("Appointment",style: TextStyle(fontSize: 22)), // text

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
                            builder: (context) => CheckAppointments(uid),
                          ));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.group,size: 80.0,), // icon
                            Text("Check",style: TextStyle(fontSize: 22)), // text
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
                        onTap: () {Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MedicalRecords(uid),
                        ));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.menu_book,size: 80.0,), // icon
                            Text("Medical Book",style: TextStyle(fontSize: 25)), // text
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
                            Text("Reports",style: TextStyle(fontSize: 25)), // text
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => uploadfile(uid:uid)),
                          );
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.local_pharmacy,size: 80.0,), // icon
                            Text("Pharmacy",style: TextStyle(fontSize: 25)), // text
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => reimbursefile(uid:uid)),
                          );
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.money,size: 80.0,), // icon
                            Text("Billing Details",style: TextStyle(fontSize: 25)), // text
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
    );
  }
}

class CheckAppointments extends StatefulWidget {
  String uid;
  CheckAppointments(this.uid);
  @override
  _CheckAppointmentsState createState() => _CheckAppointmentsState();
}
class _CheckAppointmentsState extends State<CheckAppointments> {
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
          title: Text('Your Appointments'.tr),
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
                if(appointment['visited'] == false)
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
                            child: const Text('VISITED'),
                            onPressed: () async {
                              String docid=appointment['docid'];
                              print(appointment['day'].toString().substring(0, 3)+'slots');
                              final now = new DateTime.now();
                              String formatter = DateFormat('yMd').format(now);
                              await Patient(widget.uid).visited(docid, appointment['doctor'],formatter, appointment['timeslot']);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Doctor Visit Completed"),
                                      content: Text("Do you want to go to the pharmacy"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            shape: StadiumBorder(),
                                          ),
                                          child: const Text("Go To Pharmacy"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => MainPage(widget.uid),
                                            ));
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            shape: StadiumBorder(),
                                          ),
                                          child: const Text("Return to home page"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),TextButton(
                            child: const Text('Cancel'),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(""),
                                      content: Text("Are you sure you want to cancel?"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            shape: StadiumBorder(),
                                          ),
                                          child: const Text("Yes"),
                                          onPressed: () async {String docid=appointment['docid'];
                                          print(appointment['day'].toString().substring(0, 3)+'slots');
                                          await DatabaseService(uid: docid)
                                              .deleteAppointment(widget.uid,name, int.parse(rollno), appointment['day'].toString().substring(0, 3)+'slots');
                                          await Patient(widget.uid).deletepatientCollection(docid, appointment['doctor'], appointment['day'], appointment['timeslot']);

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CheckAppointments(widget.uid),
                                          ));
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            shape: StadiumBorder(),
                                          ),
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });

                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )]));
  }
}