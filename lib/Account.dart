import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  // This widget is the root of your application.
  final String name;
  final String age;
  final String phone;
  final String uid;
  AdminPage(this.uid,this.name,this.age,this.phone);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acount',
      home: Scaffold(
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
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                color:Colors.black
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        minRadius: 60.0,
                        child: Icon(
                          Icons.person,
                          size: 80.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
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