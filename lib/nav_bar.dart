import 'package:flutter/material.dart';
import 'package:robochef/home.dart';
import 'package:robochef/scanner_page.dart';
import 'package:camera/camera.dart';

int currentPageIndex = 0;

class NavBar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const NavBar({super.key, required this.navigatorKey});

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  late List<CameraDescription> cameras;

  Future<void> camera() async {
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
        switch (index) {
          case 0:
            widget.navigatorKey.currentState?.pushReplacementNamed("Home");
            break;
          // case 1:
          //   widget.navigatorKey.currentState?.pushReplacementNamed("Scan");
          //   break;
          // case 1:
          //   widget.navigatorKey.currentState?.pushReplacementNamed("Recipe");
          //   break;
          case 1:
            widget.navigatorKey.currentState?.pushReplacementNamed("Account");
            break;
        }
      },
      indicatorColor: Colors.amber[800],
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home,
          ),
          icon: Icon(
            Icons.home_outlined,
          ),
          label: 'Home',
        ),
        // NavigationDestination(
        //   selectedIcon: Icon(
        //     Icons.library_books,
        //   ),
        //   icon: Icon(
        //     Icons.library_books_outlined,
        //   ),
        //   label: 'Recipe',
        // ),
        // NavigationDestination(
        //   selectedIcon: Icon(Icons.camera_alt),
        //   icon: Icon(Icons.camera_alt),
        //   label: 'Scan',
        // ),
        NavigationDestination(
            selectedIcon: Icon(
              Icons.manage_accounts,
            ),
            icon: Icon(
              Icons.manage_accounts_outlined,
            ),
            label: 'Account')
      ],
    );
  }
}
