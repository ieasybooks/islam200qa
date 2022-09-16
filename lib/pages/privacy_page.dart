import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/constants.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    FlutterNativeSplash.remove();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Markdown(
        data: privacyPolicyMd,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
            .copyWith(textScaleFactor: 1.5),
      ),
    );
  }
}
