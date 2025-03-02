import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/src/ui/screens/about_screen.dart';
import 'package:tasker/src/ui/screens/home_screen.dart';
import 'package:tasker/src/ui/screens/task_list_screen.dart';
import 'package:tasker/src/ui/widgets/adaptive_layout.dart';
import 'package:tasker/src/utils/auth_state_observer.dart';

class TaskerScreen extends StatelessWidget {
  const TaskerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      compactLayout: TaskerScreenCompact(title: 'Tasker'),
      mediumLayout: TaskerScreenMedium(title: 'Tasker'),
      expandedLayout: TaskerScreenExpanded(title: 'Tasker'),
      largeLayout: TaskerScreenLarge(title: 'Tasker'),
      extraLargeLayout: TaskerScreenExtraLarge(title: 'Tasker'),
    );
  }
}

class TaskerScreenCompact extends StatefulWidget {
  const TaskerScreenCompact({super.key, required this.title});

  final String title;

  @override
  State<TaskerScreenCompact> createState() => _TaskerScreenCompactState();
}

class _TaskerScreenCompactState extends State<TaskerScreenCompact> {
  late AuthStateObserver _authStateObserver;
  int _selectedBottomBarScreen = 0;
  int _selectedDrawerScreen = 0;
  bool _updatedByDrawer = false;

  final List<Widget> _listOfBottomNavBarScreens = [
    HomeScreen(),
    TaskListScreenCompact(title: 'Tasks'),
    ProfileScreen(),
  ];

  final List<Widget> _listOfDrawerScreens = [Placeholder(), AboutScreen()];

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
            decoration: BoxDecoration(color: Colors.blue),
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
          NavigationDrawerDestination(
            label: Text("About App"),
            icon: Icon(Icons.help_center_outlined),
            selectedIcon: Icon(Icons.help_center_rounded),
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
    );
  }
}

class TaskerScreenMedium extends StatefulWidget {
  const TaskerScreenMedium({super.key, required this.title});

  final String title;

  @override
  State<TaskerScreenMedium> createState() => _TaskerScreenMediumState();
}

class _TaskerScreenMediumState extends State<TaskerScreenMedium> {
  int _selectedIndex = 0;

  final List<Widget> _listOfDestinationScreens = [
    HomeScreen(),
    TaskListScreenCompact(title: 'Tasks'),
    ProfileScreen(),
  ];

  final List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.task_outlined),
      selectedIcon: Icon(Icons.task_rounded),
      label: Text('Tasks'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_box_outlined),
      selectedIcon: Icon(Icons.account_box_rounded),
      label: Text('Account'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              elevation: 8.0,
              destinations: _destinations,
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              useIndicator: true,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const VerticalDivider(thickness: 1, width: 2),
            Expanded(child: _listOfDestinationScreens[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class TaskerScreenExpanded extends StatefulWidget {
  const TaskerScreenExpanded({super.key, required this.title});

  final String title;

  @override
  State<TaskerScreenExpanded> createState() => _TaskerScreenExpandedState();
}

class _TaskerScreenExpandedState extends State<TaskerScreenExpanded> {
  int _selectedIndex = 0;

  final List<Widget> _listOfDestinationScreens = [
    HomeScreen(),
    TaskListScreenCompact(title: 'Tasks'),
    ProfileScreen(),
  ];

  final List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.task_outlined),
      selectedIcon: Icon(Icons.task_rounded),
      label: Text('Tasks'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_box_outlined),
      selectedIcon: Icon(Icons.account_box_rounded),
      label: Text('Account'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              elevation: 8.0,
              destinations: _destinations,
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              useIndicator: true,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const VerticalDivider(thickness: 1, width: 2),
            Expanded(child: _listOfDestinationScreens[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class TaskerScreenLarge extends StatefulWidget {
  const TaskerScreenLarge({super.key, required this.title});

  final String title;

  @override
  State<TaskerScreenLarge> createState() => _TaskerScreenLargeState();
}

class _TaskerScreenLargeState extends State<TaskerScreenLarge> {
  int _selectedIndex = 0;

  final List<Widget> _listOfDestinationScreens = [
    HomeScreen(),
    TaskListScreenCompact(title: 'Tasks'),
    ProfileScreen(),
  ];

  final List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.task_outlined),
      selectedIcon: Icon(Icons.task_rounded),
      label: Text('Tasks'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_box_outlined),
      selectedIcon: Icon(Icons.account_box_rounded),
      label: Text('Account'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              elevation: 8.0,
              destinations: _destinations,
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              useIndicator: true,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const VerticalDivider(thickness: 1, width: 2),
            Expanded(child: _listOfDestinationScreens[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class TaskerScreenExtraLarge extends StatefulWidget {
  const TaskerScreenExtraLarge({super.key, required this.title});

  final String title;

  @override
  State<TaskerScreenExtraLarge> createState() => _TaskerScreenExtraLargeState();
}

class _TaskerScreenExtraLargeState extends State<TaskerScreenExtraLarge> {
  int _selectedIndex = 0;

  final List<Widget> _listOfDestinationScreens = [
    HomeScreen(),
    TaskListScreenCompact(title: 'Tasks'),
    ProfileScreen(),
  ];

  final List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.task_outlined),
      selectedIcon: Icon(Icons.task_rounded),
      label: Text('Tasks'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_box_outlined),
      selectedIcon: Icon(Icons.account_box_rounded),
      label: Text('Account'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              elevation: 8.0,
              destinations: _destinations,
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              useIndicator: true,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const VerticalDivider(thickness: 1, width: 2),
            Expanded(child: _listOfDestinationScreens[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
