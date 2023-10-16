import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:robochef/no_result.dart';
import 'scanner_page.dart';
import 'nav_bar.dart';
import 'scanner_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'auth_gate.dart';
import 'list_recipes_page.dart';
import 'no_result.dart';

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
  // int currentPageIndex = 0;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  final providers = [EmailAuthProvider()];

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
                  const Text(
                    "Welcome to Robochef! 🤖 \n",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Click the button below to start scanning and \n get creative cookin' 🧑‍🍳👨‍🍳 \n",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    child: const Text('Start scanning'),
                    onPressed: () async {
                      await availableCameras().then(
                        (cameras) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScannerPage(cameras: cameras))),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
