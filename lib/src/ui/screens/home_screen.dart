import 'package:flutter/material.dart';
import 'package:tasker/src/ui/widgets/adaptive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      compactLayout: HomeScreenCompact(),
      mediumLayout: HomeScreenMedium(),
      expandedLayout: HomeScreenExpanded(),
      largeLayout: HomeScreenLarge(),
      extraLargeLayout: HomeScreenExtraLarge(),
    );
  }
}

class HomeScreenCompact extends StatelessWidget {
  const HomeScreenCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomeScreenMedium extends StatelessWidget {
  const HomeScreenMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomeScreenExpanded extends StatelessWidget {
  const HomeScreenExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomeScreenLarge extends StatelessWidget {
  const HomeScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HomeScreenExtraLarge extends StatelessWidget {
  const HomeScreenExtraLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
