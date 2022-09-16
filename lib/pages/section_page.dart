import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/keys_to_be_inherited.dart';
import 'package:islam200qa/router/routes.gr.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/section_utils.dart';
import 'package:islam200qa/utils/shared_preferences_utils.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/copy_button.dart';
import 'package:islam200qa/widgets/footnotes_card.dart';
import 'package:islam200qa/widgets/paragraph_card.dart';
import 'package:islam200qa/widgets/share_button.dart';
import 'package:islam200qa/widgets/title_card.dart';
import 'package:showcaseview/showcaseview.dart';
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
  final GlobalKey _navigationKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();
  final GlobalKey _finishKey = GlobalKey();

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
    return Showcase(
      overlayPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      key: _navigationKey,
      title: 'التنقّل',
      description:
          'يمكنك الإنتقال بين الأسئلة من خلال الضغط على رز "السابق" و"التالي"، أو من خلال سحب الشاشة يمينًا ويسارًا',
      child: Row(
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
      ),
    );
  }

  void _loadSection(final int sectionId) {
    getSectionParagraphs(sectionId).then(
      (paragraphs) {
        _content.add(
          Showcase(
            overlayPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            key: _finishKey,
            description: 'وفّقك الله لما يُحب ويرضى ونفعك بما ستقرأ',
            showArrow: false,
            child: const SizedBox(height: 0),
          ),
        );

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

        List<Widget> c = [];

        if (footnotes.isNotEmpty) {
          c.add(FootnotesCard(footnotes: footnotes));
        } else {
          _content.add(const SizedBox(height: 10));
        }

        if (!kIsWeb) {
          c.add(ShareButton(title: paragraphs[0], sectionId: sectionId));
          c.add(const SizedBox(height: 10));
        }

        c.add(CopyButton(paragraphs: paragraphs, sectionId: sectionId));
        c.add(const SizedBox(height: 5));

        _content.add(
          Showcase(
            overlayPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            key: _footerKey,
            title: 'الخيارات',
            description:
                'يمكنك عرض الحواشي، مشاركة الأسئلة ونسخ محتوياتها من خلال الخيارات الموجودة في هذه المنطقة',
            child: Column(children: c),
          ),
        );

        setState(() {
          FlutterNativeSplash.remove();
        });
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
    getDisplayShowCase().then(
      (status) {
        if (status) {
          ShowCaseWidget.of(context).startShowCase(
            [
              KeysToBeInherited.of(context).indexKey,
              _navigationKey,
              _footerKey,
              _finishKey,
            ],
          );
        }
      },
    );

    double horizontalPaddingPercentage =
        getHorizontalPaddingPercentageByScreenSize(getScreenSize(context));

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 8) {
          if (widget.sectionId + 1 < lastSection) {
            AutoRouter.of(context).push(
              SectionRoute(sectionId: widget.sectionId + 1),
            );
          }
        } else if (details.delta.dx < -8) {
          if (widget.sectionId - 1 > 0) {
            AutoRouter.of(context).push(
              SectionRoute(sectionId: widget.sectionId - 1),
            );
          }
        }
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(
            getDeviceWidth(context) * horizontalPaddingPercentage,
            10.0,
            getDeviceWidth(context) * horizontalPaddingPercentage,
            10.0,
          ),
          child: Column(children: _content),
        ),
      ),
    );
  }
}
