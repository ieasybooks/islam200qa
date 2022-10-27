import 'package:flutter/material.dart';

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey indexKey;
  final GlobalKey bookmarkKey;

  const KeysToBeInherited({
    Key? key,
    required this.indexKey,
    required this.bookmarkKey,
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
