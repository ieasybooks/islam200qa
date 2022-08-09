import 'package:islam200qa/widgets/index/index_section_model.dart';

class IndexSectionsCombinerModel extends IndexSectionModel {
  const IndexSectionsCombinerModel({
    required this.title,
    required this.children,
  }) : super();

  final String title;
  final List<IndexSectionModel> children;
}
