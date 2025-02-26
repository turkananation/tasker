import 'package:flutter/material.dart';
import 'package:tasker/src/ui/widgets/adaptive_layout.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      compact: AboutScreenCompact(),
      medium: AboutScreenMedium(),
      expanded: AboutScreenExpanded(),
      large: AboutScreenLarge(),
      extraLarge: AboutScreenExtraLarge(),
    );
  }
}

class AboutScreenCompact extends StatelessWidget {
  const AboutScreenCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('About Screen')],
      ),
    );
  }
}

class AboutScreenMedium extends StatelessWidget {
  const AboutScreenMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AboutScreenExpanded extends StatelessWidget {
  const AboutScreenExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AboutScreenLarge extends StatelessWidget {
  const AboutScreenLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AboutScreenExtraLarge extends StatelessWidget {
  const AboutScreenExtraLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
