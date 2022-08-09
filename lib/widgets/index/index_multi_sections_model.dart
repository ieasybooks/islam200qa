import 'package:islam200qa/widgets/index/index_section_model.dart';

class IndexMultiSectionsModel extends IndexSectionModel {
  IndexMultiSectionsModel({
    required this.title,
    required this.startSection,
    required this.endSection,
  }) : super() {
    if (startSection > endSection) {
      throw ArgumentError('startSection field should be less than or equal to endSection field.');
    }
  }

  final String title;
  final int startSection;
  final int endSection;
}
