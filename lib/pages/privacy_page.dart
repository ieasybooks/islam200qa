import 'package:flutter/material.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/widgets/info_page.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return const InfoPage(texts: privacyTexts);
  }
}
