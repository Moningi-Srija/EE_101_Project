import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import './firebase_api.dart';
import './database.dart';
import './psignin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';


class uploadfile extends StatelessWidget{
  final String uid;
  uploadfile({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacy"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
            icon:const Icon(Icons.arrow_back),
            onPressed:() => Navigator.of(context).pop()
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),

       child : View(uid:uid),
    ),);
  }
}

class View extends StatelessWidget{
  final String uid;
  View({required this.uid});
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
                            builder: (context) => MainPage(uid),
                          ));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.add_shopping_cart,size: 110.0,), // icon
                            Text("Place Order",style: TextStyle(fontSize: 25)), // text

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: 150,width: 10,),
              ]
          ),
          TableRow(
              children: [

                SizedBox(height: 15,width: 150,),
                //SizedBox(height: 25,width: 10,),
                //SizedBox(height: 15,width: 150,),

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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PharmacyUserHome(uid:uid),
                          ));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.search,size: 110.0,), // icon
                            Text("View Orders",style: TextStyle(fontSize: 25)), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //SizedBox(height: 150,width: 10,),

              ]
          ),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey,
      minimumSize: Size.fromHeight(50),
    ),
    child: buildContent(),
    onPressed: onClicked,
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 28),
      SizedBox(width: 16),
      Text(
        text,
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
    ],
  );
}

class MainPage extends StatefulWidget {
  final String uid;
  MainPage(this.uid);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UploadTask? task;
  File? file;
  Uri? _url;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text("Pharmacy"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pop()
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height:8),
              Text(
                fileName,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),
              SizedBox(height: 10),
              task != null ? buildUploadStatus(task!) : Container(),
              SizedBox(height: 20),
              ButtonWidget(
                text: 'View file',
                icon: Icons.pageview,
                onClicked: _launchUrl,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await UrlService(uid:widget.uid,url:urlDownload).updateData();
    print('Download-Link: $urlDownload');
    _url = Uri.parse(urlDownload);

  }

  Future _launchUrl() async {
    if (!await launchUrl(_url!,mode:LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }


  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}

class PharmacyUserHome extends StatelessWidget {
  PharmacyUserHome({required this.uid});

  final String uid;

  Future _launchUrl(_url) async {
    if (!await launchUrl(
        Uri.parse(_url!), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy'.tr),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img4.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child:
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('User Files')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: snapshot.data!.docs.map((document) {
                    String id = document.id;
                    return Column(
                        children: <Widget>[
                          for(int i = 0; i <
                              document["Prescription links"].length && id==uid; i++)(
                              Row(
                                children: <Widget>[
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        //minimumSize: Size.fromHeight(50),
                                      ),
                                      onPressed: () {
                                        _launchUrl(
                                            document["Prescription links"][i]['url']);
                                      },
                                      child: Text("View File", style: TextStyle(
                                          fontSize: 22, color: Colors.white))),
                                  SizedBox(width: 4),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        //minimumSize: Size.fromHeight(50),
                                      ),
                                      icon: Icon(Icons.pending),
                                      onPressed: () { },
                                      label: Text(
                                          document["Prescription links"][i]['status'],
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white))),
                                  SizedBox(width: 4),

                                ],
                              )
                          ),
                        ]
                    );
                  }).toList(),
                );
              }else{
                return Center(
                  child: Text(
                      "No orders till now", style: TextStyle(fontSize: 20)),
                );
              }
            }),
      ),
    );
  }
}


