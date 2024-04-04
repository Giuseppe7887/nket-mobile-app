import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:nket/services/firebase/rtdb.dart';
import 'package:nket/shared.dart';

class Camera extends StatefulWidget {
  Camera({super.key, required this.cameraLabel,required this.item,required this.setReady});

  Widget cameraLabel;
  NketItem item;
  var setReady;

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
    initCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> initCamera() async {
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

    void testConnectivity() {
      var url = Uri.parse("http://192.168.208.114:8000");
      http.get(url).then((value) {
        print(value.body);
      }).catchError((err) {
        print(err.message);
      });
    }

    void manageProcessEnd(String status) {

      widget.setReady();
      if (status == "ok") {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
      }
    }

    void assignResearchToUser(String status, String message)async{

      RtDb().assignResearchToUser(itemId:widget.item.firebaseId).then((value) => null).then((value){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(message!),
                icon: Icon(
                    status == "ok" ? Icons.done : Icons.dangerous_sharp),
                iconColor: status == "ok" ? Colors.green : Colors.red,
                // content: Text(status == "ok" ? "you can start price research":"something gone wrong"),
                actions: [
                  TextButton(
                    onPressed: () => manageProcessEnd(status),
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }).catchError((err){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("error"),
                icon: const Icon(
                   Icons.dangerous_sharp),
                iconColor: Colors.red,
                // content: Text(status == "ok" ? "you can start price research":"something gone wrong"),
                actions: [
                  TextButton(
                    onPressed: ()=>Navigator.of(context).pop(),
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      });


      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text(message!),
      //         icon: Icon(
      //             status == "ok" ? Icons.done : Icons.dangerous_sharp),
      //         iconColor: status == "ok" ? Colors.green : Colors.red,
      //         // content: Text(status == "ok" ? "you can start price research":"something gone wrong"),
      //         actions: [
      //           TextButton(
      //             onPressed: () => manageProcessEnd(status),
      //             child: const Text('Ok'),
      //           ),
      //         ],
      //       );
      //     });
    }




    Future<void> debugRequest()async{
      Uri DEBUG_API = Uri.parse("https://faas-fra1-afec6ce7.doserverless.co/api/v1/web/fn-760378e2-baa1-4554-a8e9-6c984e8dc724/default/test-1");
      http.get(DEBUG_API).then((response){
        Map<String, dynamic> toJson = json.decode(response.body);

        String status = toJson["status"];
        String message = toJson["message"];

        assignResearchToUser(status,message);
      });
    }

    void sendVerification() async {
      var api = Uri.parse("http://192.168.208.114:8000/upload");

      // build request
      var request = http.MultipartRequest("POST", api);

      // attach file to request
      var multipartFile =
          await http.MultipartFile.fromPath("file", pictureTaken);
      request.files.add(multipartFile);

      request
          .send()
          .then((response) {
            response.stream.transform(utf8.decoder).listen((response) {
              Map<String, dynamic> toJson = json.decode(response);

              String status = toJson["status"];
              String message = toJson["message"];

              assignResearchToUser(status,message);



            });
          }).catchError((error) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("error"),
                    icon: const Icon(Icons.dangerous_sharp),
                    iconColor: Colors.red,
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                });
          });
    }

    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(15),
                      onPressed: debugRequest,
                      icon: const Icon(Icons.send),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      )),
                  IconButton(
                      padding: const EdgeInsets.all(15),
                      onPressed: () {
                        setState(() {
                          pictureTaken = "";
                          initCamera();
                        });
                      },
                      icon: const Icon(Icons.cancel),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ))
                ])
        ]));
  }
}
