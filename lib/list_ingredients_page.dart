import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'scanner_page.dart';
import 'list_recipes_page.dart';

class ListIngredientsPage extends StatefulWidget {
  final List resultData;
  final int resultLength;

  const ListIngredientsPage(
      {super.key, required this.resultData, required this.resultLength});

  @override
  ListIngredientsPageState createState() => ListIngredientsPageState();
}

class ListIngredientsPageState extends State<ListIngredientsPage> {
  bool floatExtended = false;
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  Future<void> setupCameras() async {
    // Obtain a list of the available cameras on the device.
    // cameras = await availableCameras();

    try {
      // initialize cameras.
      cameras = await availableCameras();

      // initialize camera controllers.
      cameraController = CameraController(cameras[0], ResolutionPreset.high);
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // call the function above to initialize the camera
    setupCameras();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Ingredient List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.resultLength,
              itemBuilder: (context, index) {
                debugPrint(index.toString());
                debugPrint(widget.resultLength.toString());
                debugPrint(widget.resultData[1]['ingredient_response'][index]
                    .toString());
                debugPrint(widget.resultData[0]['unique_id']);
                final img = widget.resultData[1]['ingredient_response'][index]
                    ['imgUrl'];
                return Card(
                  child: ListTile(
                    leading: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 50,
                        minHeight: 50,
                        maxWidth: 80,
                        maxHeight: 80,
                      ),
                      child: Image.network('$img'),
                    ),
                    title: Text(
                      widget.resultData[1]['ingredient_response'][index]
                          ['ingredientName'],
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      widget.resultData[1]['ingredient_response'][index]
                              ['count']
                          .toString(),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        fit: StackFit.expand,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: FloatingActionButton(
                  onPressed: () {
                    print("refresh");
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.refresh),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              SpeedDial(
                icon: Icons.keyboard_arrow_up,
                activeIcon: Icons.close,
                label: floatExtended
                    ? const Text("Open")
                    : null, // The label of the main button.
                /// The active label of the main button, Defaults to label if not specified.
                activeLabel: floatExtended ? const Text("Close") : null,
                spaceBetweenChildren: 15,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.cameraswitch),
                    label: 'Scan again',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    onTap: () async {
                      await availableCameras().then(
                        (cameras) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScannerPage(cameras: cameras),
                          ),
                        ),
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.menu_book),
                    label: 'Get Recipes',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final idToken = await user?.getIdTokenResult();
                      try {
                        final response = await http.get(
                          Uri.parse(
                              "https://veo3slmw0g.execute-api.us-west-2.amazonaws.com/Prod/"),
                          // Send authorization headers to the backend.
                          headers: {
                            HttpHeaders.authorizationHeader:
                                idToken!.token.toString(),
                            "unique_id": widget.resultData[0]['unique_id'],
                          },
                        );
                        final lambdaResponse = jsonDecode(response.body);
                        debugPrint(lambdaResponse.toString());
                        final int length = lambdaResponse.length;

                        if (length == 0) {
                          debugPrint(
                            "no result",
                          );
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListRecipesPage(
                                resultData: lambdaResponse,
                                resultLength: length,
                              ),
                            ),
                          );
                        }
                      } on Exception catch (_) {
                        rethrow;
                      }
                    },
                  ),
                ],
                isOpenOnStart: false,
              ),
            ],
          ),
        ],
      ),
      //
    );
  }
}
