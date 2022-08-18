import 'package:flutter/material.dart';

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey indexKey;

  const KeysToBeInherited({
    Key? key,
    required this.indexKey,
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
