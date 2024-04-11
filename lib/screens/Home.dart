import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nket/services/firebase/rtdb.dart';

// ! db url https://nket-190ff-default-rtdb.firebaseio.com/
// components
import 'package:nket/components/DashboardItem.dart';

import 'package:nket/services/utils.dart';
import 'package:nket/shared.dart';

import 'package:nket/services/firebase/firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map finderData = {
    'doneByUser': null,
    'available': null,
    'closed': null,
    'pending': null,
  };


  Map commiteeData = {
    "total":null, // total prices
    "found":null, // found
    "in_progress":null, // not found but in progress
    "open":null // not found and not taken by anyone
  };

  bool init = false;
  bool ready = false;
  bool getUserType = false;
  bool isFinder = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firestore().getUserData().then((value) {
      setState(() {
        isFinder = value.isFinder;
      });
      setState(() {
        getUserType = true;
      });
    }).then((value) {
      ready = true;
      if (isFinder) {
        RtDb().update(cb: (Map result) {
          List<NketItem> resultToList = result.keys
              .map((e) => NketItem(
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

          Map<String, List> mapped =
              Utils().getMappedList(fullList: resultToList);

          if (!ready) return;
          setState(() {
            commiteeData = {
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
      } else {
        RtDb().update(cb: (Map result) {
          List<NketItem> resultToList = result.keys
              .map((e) => NketItem(
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

          Map<String, List> mapped =
          Utils().getMappedListForCommitee(fullList: resultToList);

          if (!ready) return;
          setState(() {
            commiteeData = {
              "total": mapped['total']!.length,
              "open": mapped['open']!.length,
              "closed": mapped['closed']!.length,
              "in_progress": mapped['in_progress']!.length
            };
            init = true;
            ready = true;
          });
        }).catchError((err) {
          print(err);
        });

        print("manage of commitee");

      }
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
    return getUserType
        ? GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            children: [
              // finder zone
              if (getUserType && isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(finderData['doneByUser'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'done',
                    index: 0),
              if (getUserType && isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(finderData['available'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'available',
                    index: 1),
              if (getUserType && isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(finderData['pending'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'pending',
                    index: 2),

              // commitee zone
              if (getUserType && !isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(commiteeData['total'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'total',
                    index: 0),
              if (getUserType && !isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(commiteeData['in_progress'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'in progress',
                    index: 1),
              if (getUserType && !isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(commiteeData['closed'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'closed',
                    index: 2),
              if (getUserType && !isFinder)
                DashboardItem(
                    content: !init
                        ? const CircularProgressIndicator()
                        : Text(commiteeData['open'].toString(),
                            style: const TextStyle(fontSize: 25)),
                    title: 'open',
                    index: 3),

            ]
          )
        : const Center(child: CircularProgressIndicator());
  }
}
