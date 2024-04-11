import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'package:nket/shared.dart';

class Firestore {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<Iterable> listUser() async {
  //   return await firestore
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     return querySnapshot.docs.map((e) => e.data());
  //   });
  // }

  Future<void> addUser({required String uid}) async {
    await firestore.collection('users').doc(uid).set({
      "uid": uid,
      "pricesFound": [],
      "finder": false
    }); // finder will be the price researcher
  }

  Future<NketUser> getUserData() async {
    String userId = await Auth().currentUser()!.uid;
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .where(FieldPath.documentId, isEqualTo: userId)
        .get();
    Map<String, dynamic> userFound = snapshot.docs[0].data();
    NketUser finalUser = NketUser(
        uid: userFound['uid'],
        isFinder: userFound['isFinder']);
    if(userFound["isFinder"]){
      finalUser.pricesFound = List<String>.from(userFound['pricesFound']);
    }else{
      finalUser.researches = List<String>.from(userFound['researches']);

    }
    return finalUser;
  }
}
