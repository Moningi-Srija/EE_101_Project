import 'package:flutter/material.dart';
import './drawer.dart';

class ASignInPage extends StatelessWidget {
  const ASignInPage({super.key});
  static const String _title = 'IITB Hospital';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Prop(),
      appBar: AppBar(
        title: const Text(_title),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: ASignInPageBody(),      
    );
  }
}

class ASignInPageBody extends StatelessWidget {
  ASignInPageBody({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30),
            child: const Text(
              'IITB Hospital',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30),
            child: const Text(
              'Admin SignIn',
              style: TextStyle(fontSize: 20),
            )
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password screen
            },
            child: const Text(
              'Forgot Password',
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: ElevatedButton(
              onPressed: () {
                print(nameController.text);
                print(passwordController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminsHome()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                //onPrimary: Colors.black,
              ),
              child: const Text('Sign in'),
            )
          ),
        ],
      )
    );
  }
}

class AdminsHome extends StatelessWidget {
  // This widget is the root of your application.
  const AdminsHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IITB Hospital Admins Interface'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img1.jpeg'),
            fit: BoxFit.cover,
          ),     
        ),
        child: const Center(
          child: Text('Home Screen') 
        ),        
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text('Admins interface'),
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              title: const Text('Doctors Availability'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Doctors Appointment'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Pharmacy'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Reports'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Doctors visit'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Reimburse'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Medical Book'),
              onTap: () {
               // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Lab Order'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Student Information'),
              onTap: () {
                  // Update the state of the app.
                  // ...
              },
            ),
            ListTile(
              title: const Text('Enroll Doctors'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.black87,
          child: const Text('Back'),
      ),
    );
  }
}