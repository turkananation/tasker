import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tasker/firebase_options.dart';
import 'package:tasker/src/ui/screens/tasker_screen.dart';
import 'package:tasker/src/ui/widgets/decorations.dart';
import 'package:tasker/src/utils/constants.dart';

final actionCodeSettings = ActionCodeSettings(
  url: Constants.firebaseAppUrl,
  handleCodeInApp: true,
  androidMinimumVersion: '26',
  androidPackageName: Constants.appID,
  iOSBundleId: Constants.appID,
);

final emailLinkProviderConfig = EmailLinkAuthProvider(
  actionCodeSettings: actionCodeSettings,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: Constants.googleClientID),
    //emailLinkProviderConfig,
    //PhoneAuthProvider(),
    //AppleProvider(),
    //FacebookProvider(clientId: Constants.facebookClientID),
  ]);

  runApp(const TaskerApp());
}

class TaskerApp extends StatelessWidget {
  const TaskerApp({super.key});

  String get initialRoute {
    final user = FirebaseAuth.instance.currentUser;

    return switch (user) {
      null => '/',
      User(emailVerified: false, email: final String _) => '/verify-email',
      _ => '/tasker',
    };
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthStateChangeAction<MFARequired> mfaAction = AuthStateChangeAction<
      MFARequired
    >((BuildContext context, MFARequired state) async {
      final NavigatorState nav = Navigator.of(context);

      await startMFAVerification(resolver: state.resolver, context: context);

      nav.pushReplacementNamed('/profile');
    });

    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: kDebugMode ? true : false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction((context, email) {
                Navigator.pushNamed(
                  context,
                  '/forgot-password',
                  arguments: {'email': email},
                );
              }),
              VerifyPhoneAction((context, _) {
                Navigator.pushNamed(context, '/phone');
              }),
              AuthStateChangeAction((context, state) {
                final user = switch (state) {
                  SignedIn(user: final user) => user,
                  CredentialLinked(user: final user) => user,
                  UserCreated(credential: final cred) => cred.user,
                  _ => null,
                };

                switch (user) {
                  case User(emailVerified: true):
                    Navigator.popAndPushNamed(context, '/tasker');
                  case User(emailVerified: false, email: final String _):
                    Navigator.pushNamed(context, '/verify-email');
                }
              }),
              mfaAction,
              EmailLinkSignInAction((context) {
                Navigator.pushReplacementNamed(context, '/email-link-sign-in');
              }),
            ],
            styles: const {
              EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
            },
            headerBuilder: headerImage('assets/images/tasker_logo.jpg'),
            sideBuilder: sideImage('assets/images/tasker_logo.jpg'),
            subtitleBuilder: (context, action) {
              final actionText = switch (action) {
                AuthAction.signIn => 'Please sign in to continue.',
                AuthAction.signUp => 'Please create an account to continue',
                _ => throw Exception('Invalid action: $action'),
              };

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Welcome to Tasker! $actionText.'),
              );
            },
            footerBuilder: (context, action) {
              final actionText = switch (action) {
                AuthAction.signIn => 'signing in',
                AuthAction.signUp => 'registering',
                _ => throw Exception('Invalid action: $action'),
              };

              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'By $actionText, you agree to our terms and conditions.',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
        '/verify-email': (context) {
          return EmailVerificationScreen(
            headerBuilder: headerIcon(Icons.verified),
            sideBuilder: sideIcon(Icons.verified),
            actionCodeSettings: actionCodeSettings,
            actions: [
              EmailVerifiedAction(() {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
              AuthCancelledAction((context) {
                FirebaseUIAuth.signOut(context: context);
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
          );
        },
        '/phone': (context) {
          return PhoneInputScreen(
            actions: [
              SMSCodeRequestedAction((context, action, flowKey, phone) {
                Navigator.of(context).pushReplacementNamed(
                  '/sms',
                  arguments: {
                    'action': action,
                    'flowKey': flowKey,
                    'phone': phone,
                  },
                );
              }),
            ],
            headerBuilder: headerIcon(Icons.phone),
            sideBuilder: sideIcon(Icons.phone),
          );
        },
        '/sms': (context) {
          final arguments =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          return SMSCodeInputScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.of(context).pushReplacementNamed('/profile');
              }),
            ],
            flowKey: arguments?['flowKey'],
            action: arguments?['action'],
            headerBuilder: headerIcon(Icons.sms_outlined),
            sideBuilder: sideIcon(Icons.sms_outlined),
          );
        },
        '/forgot-password': (context) {
          final arguments =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
            headerBuilder: headerIcon(Icons.lock),
            sideBuilder: sideIcon(Icons.lock),
          );
        },
        '/email-link-sign-in': (context) {
          return EmailLinkSignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
            provider: emailLinkProviderConfig,
            headerMaxExtent: 200,
            headerBuilder: headerIcon(Icons.link),
            sideBuilder: sideIcon(Icons.link),
          );
        },
        '/profile': (context) {
          final platform = Theme.of(context).platform;

          return ProfileScreen(
            actions: [
              SignedOutAction((context) {
                FirebaseUIAuth.signOut(
                  context: context,
                  auth: FirebaseAuth.instance,
                );
              }),
              mfaAction,
            ],
            actionCodeSettings: actionCodeSettings,
            showMFATile:
                kIsWeb ||
                platform == TargetPlatform.iOS ||
                platform == TargetPlatform.android,
            showUnlinkConfirmationDialog: true,
            showDeleteConfirmationDialog: true,
          );
        },
        '/tasker': (context) {
          return TaskerScreen(title: 'Tasker');
        },
      },
    );
  }
}
