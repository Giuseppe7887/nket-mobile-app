import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Iterable> listUser() async {
    return await firestore
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((e) => e.data());
    });
  }

  addUser({required String uid}) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.add({"uid": uid, "pricesFound": []});
  }
}
