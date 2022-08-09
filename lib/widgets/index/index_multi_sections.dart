import 'package:flutter/material.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/widgets/index/index_multi_sections_model.dart';
import 'package:islam200qa/widgets/index/index_single_section.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';

class IndexMultiSections extends StatefulWidget {
  const IndexMultiSections({
    Key? key,
    required this.indexMultiSectionsModel,
    required this.rightPadding,
  }) : super(key: key);

  final IndexMultiSectionsModel indexMultiSectionsModel;
  final double rightPadding;

  @override
  State<IndexMultiSections> createState() => _IndexMultiSectionsState();
}

class _IndexMultiSectionsState extends State<IndexMultiSections> {
  Icon _tileIcon = const Icon(Icons.keyboard_arrow_left_outlined);

  @override
  Widget build(final BuildContext context) {
    List<Widget> expansionTileChildren = [];

    for (int i = widget.indexMultiSectionsModel.startSection;
        i <= widget.indexMultiSectionsModel.endSection;
        ++i) {
      expansionTileChildren.add(
        IndexSingleSection(
          indexSingleSectionModel: IndexSingleSectionModel(sectionId: i),
          rightPadding: widget.rightPadding + indexBasePadding,
        ),
      );
    }

    return ExpansionTile(
      title: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(child: _tileIcon),
            TextSpan(text: widget.indexMultiSectionsModel.title),
          ],
        ),
      ),
      tilePadding: EdgeInsets.only(
        right: widget.rightPadding - indexBasePadding / 2,
      ),
      trailing: const SizedBox.shrink(),
      onExpansionChanged: (expanded) {
        setState(
          () {
            if (expanded) {
              _tileIcon = const Icon(Icons.keyboard_arrow_down_outlined);
            } else {
              _tileIcon = const Icon(Icons.keyboard_arrow_left_outlined);
            }
          },
        );
      },
      children: expansionTileChildren,
    );
  }
}
