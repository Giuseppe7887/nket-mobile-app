import "dart:convert";
import "package:flutter/material.dart";

class Utils {
  Utils();

  Color genRGBAfromEmail({required String? email}) {
    List<int> encoded = utf8.encode(email!);
    List<int> rgb = encoded.sublist(1, 3).toList();
    rgb.insert(0, email.length);
    return Color.fromRGBO(rgb[0],rgb[1],rgb[2],1);
  }


}
