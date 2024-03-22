import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nket/shared.dart';

// camera component
import 'package:camera/camera.dart';

import 'package:nket/components/Camera.dart';

late List<CameraDescription> _cameras;

class SelectedItem extends StatefulWidget {
  SelectedItem({super.key, required this.item});

  NketItem item;

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  @override
  Widget build(BuildContext context) {

    Size phoneSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Colors.orange,
          title: Text(widget.item.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700))),
      body: Column(
        children: [
          Camera(cameraLabel: const Text("scatta la foto al negozio",style: TextStyle(color: Colors.white)))
        ],    
      ),
    );
  }
}
