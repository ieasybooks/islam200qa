import 'package:flutter_test/flutter_test.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/widgets/index/index_multi_sections_model.dart';
import 'package:islam200qa/widgets/index/index_section_model.dart';
import 'package:islam200qa/widgets/index/index_sections_combiner_model.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';

void main() {
  List<int> getIndexSectionModelSections(
    final IndexSectionModel indexSectionModel,
  ) {
    List<int> result = [];

    if (indexSectionModel is IndexSingleSectionModel) {
      result.add(indexSectionModel.sectionId);
    } else if (indexSectionModel is IndexMultiSectionsModel) {
      for (int i = indexSectionModel.startSection;
          i <= indexSectionModel.endSection;
          ++i) {
        result.add(i);
      }
    } else if (indexSectionModel is IndexSectionsCombinerModel) {
      for (var element in indexSectionModel.children) {
        result.addAll(getIndexSectionModelSections(element));
      }
    }

    return result;
  }

  test(
    'index contains all sections',
    () {
      List<int> indexSections = index
          .map(getIndexSectionModelSections)
          .expand((element) => element)
          .toList();

      for (int i = 1; i <= lastSection; ++i) {
        expect(i, indexSections[i - 1]);
      }
    },
  );
}
