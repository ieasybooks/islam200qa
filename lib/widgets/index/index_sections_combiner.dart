import 'package:flutter/material.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/widgets/index/index_sections_combiner_model.dart';
import 'package:islam200qa/widgets/index/index_widgets_factory.dart';

class IndexSectionsCombiner extends StatefulWidget {
  const IndexSectionsCombiner({
    Key? key,
    required this.indexSectionsCombiner,
    required this.rightPadding,
  }) : super(key: key);

  final IndexSectionsCombinerModel indexSectionsCombiner;
  final double rightPadding;

  @override
  State<IndexSectionsCombiner> createState() => _IndexSectionsCombinerState();
}

class _IndexSectionsCombinerState extends State<IndexSectionsCombiner> {
  Icon _tileIcon = const Icon(Icons.keyboard_arrow_left_outlined);

  @override
  Widget build(final BuildContext context) {
    return ExpansionTile(
      title: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(child: _tileIcon),
            TextSpan(text: widget.indexSectionsCombiner.title),
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
      children: widget.indexSectionsCombiner.children.map<Widget>(
        (indexSectionModel) {
          return indexWidgetFactory(
            indexSectionModel,
            rightPadding: widget.rightPadding + indexBasePadding,
          )!;
        },
      ).toList(),
    );
  }
}
