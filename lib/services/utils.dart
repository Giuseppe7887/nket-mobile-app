import "dart:convert";
import "package:flutter/material.dart";
import "package:nket/services/firebase/auth.dart";
import "package:nket/shared.dart";

class Utils {
  Utils();

  Color genRGBAfromEmail({required String? email}) {
    List<int> encoded = utf8.encode(email!);
    List<int> rgb = encoded.sublist(1, 3).toList();
    rgb.insert(0, email.length);
    return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
  }

  List filterDoneByUser({required List<NketItem>  fullList,required String uid}) {
    return fullList.where((element) => element.isClosed && element.verifiedBy == uid).toList();
  }

  List filterClosed({required List<NketItem>  fullList, required String uid}) {
    return fullList.where((element) => element.isClosed && element.verifiedBy != uid).toList();
  }

  List filterAvailable({required List<NketItem>  fullList}) {
    return fullList.where((element) => element.available).toList();
  }

  List filterPending({required List<NketItem>  fullList,required String uid}) {
    return fullList.where((element) => !element.available && !element.isClosed && element.verifiedBy == uid).toList();
  }

  // TODO
  //  per migliorare le prformance fare un map nella fulllist
  //  e buttare gli elementi nel map in modo sistematico (cosi ci sarà un solo loop anzichè 4)

  Map<String, List> getMappedList({required List<NketItem> fullList}) {
    String uid = Auth()!.currentUser()!.uid;

    List doneByUser = filterDoneByUser(fullList: fullList,uid:uid);
    List closed = filterClosed(fullList: fullList, uid: uid);
    List available = filterAvailable(fullList: fullList);
    List pending = filterPending(fullList: fullList, uid: uid);

    return {
      "pending": pending,
      "doneByUser": doneByUser,
      "closed": closed,
      "available": available
    };
  }
}
