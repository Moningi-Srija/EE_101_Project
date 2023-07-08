import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class SSignInPage extends StatefulWidget {
  const SSignInPage({super.key});
  static const String _title = 'IITB Hospital';

  @override
  State<SSignInPage> createState() => _SSignInPageState();
}

class _SSignInPageState extends State<SSignInPage> {
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
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )
                    ,),
                  Padding(
                    // alignment: Alignment.center,
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        'SignIn as Hospital Staff'.tr,
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
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text(
                      'Forgot Password',
                    ),
                  ),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     const Text('Does not have account?'),
                  //     TextButton(
                  //       child: const Text(
                  //         'Sign Up',
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => EmailSignUp()),
                  //         );
                  //       },
                  //     )
                  //   ],
                  // ),
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
        if(snapshot.value['role']=='staff'){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StaffHome(uid: result.user!.uid)),
          );}
        else{
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("No such staff exists"),
                  actions: [
                    ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SSignInPage()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SSignInPage()),
                    );
                  },
                )
              ],
            );
          });
    });
  }
}

class StaffHome extends StatelessWidget{
  StaffHome({this.uid});
  final String? uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IITB Pharmacy Interface'.tr),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img4.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
            child: Text('Home Screen')
        ),
      ),
    );
  }
}