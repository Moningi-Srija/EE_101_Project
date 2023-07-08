import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class appointment extends StatefulWidget {
  @override
  _appointmentState createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  var items2 = [
    '10:00-11:00',
    '1:00-2:00',
  ];

  // Initial Selected Value
  String dropdownvalue = 'Monday';
  // List of items in our dropdown menu
  var items = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(

            // Initial Value
            value: dropdownvalue,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;

              });
            },
          )
        ],
      ),
    );
  }
}