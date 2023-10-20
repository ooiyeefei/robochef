import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'nav_bar.dart';
import 'no_result.dart';
import 'display_image_upload.dart';
import 'auth_gate.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({
    super.key,
    required this.title,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // late List<CameraDescription> cameras;
  // late CameraController cameraController;
  bool floatExtended = false;

  File? image;

  Future<bool> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) {
        return false;
      } else {
        setState(() => this.image = File(image.path));
        debugPrint(image.path);
        return true;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      rethrow;
    }
  }

  Future<bool> pickImageCamera() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) {
        return false;
      } else {
        setState(() => this.image = File(image.path));
        debugPrint(image.path);
        return true;
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      rethrow;
    }
  }

  final providers = [EmailAuthProvider()];

  // Future<void> setupCameras() async {
  //   // Obtain a list of the available cameras on the device.
  //   // cameras = await availableCameras();

  //   try {
  //     // initialize cameras.
  //     cameras = await availableCameras();

  //     // initialize camera controllers.
  //     cameraController = CameraController(cameras[0], ResolutionPreset.high);
  //     await cameraController.initialize();
  //   } on CameraException catch (e) {
  //     debugPrint("camera error $e");
  //   }
  //   if (!mounted) return;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // call the function above to initialize the camera
    // setupCameras();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: SizedBox(
        height: (MediaQuery.sizeOf(context).height) * 0.08,
        child: NavBar(navigatorKey: navigatorKey),
      ),
      body: Navigator(
        key: navigatorKey,
        onGenerateRoute: generateRoute,
      ),
      floatingActionButton: SpeedDial(
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
              child: const Icon(Icons.image),
              label: 'Select from gallery',
              labelStyle: const TextStyle(
                fontSize: 18,
              ),
              onTap: () async {
                if (await pickImage()) {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        // Pass the automatically generated path to
                        // the DisplayPictureScreen widget.
                        imagePath: image!.path,
                      ),
                    ),
                  );
                } else {
                  const Text("No image selected");
                }
              }),
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            label: 'Take a photo',
            labelStyle: const TextStyle(
              fontSize: 18,
            ),
            onTap: () async {
              if (await pickImageCamera()) {
                debugPrint('goes to image pages');
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image!.path,
                    ),
                  ),
                );
              } else {
                const Text("No image selected");
              }
            },
          ),
        ],
        isOpenOnStart: false,
      ),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Account":
        return MaterialPageRoute(
          builder: (context) {
            return ProfileScreen(
              providers: providers,
              actions: [
                SignedOutAction((context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthGate(),
                    ),
                  );
                }),
              ],
            );
          },
        );
      case "Recipe":
        return MaterialPageRoute(
          builder: (context) {
            return const NoResultScreen();
          },
        );
      // case "Scan":
      // return FutureBuilder<Widget>(
      //   future: _initializeControllerFuture,
      //   builder: (context, AsyncSnapshot<void> snapshot) {
      //     if (snapshot.hasData) {
      //       return MaterialPageRoute(
      //         builder: (context) async => ScannerPage(cameras: cameras),
      //       );
      //     } else {
      //       return CircularProgressIndicator();
      //     }
      //   },
      // );
      // setupCameras();
      // return MaterialPageRoute(builder: (context) {
      //   return ScannerPage(cameras: cameras);
      // });
      default: // default to home page
        return MaterialPageRoute(
          builder: (context) => Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/robochef_flutter.png'),
                  const Text(
                    "Welcome! 🤖 \n",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Click the button below to start scanning \n and get creative cookin' 🧑‍🍳👨‍🍳 \n",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  // ElevatedButton(
                  //   child: const Text('Start scanning'),
                  //   onPressed: () async {
                  //     await availableCameras().then(
                  //       (cameras) => Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   ScannerPage(cameras: cameras))),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
