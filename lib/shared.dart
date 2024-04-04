
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
    required this.firebaseId,
    this.isExpanded = false,
  });

  bool getType({required String conf}){
    switch(conf){
      case "available":
        return available;
      default:
        return false;
    }
  }


  String title;
  String description;
  List products;
  Map location;
  String id;
  bool available;
  String verifiedBy;
  bool isClosed;
  String firebaseId;
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
