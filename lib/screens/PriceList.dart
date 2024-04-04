import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nket/screens/SelectedItem.dart';
import 'package:nket/services/utils.dart';

// shared class
import 'package:nket/shared.dart';
import 'package:nket/services/firebase/rtdb.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nket/services/firebase/auth.dart';

class PriceList extends StatefulWidget {
  const PriceList({super.key});

  @override
  State<PriceList> createState() => _PriceListState();
}

class _PriceListState extends State<PriceList> {
  final String instructions = "start verification";
  final String expired = "not available";
  bool mounted = false;
  bool ready = false;
  Map<dynamic, dynamic> mappedData = {
    "available": [],
    "pending": [],
    "doneByUser": []
  };



  void setReady(){

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

      Map mapped = Utils().getMappedList(fullList: resultToList);

      setState(() {
        mappedData = mapped;
        ready = true;
      });
    }).catchError((err) {
      print(err);
    });

  }

  Future<void> onSelectItem({required NketItem item}) async {
    setState(() {
      ready = false;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SelectedItem(item: item,setReady:setReady);
    }));
  }






  @override
  void initState() {
    // TODO: implement initState

    ready = true;
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

      Map mapped = Utils().getMappedList(fullList: resultToList);

      if (!ready) return;
      setState(() {
        mappedData = mapped;
        ready = true;
      });
    }).catchError((err) {
      print(err);
    });
  }

  User? currentUser = Auth().currentUser();

  Widget BuildListByType(
      {required String type, required List filtered, required Color color}) {
    return filtered.length > 0
        ? Column(
            children: [
              Text(type, style: TextStyle(fontSize: 20, color: color)),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    filtered[index].isExpanded = isExpanded;
                  });
                },
                children: filtered.map<ExpansionPanel>((item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Row(
                          children: [
                            Text(item.title),
                            const Padding(padding: EdgeInsets.only(right: 7)),
                            Text(item.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                          "${item.description}, ${item.products.length} prices to research"),
                      // trailing: ,
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: item.available == true
                              ? InkWell(
                                  onTap: () => onSelectItem(item: item),
                                  child: Row(children: [
                                    Text(instructions,
                                        style: const TextStyle(
                                            color: Colors.orange)),
                                    const Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                    const Icon(Icons.verified,
                                        color: Colors.orange)
                                  ]))
                              : Row(children: [
                                  item.verifiedBy == currentUser!.uid &&
                                          !item.isClosed
                                      ? const Text("back to price",
                                          style: TextStyle(color: Colors.green))
                                      : Text(expired,
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                  const Padding(
                                      padding: EdgeInsets.only(right: 10)),
                                  item.verifiedBy == currentUser!.uid &&
                                          !item.isClosed
                                      ? const Icon(Icons.keyboard_return_sharp,
                                          color: Colors.green)
                                      : const Icon(Icons.back_hand,
                                          color: Colors.grey)
                                ])),
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ],
          )
        : const Text("");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ready = false;
  }

  @override
  Widget build(BuildContext context) {
    const double listPadding = 45.0;

    return ready
        ? ListView(
            children: [
              BuildListByType(
                  filtered: mappedData["available"],
                  type: 'AVAILABLE',
                  color: Colors.orange),
              const Padding(padding: EdgeInsets.only(bottom: listPadding)),
              BuildListByType(
                  filtered: mappedData["pending"],
                  type: 'PENDING',
                  color: Colors.green),
              const Padding(padding: EdgeInsets.only(bottom: listPadding)),
              BuildListByType(
                  filtered: mappedData["doneByUser"],
                  type: 'DONE',
                  color: Colors.grey),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
