import 'package:flutter/material.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/widgets/info_page.dart';

/// Contact and support in Arabic, at /support.
class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.support, language: InfoLanguage.ar);
  }
}

/// Contact and support in English, at /en/support.
class EnglishSupportPage extends StatelessWidget {
  const EnglishSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.support, language: InfoLanguage.en);
  }
}
