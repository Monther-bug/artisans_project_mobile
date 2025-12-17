import 'package:artisans_project_mobile/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SplashState { loading, authenticated, unauthenticated }

class SplashController extends AsyncNotifier<SplashState> {
  @override
  Future<SplashState> build() async {
    final minSplashDuration = Future.delayed(const Duration(seconds: 3));
    final firebaseInit = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Future.wait([minSplashDuration, firebaseInit]);

    final user = await FirebaseAuth.instance.authStateChanges().first;

    if (user != null) {
      return SplashState.authenticated;
    } else {
      return SplashState.unauthenticated;
    }
  }
}

final splashControllerProvider =
    AsyncNotifierProvider<SplashController, SplashState>(() {
      return SplashController();
    });
