import 'package:flutter/material.dart';
import 'package:tasker/src/ui/widgets/adaptive_layout.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      compactLayout: TaskListScreenCompact(title: 'Tasks'),
      mediumLayout: TaskListScreenMedium(),
      expandedLayout: TaskListScreenExpanded(),
      largeLayout: TaskListScreenLarge(),
      extraLargeLayout: TaskListScreenExtraLarge(),
    );
  }
}

class TaskListScreenCompact extends StatefulWidget {
  const TaskListScreenCompact({super.key, required this.title});

  final String title;

  @override
  State<TaskListScreenCompact> createState() => _TaskListScreenCompactState();
}

class _TaskListScreenCompactState extends State<TaskListScreenCompact> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TaskListScreenMedium extends StatelessWidget {
  const TaskListScreenMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TaskListScreenExpanded extends StatelessWidget {
  const TaskListScreenExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TaskListScreenLarge extends StatelessWidget {
  const TaskListScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TaskListScreenExtraLarge extends StatelessWidget {
  const TaskListScreenExtraLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
