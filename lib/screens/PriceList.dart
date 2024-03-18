import 'package:flutter/material.dart';
import 'package:nket/screens/SelectedItem.dart';

// shared class
import 'package:nket/shared.dart';

import 'package:nket/services/firebase/rtdb.dart';

class PriceList extends StatefulWidget {
  const PriceList({super.key});


  @override
  State<PriceList> createState() => _PriceListState();
}

class _PriceListState extends State<PriceList> {





  // final List<Item> _data = [
  //   Item(
  //       title: "Conad prices #098435",
  //       description: "Price research for Naples conad in cavour street 5",
  //       products: ["pane", "latte"],
  //       location: {"lat": "E32534FEWFAE", "long": "O4r8hf8d83"}),
  //   Item(
  //       title: "MD prices #098443",
  //       description: "Price research for Roma MD in dante street",
  //       products: ["pasta", "latte", "caramelle", "pane", "acqua", "biscotti"],
  //       location: {"lat": "E32435FEWFAE", "long": "32432rr3r3"}),
  //   Item(
  //       title: "Todis prices #098422",
  //       description:
  //           "Price research for Marcianise Todis in Saverio merola street",
  //       products: ["pane", "latte", "uova", "farina"],
  //       location: {"lat": "E32435FEWFAE", "long": "32432rr3r3"}),
  // ];

  final String instructions = "start verification";

  Future<void> onSelectItem({required Item item}) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SelectedItem(item: item);
    }));
  }

  List<Item> _data = [];


  @override
  void initState() {
    // TODO: implement initState
    RtDb().update(cb: (Map result){
      _data = result.keys.map((e) => Item(title: result[e]['title'], description: result[e]['description'],products: result[e]['products'], location:  result[e]['location'], id: result[e]['id'])).toList();
      setState(() {

      });
    }).catchError((err){print(err);});
  }

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
          children: _data.map<ExpansionPanel>((Item item) {
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
                  child: InkWell(
                    onTap: ()=>onSelectItem(item: item),
                    child: Row(
                      children: [
                        Text(instructions),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        const Icon(Icons.verified, color: Colors.orange)
                      ],
                    ),
                  ),
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
