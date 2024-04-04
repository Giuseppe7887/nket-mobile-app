import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nket/shared.dart';

// camera component
import 'package:camera/camera.dart';

import 'package:nket/components/Camera.dart';

late List<CameraDescription> _cameras;

class SelectedItem extends StatefulWidget {
  SelectedItem({super.key, required this.item, required this.setReady});

  NketItem item;
  var setReady;

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  @override
  Widget build(BuildContext context) {
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
          Camera(
            setReady:widget.setReady,
              cameraLabel: const Text("please take picture of store",
                  style: TextStyle(color: Colors.white)),
              item: widget.item)
        ],
      ),
    );
  }
}
