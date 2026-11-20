import 'package:flutter/material.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/widgets/info_page.dart';

/// The terms of use in Arabic, at /terms.
class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.terms, language: InfoLanguage.ar);
  }
}

/// The terms of use in English, at /en/terms.
class EnglishTermsPage extends StatelessWidget {
  const EnglishTermsPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(page: InfoPageId.terms, language: InfoLanguage.en);
  }
}
