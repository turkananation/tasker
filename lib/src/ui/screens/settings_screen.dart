import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/src/data/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SwitchListTile(
        title: Text('Dark Mode'),
        value: Provider.of<ThemeProvider>(context).isDarkMode,
        onChanged: (value) {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
      ),
    );
  }
}
