import 'package:flutter/material.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/widgets/info_page.dart';

/// About in Arabic, at /about.
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.about, language: InfoLanguage.ar);
  }
}

/// About in English, at /en/about.
class EnglishAboutPage extends StatelessWidget {
  const EnglishAboutPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.about, language: InfoLanguage.en);
  }
}
