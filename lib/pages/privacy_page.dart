import 'package:flutter/material.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/widgets/info_page.dart';

/// The privacy policy in Arabic, at /privacy.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.privacy, language: InfoLanguage.ar);
  }
}

/// The privacy policy in English, at /en/privacy.
class EnglishPrivacyPage extends StatelessWidget {
  const EnglishPrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.privacy, language: InfoLanguage.en);
  }
}
