import 'package:flutter/material.dart';



class DashboardItem extends StatelessWidget {
  DashboardItem({super.key,required this.content, required this.title,required this.index});
  String content;
  String title;
  int index;

  @override
  Widget build(BuildContext context) {

    return Card(
        // margin: index % 2 == 0 ? EdgeInsets.only(left: 20,right: 10) :EdgeInsets.only(right: 20,left: 10),
        child: GridTile(
          footer: Center(child: Text(title)),
          child: Center(
            child: Text(content,style: const TextStyle(fontSize: 25))
          )
      )
    );
  }
}
