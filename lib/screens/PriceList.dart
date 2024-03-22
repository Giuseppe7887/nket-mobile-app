import 'package:flutter/material.dart';
import 'package:nket/main.dart';
import 'package:nket/screens/SelectedItem.dart';
import 'package:nket/services/utils.dart';

// shared class
import 'package:nket/shared.dart';
import 'package:nket/services/firebase/rtdb.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nket/services/firebase/auth.dart';

import 'package:vm_service/utils.dart';


class PriceList extends StatefulWidget {
  const PriceList({super.key});


  @override
  State<PriceList> createState() => _PriceListState();
}

class _PriceListState extends State<PriceList> {



  final String instructions = "start verification";
  final String expired = "not available";

  Future<void> onSelectItem({required NketItem item}) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SelectedItem(item: item);
    }));
  }

  List<NketItem> _data = [];

    @override
  void initState() {
    // TODO: implement initState



    RtDb().update(cb: (Map result){

      List<NketItem> resultToList = result.keys.map((e) => NketItem(title: result[e]['title'], description: result[e]['description'],products: result[e]['products'], location:  result[e]['location'], id: result[e]['id'], available: result[e]['available'], verifiedBy:result[e]['verifiedBy'], isClosed: result[e]['isClosed'] )).toList();

        Map mapped = Utils().getMappedList(fullList: resultToList);
        print(mapped);

      setState(() {

        _data = result.keys.map((e) => NketItem(title: result[e]['title'], description: result[e]['description'],products: result[e]['products'], location:  result[e]['location'], id: result[e]['id'], available: result[e]['available'], verifiedBy:result[e]['verifiedBy'], isClosed: result[e]['isClosed'] )).toList();

      });
    }).catchError((err){print(err);});
  }

  User? currentUser =Auth().currentUser();


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((NketItem item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(item.title),
                      const Padding(padding: EdgeInsets.only(right: 7)),
                      Text(item.id,style: const TextStyle(fontWeight: FontWeight.bold))
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
                  child: item.available == true ?  InkWell(
                    onTap: ()=>onSelectItem(item: item),
                    child:  Row(
                      children: [
                        Text(instructions,style: TextStyle(color: Colors.orange)),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        const Icon(Icons.verified, color: Colors.orange)
                      ]
                    )
                  ):Row(
                      children: [
                        item.verifiedBy == currentUser!.uid && !item.isClosed?const Text("back to price",style: TextStyle(color: Colors.green)):Text(expired,style: const TextStyle(color: Colors.grey)),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        item.verifiedBy == currentUser!.uid && !item.isClosed? const Icon(Icons.keyboard_return_sharp, color: Colors.green):const Icon(Icons.back_hand,color: Colors.grey)
                      ]
                  )
                ),
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ],
    );
  }
}
