import 'package:flutter/material.dart';
import './drawer.dart';

class DocOrPat extends StatelessWidget {
  const DocOrPat({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Prop(),
      appBar: AppBar(
        title: const Text("IITB Hospital"),
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
    ); 
  }
}