import 'package:flutter/material.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/widgets/index/index_multi_sections.dart';
import 'package:islam200qa/widgets/index/index_multi_sections_model.dart';
import 'package:islam200qa/widgets/index/index_section_model.dart';
import 'package:islam200qa/widgets/index/index_sections_combiner.dart';
import 'package:islam200qa/widgets/index/index_sections_combiner_model.dart';
import 'package:islam200qa/widgets/index/index_single_section.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';

Widget? indexWidgetFactory(
  final IndexSectionModel indexSectionModel, {
  final double rightPadding = indexBasePadding,
}) {
  if (indexSectionModel is IndexSingleSectionModel) {
    return IndexSingleSection(
      indexSingleSectionModel: indexSectionModel,
      rightPadding: rightPadding,
    );
  } else if (indexSectionModel is IndexMultiSectionsModel) {
    return IndexMultiSections(
      indexMultiSectionsModel: indexSectionModel,
      rightPadding: rightPadding,
    );
  } else if (indexSectionModel is IndexSectionsCombinerModel) {
    return IndexSectionsCombiner(
      indexSectionsCombiner: indexSectionModel,
      rightPadding: rightPadding,
    );
  }

  return null;
}
