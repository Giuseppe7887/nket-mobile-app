import 'package:flutter/cupertino.dart';

class NketItem {
  NketItem({
    required this.title,
    required this.description,
    required this.products,
    required this.location,
    required this.id,
    required this.available,
    required this.verifiedBy,
    required this.isClosed,
    this.isExpanded = false,
  });

  String title;
  String description;
  List products;
  Map location;
  String id;
  bool available;
  String verifiedBy;
  bool isClosed;
  bool isExpanded;
}

class NketUser {
  NketUser({
    required this.pricesFound,
    required this.uid
  });

  String uid;
  List<String> pricesFound;
}
