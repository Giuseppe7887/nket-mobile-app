// UI - UX
import 'package:flutter/material.dart';

// ! db url https://nket-190ff-default-rtdb.firebaseio.com/
// components
import 'package:nket/components/DashboardItem.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {
    'done':20,
    'available':560,
  };



@override
Widget build(BuildContext context) {
  return GridView(
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:2
      ),
    children: [
      DashboardItem(
          content: data['done'].toString(),
          title:'done',
          index: 0
      ),
      DashboardItem(
          content: data['available'].toString(),
          title:'available',
          index: 1
      ), DashboardItem(
          content: "0",
          title:'placeholder',
          index: 2
      ),DashboardItem(
          content: "0",
          title:'placeholder',
          index: 3
      ),DashboardItem(
          content: "0",
          title:'placeholder',
          index: 4
      ),DashboardItem(
          content: "0",
          title:'placeholder',
          index: 5
      ),
    ],
  );
}
}

