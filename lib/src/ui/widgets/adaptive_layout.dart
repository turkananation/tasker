import 'package:flutter/material.dart';

/* A widget that adapts its layout based on the available screen width. This
 widget conforms to the material design guidelines for responsive layouts as
 found here https://m3.material.io/foundations/layout/understanding-layout/overview.

 This widget also follows the advice and recommendations of building
 adaptive and responsive app using Flutter as explained in the talk
 here https://www.youtube.com/watch?v=LeKLGzpsz9I&t=99s. */

class AdaptiveLayout extends StatelessWidget {
  /// The widget to display on compact screens (width < 600).
  final Widget compact;

  /// The widget to display on medium screens (600 <= width < 840).
  final Widget medium;

  /// The widget to display on expanded screens (840 <= width < 1200).
  final Widget expanded;

  /// The widget to display on large screens (1200 <= width < 1600).
  final Widget large;

  /// The widget to display on extra-large screens (width >= 1600).
  final Widget extraLarge;

  /// Creates an [AdaptiveLayout] widget.
  const AdaptiveLayout({
    super.key,
    required this.compact,
    required this.medium,
    required this.expanded,
    required this.large,
    required this.extraLarge,
  });

  /// Checks if the current screen width is considered compact (< 600).
  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// Checks if the current screen width is considered medium (600 <= width < 840).
  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 840;

  /// Checks if the current screen width is considered expanded (840 <= width < 1200).
  static bool isExpanded(BuildContext context) =>
      MediaQuery.of(context).size.width >= 840 &&
      MediaQuery.of(context).size.width < 1200;

  /// Checks if the current screen width is considered large (1200 <= width < 1600).
  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200 &&
      MediaQuery.of(context).size.width < 1600;

  /// Checks if the current screen width is considered extra-large (width >= 1600).
  static bool isExtraLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1600;

  /// Returns the appropriate widget based on the current screen width.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1600) {
          return extraLarge;
        } else if (constraints.maxWidth >= 1200) {
          return large;
        } else if (constraints.maxWidth >= 840) {
          return expanded;
        } else if (constraints.maxWidth >= 600) {
          return medium;
        } else {
          return compact;
        }
      },
    );
  }
}
