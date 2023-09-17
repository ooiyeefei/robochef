import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return MaterialApp(
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
            ],
          );
        },
        '/home': (context) {
          return const HomeScreen(
            title: 'Robochef Demo Home Page',
          );
        },
      },
    );

    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return SignInScreen(
    //         actions: [
    //           ForgotPasswordAction((context, email) {
    //             Navigator.pushNamed(
    //               context,
    //               '/forgot-password',
    //               arguments: {'email': email},
    //             );
    //           }),
    //           AuthStateChangeAction((context, state) {
    //             final user = switch (state) {
    //               SignedIn(user: final user) => user,
    //               CredentialLinked(user: final user) => user,
    //               UserCreated(credential: final cred) => cred.user,
    //               _ => null,
    //             };

    //             switch (user) {
    //               case User(emailVerified: true):
    //                 Navigator.pushReplacementNamed(context, '/profile');
    //               case User(emailVerified: false, email: final String _):
    //                 Navigator.pushNamed(context, '/verify-email');
    //             }
    //           }),
    //         ],
    //         styles: const {
    //           EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
    //         },
    //         headerBuilder: (context, constraints, shrinkOffset) {
    //           return Padding(
    //             padding: const EdgeInsets.all(20),
    //             child: AspectRatio(
    //               aspectRatio: 1,
    //               child: Image.asset('flutterfire_300x.png'),
    //             ),
    //           );
    //         },
    //         sideBuilder: (context, shrinkOffset) {
    //           return Padding(
    //             padding: const EdgeInsets.all(20),
    //             child: AspectRatio(
    //               aspectRatio: 1,
    //               child: Image.asset('flutterfire_300x.png'),
    //             ),
    //           );
    //         },
    //         subtitleBuilder: (context, action) {
    //           final actionText = switch (action) {
    //             AuthAction.signIn => 'Please sign in to continue.',
    //             AuthAction.signUp => 'Please create an account to continue',
    //             _ => throw Exception('Invalid action: $action'),
    //           };

    //           return Padding(
    //             padding: const EdgeInsets.only(bottom: 8),
    //             child: Text('Welcome to Firebase UI! $actionText.'),
    //           );
    //         },
    //         footerBuilder: (context, action) {
    //           final actionText = switch (action) {
    //             AuthAction.signIn => 'signing in',
    //             AuthAction.signUp => 'registering',
    //             _ => throw Exception('Invalid action: $action'),
    //           };

    //           return Center(
    //             child: Padding(
    //               padding: const EdgeInsets.only(top: 16),
    //               child: Text(
    //                 'By $actionText, you agree to our terms and conditions.',
    //                 style: const TextStyle(color: Colors.grey),
    //               ),
    //             ),
    //           );
    //         },
    //       );
    //     }
    //     return const HomeScreen(
    //       title: 'Robochef Demo Home Page',
    //     );
    //   },
    // );
  }
}
