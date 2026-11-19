import 'package:flutter/material.dart';

// SectionPage sets bookmarkKey while it builds, for the guided tour, so the
// widget isn't immutable.
// ignore: must_be_immutable
class KeysToBeInherited extends InheritedWidget {
  final GlobalKey indexKey;
  GlobalKey? bookmarkKey;

  KeysToBeInherited({
    Key? key,
    required this.indexKey,
    this.bookmarkKey,
    required Widget child,
  }) : super(key: key, child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
