import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class RtDb{
  // FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref("prices");



  Future<void> update({required cb})async{
    ref.onValue.listen((event) {
      if(event.snapshot.exists){

        Object data = event.snapshot.value as Object;
        cb(data);

      }
    });

  }



  Future<void> insertData({required String title, required String description, required String id})async{
    var l = FirebaseDatabase.instance.ref("prices/${const Uuid().v4()}");
    await l.set({
      "title": title,
      "description":description,
      "id":id,
      "products":["panna","latte","pane","pasta","vino"],
      "location":{"lat":"345q34fewf","long":"sdaiudasoifjaop"}
    });
  }
}