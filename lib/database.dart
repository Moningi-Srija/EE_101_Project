import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
 final String uid;

 DatabaseService({required this.uid});

 final CollectionReference doctorCollection = FirebaseFirestore.instance
     .collection('DoctorsInfo');

 Future updateUserData(String Times, String Day) async {
  return await doctorCollection.doc(uid).update({
   Day: Times,
  });
 }

 Future updateUserData2(String uid, int roll,String patuid, String Field) async {
  return await doctorCollection.doc(this.uid).update({
   Field: FieldValue.arrayUnion([{"name": uid, "rollno": roll,'id':patuid}]),
  });
 }

 Future deleteAppointment(String uid,String name, int roll, String Field) async {
  return await doctorCollection.doc(this.uid).update({
   Field: FieldValue.arrayRemove([{"id":uid,"name": name, "rollno": roll}]),
  });
 }
}
class Patient {
 final String uid;

 Patient(this.uid);

 final CollectionReference patientCollection = FirebaseFirestore.instance
     .collection('PatientsInfo');

 Future addpatientCollection(String docid, String doctor, String day,
     String Timeslot) async {
  return await patientCollection.doc(uid).update({
   "Appointments": FieldValue.arrayUnion([
    {
     "docid": docid,
     "doctor": doctor,
     "day": day,
     "timeslot": Timeslot,
     "visited": false
    }
   ]),
  });
 }
 Future deletepatientCollection(String docid,String doctor,String day ,String Timeslot) async{
  return await patientCollection.doc(uid).update({
   "Appointments": FieldValue.arrayRemove([{"docid":docid,"doctor": doctor, "day":day,"timeslot":Timeslot ,"visited":false}]),
  });
 }
 Future visited(String docid,String doctor,String day ,String Timeslot) async{
  await patientCollection.doc(uid).update({
   "Appointments": FieldValue.arrayRemove([{"docid":docid,"doctor": doctor, "day":day,"timeslot":Timeslot ,"visited":false}]),
  });
  return await patientCollection.doc(uid).update({
   "Appointments": FieldValue.arrayUnion([
    {
     "docid": docid,
     "doctor": doctor,
     "day": day,
     "timeslot": Timeslot,
     "visited": true,
    }
   ]),
  });
 }
 Future adddetails(String docid,String doctor,String day ,String Timeslot,String url) async{
  await patientCollection.doc(uid).update({
   "Appointments": FieldValue.arrayRemove([{"docid":docid,"doctor": doctor, "day":day,"timeslot":Timeslot ,"visited":false}]),
  });
  return await patientCollection.doc(uid).update({
   "Appointments": FieldValue.arrayUnion([
    {
     "docid": docid,
     "doctor": doctor,
     "day": day,
     "timeslot": Timeslot,
     "visited": false,
     "details":url
    }
   ]),
  });
 }
}
class UrlService {

 final String uid;
 final String url;

 UrlService({ required this.uid, required this.url});

 // collection reference
 final CollectionReference brewCollection = FirebaseFirestore.instance
     .collection('Pharmacy Files');
 final CollectionReference userCollection = FirebaseFirestore.instance
     .collection('User Files');

 Future updateData() async {
  return await brewCollection.doc(uid).get().then((docSnapshot) =>
  {
   if (docSnapshot.exists) {
    brewCollection.doc(uid).update({
     "Prescription links": FieldValue.arrayUnion(
         [{"url": url, "status": "pending"}]),
    }),
    userCollection.doc(uid).update({
     "Prescription links": FieldValue.arrayUnion(
         [{"url": url, "status": "pending"}]),
    })
   } else
    {
     brewCollection.doc(uid).set({
      "Prescription links": FieldValue.arrayUnion(
          [{"url": url, "status": "pending"}]),
     }),
     userCollection.doc(uid).set({
      "Prescription links": FieldValue.arrayUnion(
          [{"url": url, "status": "pending"}]),
     }),
    }
  });
 }
 Future pendingData(String status) async{
  return await brewCollection.doc(uid).get().then((docSnapshot) =>
  {
   brewCollection.doc(uid).update({
    "Prescription links": FieldValue.arrayRemove(
        [{"url": url, "status": "pending"}]),
   }),
   userCollection.doc(uid).update({
    "Prescription links": FieldValue.arrayRemove(
        [{"url": url, "status": "pending"}]),
   }),
   brewCollection.doc(uid).update({
    "Prescription links": FieldValue.arrayUnion(
        [{"url": url, "status": status}]),
   }),
   userCollection.doc(uid).update({
    "Prescription links": FieldValue.arrayUnion(
        [{"url": url, "status": status}]),
   })
  });
 }
 Future removeData() async{
  return await brewCollection.doc(uid).get().then((docSnapshot) =>
  {
   brewCollection.doc(uid).update({
    "Prescription links": FieldValue.arrayRemove(
        [{"url": url, "status": "Completed"}]),
   }),
  });
 }
}

