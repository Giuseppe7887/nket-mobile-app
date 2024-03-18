import 'package:flutter/material.dart';
import 'package:nket/services/firebase/rtdb.dart';

class InsertItem extends StatelessWidget {
  InsertItem({super.key});

  final TextEditingController _title = TextEditingController();
  final TextEditingController _descrizione = TextEditingController();
  final TextEditingController _id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(hintText: "title"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    controller: _descrizione,
                    decoration: const InputDecoration(hintText: "description"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: TextFormField(
                    controller: _id,
                    decoration: const InputDecoration(hintText: "id"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(onPressed: () {
                    if(_title.text == "" || _descrizione.text == "" || _id.text == "") return;
                    RtDb().insertData(
                        title: _title.text, description: _descrizione.text, id: _id.text);
                  }, child: const Text("send")),
                )
              ]),
            )));
  }
}
