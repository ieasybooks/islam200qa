import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/router/routes.gr.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/section_utils.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/copy_button.dart';
import 'package:islam200qa/widgets/footnotes_card.dart';
import 'package:islam200qa/widgets/paragraph_card.dart';
import 'package:islam200qa/widgets/share_button.dart';
import 'package:islam200qa/widgets/title_card.dart';
import 'package:sprintf/sprintf.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({
    Key? key,
    @pathParam required this.sectionId,
  }) : super(key: key);

  final int sectionId;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  final List<Widget> _content = [];

  Widget _buildNavigationButton(
    final int sectionId,
    final Function() predicate,
    final int change,
    final String text,
  ) {
    Null Function()? onPressCallback;

    if (predicate()) {
      onPressCallback = () {
        AutoRouter.of(context).push(
          SectionRoute(sectionId: sectionId + change),
        );
      };
    }

    return ElevatedButton(
      onPressed: onPressCallback,
      child: Text(text),
    );
  }

  Widget _buildNavigationRow(final int sectionId) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: _buildNavigationButton(
              sectionId,
              () => sectionId - 1 >= 1,
              -1,
              'السابق',
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              sprintf(
                '%s/%s',
                [
                  arabizeNumbers(lastSection.toString()),
                  arabizeNumbers(sectionId.toString()),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: _buildNavigationButton(
              sectionId,
              () => sectionId + 1 <= lastSection,
              1,
              'التالي',
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  void _loadSection(final int sectionId) {
    getSectionParagraphs(sectionId).then(
      (paragraphs) {
        _content.add(_buildNavigationRow(sectionId));

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
          _content.add(FootnotesCard(footnotes: footnotes));
        } else {
          _content.add(const SizedBox(height: 10));
        }

        if (!kIsWeb) {
          _content.add(ShareButton(title: paragraphs[0], sectionId: sectionId));
          _content.add(const SizedBox(height: 10));
        }

        _content.add(CopyButton(paragraphs: paragraphs, sectionId: sectionId));
        _content.add(const SizedBox(height: 5));

        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSection(widget.sectionId);
  }

  @override
  Widget build(final BuildContext context) {
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
