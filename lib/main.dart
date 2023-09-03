import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'auth_gate.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase using the DefaultFirebaseOptions object exported by the configuration file:
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

// // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: const AuthGate(
          // camera: firstCamera,
          ),
      // HomePage(
      //   title: 'Robochef Demo Home Page',
      //   camera: firstCamera,
      // ),
    ),
  );
}

// class HomePage extends StatefulWidget {
//   const HomePage({
//     super.key,
//     required this.title,
//     required this.camera,
//   });

//   final String title;
//   final CameraDescription camera;

//   @override
//   State<HomePage> createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Placeholder: Sign up/in page',
//             ),
//             ElevatedButton(
//               child: const Text('Open camera'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ScannerPage(camera: widget.camera)),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
