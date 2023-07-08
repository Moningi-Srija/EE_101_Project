import 'package:flutter/material.dart';
import './drawer.dart';

class AmbulancePage extends StatelessWidget {
  const AmbulancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Prop(),
      appBar: AppBar(
        title: const Text("IITB Hospital's Ambulance Service"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: const AmbulancePageBody(),
    );     
  }
}

class AmbulancePageBody extends StatelessWidget {
  const AmbulancePageBody({super.key});
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
                  fontSize: 60
                ),
              )
            ),
            TextButton(
              onPressed: () {
                //emergency
              },
              child: const Text(
                'Emergency Cases',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),              
            ),            
            TextButton(
              onPressed: () {
                //normal
              },
              child: const Text(
                'Normal cases',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
            ),          
          ]
        ),       
    );         
  }
}
