import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/src/ui/screens/home_screen.dart';
import 'package:tasker/src/ui/screens/settings_screen.dart';
import 'package:tasker/src/ui/screens/task_screen.dart';
import 'package:tasker/src/ui/themes/tasker_colors.dart';
import 'package:tasker/src/utils/auth_state_observer.dart';

class TaskerScreen extends StatefulWidget {
  const TaskerScreen({super.key, required this.title});

  final String title;

  @override
  State<TaskerScreen> createState() => _TaskerScreenState();
}

class _TaskerScreenState extends State<TaskerScreen> {
  late AuthStateObserver _authStateObserver;
  int _selectedBottomBarScreen = 0;
  int _selectedDrawerScreen = 0;
  bool _updatedByDrawer = false;

  final List<Widget> _listOfBottomNavBarScreens = [
    HomeScreen(),
    TaskScreen(),
    ProfileScreen(),
  ];

  final List<Widget> _listOfDrawerScreens = [SettingsScreen()];

  final List<NavigationDestination> _destinations = [
    NavigationDestination(
      label: 'Home',
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home_rounded),
    ),
    NavigationDestination(
      label: 'Tasks',
      icon: const Icon(Icons.task_outlined),
      selectedIcon: const Icon(Icons.task_rounded),
    ),
    NavigationDestination(
      label: 'Account',
      icon: const Icon(Icons.account_box_outlined),
      selectedIcon: const Icon(Icons.account_box_rounded),
    ),
  ];

  Widget _buildBody(bool updatedByDrawer) {
    if (updatedByDrawer) {
      return _listOfDrawerScreens[_selectedDrawerScreen];
    } else {
      return _listOfBottomNavBarScreens[_selectedBottomBarScreen];
    }
  }

  @override
  void initState() {
    super.initState();
    _authStateObserver = AuthStateObserver(context);
    _authStateObserver.startObservingAuthState();
  }

  @override
  void dispose() {
    _authStateObserver.stopObservingAuthState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        exit(0);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        drawer: NavigationDrawer(
          elevation: 8,
          selectedIndex: _selectedDrawerScreen,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedDrawerScreen = index;
              _updatedByDrawer = true;
            });
            Navigator.pop(context);
          },
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: TaskerColors.backgroundDark),
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              currentAccountPicture: UserAvatar(
                size: 75,
                auth: FirebaseAuth.instance,
                placeholderColor: Colors.grey,
              ),
            ),
            NavigationDrawerDestination(
              label: Text("Settings"),
              icon: Icon(Icons.settings_display_outlined),
              selectedIcon: Icon(Icons.settings_display_rounded),
            ),
          ],
        ),
        body: _buildBody(_updatedByDrawer),
        bottomNavigationBar: NavigationBar(
          elevation: 8.0,
          selectedIndex: _selectedBottomBarScreen,
          destinations: _destinations,
          onDestinationSelected: (index) {
            setState(() {
              _selectedBottomBarScreen = index;
              _updatedByDrawer = false;
            });
          },
        ),
      ),
    );
  }
}
