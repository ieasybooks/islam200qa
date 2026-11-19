import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/url_utils.dart';

/// A page of text in Arabic, right to left, then in English, left to right,
/// such as the privacy policy and the support page.
class InfoPage extends StatefulWidget {
  const InfoPage({Key? key, required this.texts}) : super(key: key);

  final InfoTexts<InfoPageText> texts;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final GlobalKey _englishKey = GlobalKey();

  @override
  Widget build(final BuildContext context) {
    FlutterNativeSplash.remove();

    final double horizontalPadding = getDeviceWidth(context) *
        getHorizontalPaddingPercentageByScreenSize(getScreenSize(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.texts.ar.title),
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
          tooltip: 'الرجوع',
        ),
        actions: [
          TextButton(
            onPressed: () {
              final BuildContext? english = _englishKey.currentContext;
              if (english != null) {
                Scrollable.ensureVisible(
                  english,
                  duration: const Duration(milliseconds: 300),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text(
              'English',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
        centerTitle: false,
      ),
      // Both languages are short, so they're built at once, which lets the
      // English button scroll to the English part.
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
                _InfoCard(
                  text: widget.texts.ar,
                  textDirection: TextDirection.rtl,
                ),
                _InfoCard(
                  key: _englishKey,
                  text: widget.texts.en,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    Key? key,
    required this.text,
    required this.textDirection,
  }) : super(key: key);

  final InfoPageText text;
  final TextDirection textDirection;

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
      Text(text.lead, style: bodyStyle),
    ];

    for (final InfoSection section in text.sections) {
      children.add(const SizedBox(height: 16));
      children.add(Text(section.title, style: sectionStyle));
      for (final String paragraph in section.body) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(paragraph, style: bodyStyle),
          ),
        );
      }
      for (final InfoLink link in section.links) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _InfoLinkText(link: link, style: bodyStyle),
          ),
        );
      }
    }

    return Directionality(
      textDirection: textDirection,
      child: Card(
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
      ),
    );
  }
}

/// A link that stays selectable: a path such as /privacy opens in the app,
/// anything else (a web page, mailto:) outside it.
class _InfoLinkText extends StatefulWidget {
  const _InfoLinkText({required this.link, required this.style});

  final InfoLink link;
  final TextStyle style;

  @override
  State<_InfoLinkText> createState() => _InfoLinkTextState();
}

class _InfoLinkTextState extends State<_InfoLinkText> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = _open;

  void _open() {
    final String url = widget.link.url;
    if (url.startsWith('/')) {
      AutoRouter.of(context).pushNamed(url);
    } else {
      launchUrlWrapper(Uri.parse(url));
    }
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final bool isAddress = widget.link.url.startsWith('mailto:');

    return Text.rich(
      TextSpan(
        text: widget.link.label,
        style: widget.style.copyWith(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
        ),
        recognizer: _recognizer,
        mouseCursor: SystemMouseCursors.click,
      ),
      // An email address reads left to right in Arabic too.
      textDirection: isAddress ? TextDirection.ltr : null,
    );
  }
}
