import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

Future<List<String>> getSectionParagraphs(final int sectionId) async {
  final String filePath = sprintf('data/sections/%d.txt', [sectionId]);
  return await rootBundle
      .loadString(filePath)
      .then((section) => section.split('\n'));
}
