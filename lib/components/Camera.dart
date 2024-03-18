import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Camera extends StatefulWidget {
  Camera({super.key, required this.cameraLabel});

  Widget cameraLabel;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late CameraDescription _currentCamera;
  String pictureTaken = "";
  bool _initializeControllerOk = false;

  // get all cameras
  Future<List<CameraDescription>> getAllCameras() async {
    return await availableCameras();
  }

  // select current camera
  Future<void> selectCamera(cameraSelected) async {
    setState(() {
      _currentCamera = cameraSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCameras().then((cameras) async {
      await selectCamera(cameras[0]);
      _controller = CameraController(_currentCamera, ResolutionPreset.medium);
    }).then((c) async {
      await _controller.initialize();
      setState(() {
        _initializeControllerOk = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> takePicture() async {
      await _controller.takePicture().then((value) {
        setState(() {
          pictureTaken = value.path;
        });
      });
      setState(() {
        _initializeControllerOk = false;
      });
      await _controller.dispose();
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [




          if (pictureTaken != "")
            Image.file(File(pictureTaken))
          else if (!_initializeControllerOk)
            const Center(child: Text('loading...'))
          else
            CameraPreview(_controller,
                child: Center(child: widget.cameraLabel)),
          if (_initializeControllerOk)
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                    icon: const Icon(Icons.circle_outlined, size: 75),
                    onPressed: takePicture)),

          if (pictureTaken != "")

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(padding: const EdgeInsets.all(15),onPressed: (){}, icon: const Icon(Icons.send),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green),)),
                  const Padding(padding: EdgeInsets.all(10)),
                  IconButton(padding: const EdgeInsets.all(15), onPressed: (){}, icon: const Icon(Icons.cancel),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
