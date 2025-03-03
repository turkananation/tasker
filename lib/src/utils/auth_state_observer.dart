import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateObserver {
  final BuildContext context;

  AuthStateObserver(this.context);

  StreamSubscription<User?>? _authStateSubscription;

  void startObservingAuthState() {
    // Cancel any existing subscription before creating a new one.
    _authStateSubscription?.cancel();

    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      _handleAuthStateChange(user);
    });
  }

  void _handleAuthStateChange(User? user) async {
    if (user == null) {
      _showSignOutBanner();
      await Future.delayed(const Duration(seconds: 4));
      _removeSignOutBannerAndNavigate();
    }
  }

  void _showSignOutBanner() {
    // Ensure context is still valid before using it.
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        elevation: 8,
        contentTextStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.all(5),
        content: const Text('You are being signed out!'),
        leading: const CircularProgressIndicator(color: Colors.white),
        backgroundColor: Colors.black,
        actions: <Widget>[
          TextButton(onPressed: null, child: const Text('Please Wait..')),
        ],
      ),
    );
  }

  void _removeSignOutBannerAndNavigate() {
    // Ensure context is still valid before using it.
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    Navigator.popAndPushNamed(context, '/');
  }

  void stopObservingAuthState() {
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
  }
}
