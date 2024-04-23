import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:nket/shared.dart';


class ProductResearch extends StatefulWidget {
  ProductResearch({super.key, required this.item});

  NketItem item;


  @override
  State<ProductResearch> createState() => _ProductResearchState();
}

class _ProductResearchState extends State<ProductResearch> {

  List<Product> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<Product> tmp = [];
    widget.item.products.forEach((key, value) {
        tmp.add(
          Product(name: key.toString(), done:value["done"],imageUrl: value["imageUrl"])
        );
    });
    setState(() {
      products = tmp;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.id),
      ),
      body:GridView.builder(
        itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
          ),
        itemBuilder: (BuildContext context, int index) {
            return GridTile(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(products[index].name),
                    Icon(products[index].done ? Icons.done:Icons.cancel)
                  ],
                )
            );
        },

      )
    );
  }
}

/*
* Column(
        children: [

        ],*/

// ListTile PanelBody({required String title, required bool isClosed}){
//   if(isClosed){
//     return ListTile(
//       title: Text("chiusa"),
//     );
//   }else{
//     return ListTile();
//   }
//
// }
// ExpansionPanelList(
// expansionCallback: (int index, bool isExpanded){
// setState(() {
// products[index]["isOpen"] = !products[index]["isOpen"];
// });
// },
// children: products.map((e){
// final String title = e.keys.first;
// final bool isClosed = e.values.first;
// return ExpansionPanel(
// isExpanded: e["isOpen"],
// headerBuilder: (BuildContext context, bool isExpanded){
// return ListTile(
// title: Text(title),
// leading: isClosed ? const Icon(Icons.done):const Icon(Icons.cancel)
// );
// },
// body: PanelBody(title:title,isClosed: isClosed )
// );
// }).toList(),
// )