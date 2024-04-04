import 'package:flutter/material.dart';
import 'package:nket/services/firebase/rtdb.dart';

// ! db url https://nket-190ff-default-rtdb.firebaseio.com/
// components
import 'package:nket/components/DashboardItem.dart';

import 'package:nket/services/utils.dart';
import 'package:nket/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {
    'doneByUser': null,
    'available': null,
    'closed': null,
    'pending': null,
  };

  bool init = false;
  bool ready = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ready = true;
    RtDb().update(cb: (Map result) {
      List<NketItem> resultToList = result.keys
          .map((e) =>
          NketItem(
              title: result[e]['title'],
              description: result[e]['description'],
              products: result[e]['products'],
              location: result[e]['location'],
              id: result[e]['id'],
              available: result[e]['available'],
              verifiedBy: result[e]['verifiedBy'],
              isClosed: result[e]['isClosed'],
              firebaseId: result[e]['firebaseId']))
          .toList();

      Map<String, List> mapped = Utils().getMappedList(fullList: resultToList);

      if(!ready) return;
      setState(() {
        data = {
          "doneByUser": mapped['doneByUser']!.length,
          "available": mapped['available']!.length,
          "closed": mapped['closed']!.length,
          "pending": mapped['pending']!.length
        };
        init = true;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ready = false;
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [
        DashboardItem(
            content: !init
                ? const CircularProgressIndicator()
                : Text(data['doneByUser'].toString(),
                style: const TextStyle(fontSize: 25)),
            title: 'done',
            index: 0),
        DashboardItem(
            content: !init
                ? const CircularProgressIndicator()
                : Text(data['available'].toString(),
                style: const TextStyle(fontSize: 25)),
            title: 'available',
            index: 1),
        DashboardItem(
            content: !init
                ? const CircularProgressIndicator()
                : Text(data['pending'].toString(),
                style: const TextStyle(fontSize: 25)),
            title: 'pending',
            index: 2)
      ],
    );
  }
}


