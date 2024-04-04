import 'package:firebase_database/firebase_database.dart';
import 'package:nket/services/firebase/auth.dart';
import 'package:uuid/uuid.dart';

final String idAzienda = "id_azienda";

class RtDb {
  // FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref("prices/$idAzienda");

  Future<void> update({required cb}) async {
    ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        Object data = event.snapshot.value as Object;
        cb(data);
      }
    });
  }

  Future<void> insertData(
      {required String title,
      required String description,
      required String id}) async {
    var l = FirebaseDatabase.instance.ref("prices/$idAzienda/${Uuid().v4()}");
    await l.set({
      "firebaseId":l.ref.key,
      "title": title,
      "description": description,
      "id": id,
      "products": ["panna", "latte", "pane", "pasta", "vino"],
      "location": {"lat": "345q34fewf", "long": "sdaiudasoifjaop"},
      "isClosed": false,
      "available": true,
      "verifiedBy": ""
    });
  }

  Future assignResearchToUser({required String itemId}) async {
    String userId = Auth().currentUser()!.uid;

    print(itemId);
    DatabaseReference priceLIstRefInDb = FirebaseDatabase.instance.ref("prices/$idAzienda/$itemId");

    priceLIstRefInDb.update(
      {
        "available":false,
        "verifiedBy":userId
      }
    );
  }
}
