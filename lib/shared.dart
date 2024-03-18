class Item {
  Item({
    required this.title,
    required this.description,
    required this.products,
    required this.location,
    required this.id,
    this.isExpanded = false,
  });

  String title;
  String description;
  List products;
  Map location;
  String id;
  bool isExpanded;
}