import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/url_utils.dart';

/// One of the four pages (About, the privacy policy, the terms of use, and
/// contact and support) in one language: Arabic, right to left, or English,
/// left to right. Its app bar opens the same page in the other language, and
/// it ends with links to the other three pages in its language.
class InfoPage extends StatelessWidget {
  const InfoPage({
    Key? key,
    required this.page,
    required this.language,
  }) : super(key: key);

  final InfoPageId page;
  final InfoLanguage language;

  @override
  Widget build(final BuildContext context) {
    FlutterNativeSplash.remove();

    final bool english = language == InfoLanguage.en;
    final InfoPageText text = infoTexts[page]!.of(language);
    final double horizontalPadding = getDeviceWidth(context) *
        getHorizontalPaddingPercentageByScreenSize(getScreenSize(context));

    return Directionality(
      textDirection: english ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(text.label),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final StackRouter router = AutoRouter.of(context);
              router.pop().then((isPopped) {
                if (!isPopped) {
                  router.pushNamed('/');
                }
              });
            },
            tooltip: english ? 'Back' : 'الرجوع',
          ),
          actions: [
            // The same page in the other language, in this page's place.
            TextButton(
              onPressed: () {
                AutoRouter.of(context).replaceNamed(
                  infoPath(
                    page,
                    english ? InfoLanguage.ar : InfoLanguage.en,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: Text(
                english ? 'العربية' : 'English',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: SelectionArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                10.0,
                horizontalPadding,
                10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (page == InfoPageId.about)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 250,
                      ),
                    ),
                  _InfoCard(page: page, language: language, text: text),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.page,
    required this.language,
    required this.text,
  });

  final InfoPageId page;
  final InfoLanguage language;
  final InfoPageText text;

  @override
  Widget build(final BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    const TextStyle bodyStyle = TextStyle(fontSize: 22, height: 1.5);
    final TextStyle sectionStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    );

    final List<Widget> children = [
      Text(
        text.title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      if (text.updated != null)
        Text(
          text.updated!,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
      const SizedBox(height: 8),
      _LinkedText(text: text.lead, style: bodyStyle),
    ];

    for (final InfoSection section in text.sections) {
      children.add(const SizedBox(height: 16));
      children.add(Text(section.title, style: sectionStyle));
      for (final String paragraph in section.paragraphs) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _LinkedText(text: paragraph, style: bodyStyle),
          ),
        );
      }
    }

    // The other three pages, in this page's language, each kept on one line.
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 4,
            children: [
              for (final InfoPageId other in InfoPageId.values)
                if (other != page)
                  _LinkedText(
                    text: '[${infoTexts[other]!.of(language).label}]'
                        '(${infoPath(other, language)})',
                    style: bodyStyle,
                  ),
            ],
          ),
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

/// A paragraph whose links ([their words](address), see [InfoSection]) stay
/// selectable with the rest of it: one of these pages opens in the app,
/// anything else (a web page, mailto:) outside it.
class _LinkedText extends StatefulWidget {
  const _LinkedText({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  State<_LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<_LinkedText> {
  late List<InfoTextPart> _parts;
  late List<TapGestureRecognizer?> _recognizers;

  void _parse() {
    _parts = infoTextParts(widget.text);
    _recognizers = [
      for (final InfoTextPart part in _parts)
        part.url == null
            ? null
            : (TapGestureRecognizer()..onTap = () => _open(part.url!)),
    ];
  }

  void _disposeRecognizers() {
    for (final TapGestureRecognizer? recognizer in _recognizers) {
      recognizer?.dispose();
    }
  }

  void _open(final String url) {
    if (url.startsWith('/')) {
      AutoRouter.of(context).pushNamed(url);
    } else {
      launchUrlWrapper(Uri.parse(url));
    }
  }

  @override
  void initState() {
    super.initState();
    _parse();
  }

  @override
  void didUpdateWidget(final _LinkedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _disposeRecognizers();
      _parse();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final TextStyle linkStyle = widget.style.copyWith(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blue,
    );

    return Text.rich(
      TextSpan(
        style: widget.style,
        children: [
          for (int i = 0; i < _parts.length; ++i)
            TextSpan(
              text: _parts[i].text,
              style: _recognizers[i] == null ? null : linkStyle,
              recognizer: _recognizers[i],
            ),
        ],
      ),
    );
  }
}
