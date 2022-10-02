import 'package:flutter/material.dart';


class Prop extends StatelessWidget {
  const Prop({super.key});
  @override
  Widget build(BuildContext context){
    return Drawer(      
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text('App interface'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: const Text('Doctor SignIn Page'),
            onTap: (){
               Navigator.of(context).pushReplacementNamed('/dsignin');
            },
          ),
          ListTile(
            title: const Text('Patient SignIn Page'),
            onTap: (){
               Navigator.of(context).pushReplacementNamed('/psignin');
            },
          ),
          ListTile(
            title: const Text('Call for Ambulance'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/ambulance');
            },
          ), 
          ListTile(
            title: const Text('Admin'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/admin');
            },
          ),             
        ],
      ),         
    );
  }
}