import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islam200qa/routes.gr.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/footnotes_card.dart';
import 'package:islam200qa/widgets/paragraph_card.dart';
import 'package:islam200qa/widgets/title_card.dart';
import 'package:sprintf/sprintf.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({Key? key, @pathParam required this.sectionId})
      : super(key: key);

  final int sectionId;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  final List<Widget> _content = [];

  Future<List<String>> _getSectionParagraphs(final int sectionId) async {
    final String filePath = sprintf('data/sections/%d.txt', [sectionId]);
    return await rootBundle
        .loadString(filePath)
        .then((section) => section.split('\n'));
  }

  Widget _getPreviousButton(final int sectionId) {
    var onPressCallback;

    if (sectionId - 1 >= 1) {
      onPressCallback = () {
        AutoRouter.of(context).push(SectionRoute(sectionId: sectionId - 1));
      };
    }

    return ElevatedButton(
      onPressed: onPressCallback,
      child: const Text('السابق'),
    );
  }

  Widget _getNextButton(final int sectionId) {
    var onPressCallback;

    if (sectionId + 1 <= lastSection) {
      onPressCallback = () {
        AutoRouter.of(context).push(SectionRoute(sectionId: sectionId + 1));
      };
    }

    return ElevatedButton(
      onPressed: onPressCallback,
      child: const Text('التالي'),
    );
  }

  Widget _getPreviousNextButtonsRow(final int sectionId) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: _getPreviousButton(sectionId),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              sprintf('%s/%s', [
                arabizeNumbers(lastSection.toString()),
                arabizeNumbers(sectionId.toString()),
              ]),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: _getNextButton(sectionId),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  void _loadSection(final int sectionId) {
    _getSectionParagraphs(sectionId).then(
      (paragraphs) {
        _content.clear();

        _content.add(_getPreviousNextButtonsRow(sectionId));

        _content.add(TitleCard(paragraph: paragraphs[0]));

        bool isParagraph = true;
        List<String> footnotes = [];
        paragraphs.skip(1).forEach(
          (paragraph) {
            if (paragraph.isEmpty) {
              isParagraph = false;
            } else if (isParagraph) {
              _content.add(ParagraphCard(paragraph: paragraph));
            } else {
              footnotes.add(paragraph);
            }
          },
        );

        if (footnotes.isNotEmpty) {
          _content.add(const SizedBox(height: 10));
          _content.add(FootnotesCard(footnotes: footnotes));
        }

        _content.add(const SizedBox(height: 10));

        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSection(widget.sectionId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPaddingPercentage =
        getHorizontalPaddingPercentageByScreenSize(getScreenSize(context));

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(
          getDeviceWidth(context) * horizontalPaddingPercentage,
          10.0,
          getDeviceWidth(context) * horizontalPaddingPercentage,
          10.0,
        ),
        child: Column(children: _content),
      ),
    );
  }
}
