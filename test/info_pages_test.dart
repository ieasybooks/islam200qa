import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/router/guards/check_if_section_exists.dart';
import 'package:islam200qa/router/guards/redirect_to_bookmark.dart';
import 'package:islam200qa/router/routes.gr.dart';

late AppRouter router;

// The app as main.dart builds it, opened at a path.
Widget appAt(final String path) {
  router = AppRouter(
    checkIfSectionExists: CheckIfSectionExists(),
    redirectToBookmark: RedirectToBookmark(),
  );
  return MaterialApp.router(
    routerDelegate: router.delegate(initialDeepLink: path),
    routeInformationParser: router.defaultRouteParser(),
    builder: (context, child) => Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    ),
  );
}

// Opens the app at a path, in a window tall enough to show a whole page.
Future<void> open(final WidgetTester tester, final String path) async {
  tester.view.physicalSize = const Size(1000, 8000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(appAt(path));
  await tester.pumpAndSettle();
}

// test/approved_pages.txt: the approved pages as plain text, one block per
// page and language ("===== Islam in 200 Q&A / privacy / en"), a line per
// title, heading ("## ") or paragraph, without the date.
Map<String, List<String>> approvedPages() {
  final Map<String, List<String>> pages = {};
  List<String>? lines;
  for (final String line in File('test/approved_pages.txt').readAsLinesSync()) {
    if (line.startsWith('===== ')) {
      final List<String> name = line.substring(6).split(' / ');
      lines = pages['${name[1]}/${name[2]}'] = [];
    } else if (line.isNotEmpty) {
      lines!.add(line);
    }
  }
  return pages;
}

// A page's text in the same form: title, lead, then headings and paragraphs.
List<String> pageLines(final InfoPageText text) => [
      text.title,
      infoPlainText(text.lead),
      for (final InfoSection section in text.sections) ...[
        '## ${section.title}',
        ...section.paragraphs.map(infoPlainText),
      ],
    ];

Iterable<String> allTexts(final InfoPageText page) sync* {
  yield page.label;
  yield page.title;
  if (page.updated != null) yield page.updated!;
  yield page.lead;
  for (final InfoSection section in page.sections) {
    yield section.title;
    yield* section.paragraphs;
  }
}

const Map<InfoLanguage, String> languageNames = {
  InfoLanguage.ar: 'ar',
  InfoLanguage.en: 'en',
};

// Where each page's links go, in order: those in the text, then the other
// three pages.
const String email = 'mailto:easybooksdev@gmail.com';
const String issues = 'https://github.com/ieasybooks/islam200qa/issues';
const List<String> accounts = [
  'https://t.me/ieasybooks',
  'https://youtube.com/@ieasybooks',
  'https://x.com/iieasybooks',
  'https://fb.com/ieasybooks',
  'https://github.com/ieasybooks',
];
const Map<String, List<String>> expectedLinks = {
  'about/ar': [...accounts, '/privacy', '/terms', '/support'],
  'about/en': [...accounts, '/en/privacy', '/en/terms', '/en/support'],
  'privacy/ar': [email, '/about', '/terms', '/support'],
  'privacy/en': [email, '/en/about', '/en/terms', '/en/support'],
  'terms/ar': [email, email, '/about', '/privacy', '/support'],
  'terms/en': [email, email, '/en/about', '/en/privacy', '/en/support'],
  'support/ar': [
    email,
    issues,
    '/terms',
    '/privacy',
    '/about',
    '/privacy',
    '/terms',
  ],
  'support/en': [
    email,
    issues,
    '/en/terms',
    '/en/privacy',
    '/en/about',
    '/en/privacy',
    '/en/terms',
  ],
};

// The links at the end of each page: the other three, the terms of use next to
// the privacy policy.
const Map<InfoLanguage, Map<InfoPageId, String>> labels = {
  InfoLanguage.ar: {
    InfoPageId.about: 'عن التطبيق',
    InfoPageId.privacy: 'سياسة الخصوصية',
    InfoPageId.terms: 'شروط الاستخدام',
    InfoPageId.support: 'التواصل والدعم',
  },
  InfoLanguage.en: {
    InfoPageId.about: 'About',
    InfoPageId.privacy: 'Privacy policy',
    InfoPageId.terms: 'Terms of use',
    InfoPageId.support: 'Contact & support',
  },
};

// The paragraphs of the page on screen, in order.
List<RenderParagraph> paragraphs(final WidgetTester tester) => tester
    .renderObjectList<RenderParagraph>(
      find.descendant(of: find.byType(Card), matching: find.byType(RichText)),
    )
    .toList();

class LinkOnScreen {
  LinkOnScreen(this.paragraph, this.start, this.span);

  final RenderParagraph paragraph;
  final int start;
  final TextSpan span;

  // The middle of the link's first line.
  Offset get center => paragraph.localToGlobal(
        paragraph
            .getBoxesForSelection(
              TextSelection(
                baseOffset: start,
                extentOffset: start + span.text!.length,
              ),
            )
            .first
            .toRect()
            .center,
      );
}

// The links on the page on screen, in order.
List<LinkOnScreen> linksOnScreen(final WidgetTester tester) {
  final List<LinkOnScreen> links = [];
  for (final RenderParagraph paragraph in paragraphs(tester)) {
    int offset = 0;
    paragraph.text.visitChildren((span) {
      if (span is TextSpan) {
        if (span.recognizer != null) {
          links.add(LinkOnScreen(paragraph, offset, span));
        }
        offset += span.text?.length ?? 0;
      }
      return true;
    });
  }
  return links;
}

// The characters a TrueType font has glyphs for, from its Windows Unicode
// cmap (format 4).
Set<int> fontCharacters(final String path) {
  final Uint8List bytes = File(path).readAsBytesSync();
  final ByteData data = ByteData.sublistView(bytes);
  int cmap = -1;
  for (int i = 0; i < data.getUint16(4); ++i) {
    final int record = 12 + 16 * i;
    if (String.fromCharCodes(bytes.sublist(record, record + 4)) == 'cmap') {
      cmap = data.getUint32(record + 8);
    }
  }
  for (int i = 0; i < data.getUint16(cmap + 2); ++i) {
    final int record = cmap + 4 + 8 * i;
    final int table = cmap + data.getUint32(record + 4);
    if (data.getUint16(record) != 3 ||
        data.getUint16(record + 2) != 1 ||
        data.getUint16(table) != 4) {
      continue;
    }
    final int segments = data.getUint16(table + 6) ~/ 2;
    final int ends = table + 14;
    final int starts = ends + 2 * segments + 2;
    final int deltas = starts + 2 * segments;
    final int rangeOffsets = deltas + 2 * segments;
    final Set<int> characters = {};
    for (int s = 0; s < segments; ++s) {
      final int start = data.getUint16(starts + 2 * s);
      final int end = data.getUint16(ends + 2 * s);
      final int delta = data.getUint16(deltas + 2 * s);
      final int rangeOffset = data.getUint16(rangeOffsets + 2 * s);
      for (int c = start; c <= end && c != 0xFFFF; ++c) {
        int glyph = c;
        if (rangeOffset != 0) {
          glyph = data.getUint16(
            rangeOffsets + 2 * s + rangeOffset + 2 * (c - start),
          );
        }
        if (glyph != 0 && (glyph + delta) & 0xFFFF != 0) characters.add(c);
      }
    }
    return characters;
  }
  throw StateError('$path has no Unicode cmap');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<String, List<String>> approved = approvedPages();

  group('texts', () {
    test('test/approved_pages.txt has every page in both languages', () {
      expect(approved.keys, unorderedEquals(expectedLinks.keys));
    });

    infoTexts.forEach((page, texts) {
      for (final InfoLanguage language in InfoLanguage.values) {
        final String name = '${page.name}/${languageNames[language]}';

        test('$name is the approved text, word for word', () {
          expect(pageLines(texts.of(language)), approved[name]);
        });
      }

      test('${page.name}: the links in the Arabic and the English text match',
          () {
        List<String> links(final InfoPageText text) => [
              text.lead,
              for (final InfoSection section in text.sections)
                ...section.paragraphs,
            ]
                .expand(infoTextParts)
                .map((part) => part.url)
                .whereType<String>()
                .toList();

        expect(texts.en.sections.length, texts.ar.sections.length);
        expect(
          links(texts.en),
          links(texts.ar).map((url) => url.startsWith('/') ? '/en$url' : url),
        );
      });

      test('${page.name}: names the publisher EasyBooks, الكتب المُيسّرة', () {
        final String ar = allTexts(texts.ar).join('\n');
        final String en = allTexts(texts.en).join('\n');
        expect(ar, contains('الكتب المُيسّرة'));
        expect(en, contains('EasyBooks'));
        // iEasyBooks only as written: the domain is ieasybooks.com.
        expect('$ar\n$en', isNot(contains('iEasyBooks')));
        for (final String wrong in [
          'initiative',
          'information technology',
          'مبادرة',
        ]) {
          expect('$ar\n$en'.toLowerCase(), isNot(contains(wrong)));
        }
      });

      // The pages name no hosting provider, and the app isn't a "project"
      // (مشروع). The terms' مشروعًا, lawful, is another word.
      test('${page.name}: names no host, and no project', () {
        final String text = [...allTexts(texts.ar), ...allTexts(texts.en)]
            .join('\n')
            .replaceAll('استخدامًا مشروعًا', '');
        for (final String word in [
          'Netlify',
          'Cloudflare',
          'Google Drive',
          'gstatic',
          'project',
          'مشروع',
        ]) {
          expect(text.toLowerCase(), isNot(contains(word.toLowerCase())));
        }
      });
    });

    test('the privacy policy and the terms are dated 20 November 2026', () {
      for (final InfoTexts<InfoPageText> texts in [privacyTexts, termsTexts]) {
        expect(texts.ar.updated, 'آخر تحديث: ٢٠ نوفمبر ٢٠٢٦');
        expect(texts.en.updated, 'Last updated: 20 November 2026');
      }
      expect(aboutTexts.ar.updated, isNull);
      expect(supportTexts.en.updated, isNull);
    });

    // A character Amiri lacks would make the website fetch a fallback font
    // from Google.
    test('Amiri has every character of the pages, in both weights', () {
      final String text = [
        for (final InfoTexts<InfoPageText> texts in infoTexts.values) ...[
          ...allTexts(texts.ar).map(infoPlainText),
          ...allTexts(texts.en).map(infoPlainText),
        ],
        'English',
        'العربية',
        'Back',
        'الرجوع',
        '   ·   ',
      ].join();
      for (final String font in ['Amiri-Regular', 'Amiri-Bold']) {
        final Set<int> characters =
            fontCharacters('assets/fonts/amiri/$font.ttf');
        final Set<String> missing = text.runes
            .where((c) => !characters.contains(c))
            .map((c) => 'U+${c.toRadixString(16)} ${String.fromCharCode(c)}')
            .toSet();
        expect(missing, isEmpty, reason: font);
      }
    });

    test('the app names its publisher right everywhere', () {
      final Iterable<File> sources = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));
      for (final File file in sources) {
        final String text = file.readAsStringSync();
        for (final String wrong in [
          'iEasyBooks',
          'EasyBooks for information technology',
          'EasyBooks initiative',
          'مبادرة الكتب',
        ]) {
          expect(text, isNot(contains(wrong)), reason: file.path);
        }
      }
    });
  });

  group('pages', () {
    final List<String> launched = [];

    setUp(() {
      launched.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (call) async {
          if (call.method == 'launch') {
            launched.add((call.arguments as Map)['url'] as String);
            return true;
          }
          return null;
        },
      );
    });

    infoTexts.forEach((page, texts) {
      for (final InfoLanguage language in InfoLanguage.values) {
        final String name = '${page.name}/${languageNames[language]}';
        final String path = infoPath(page, language);
        final InfoPageText text = texts.of(language);

        testWidgets('$path shows the approved text, then the other pages',
            (tester) async {
          await open(tester, path);

          expect(router.currentPath, path);
          final List<String> lines = approved[name]!
              .map((line) => line.startsWith('## ') ? line.substring(3) : line)
              .toList();
          expect(
            paragraphs(tester)
                .map((paragraph) => paragraph.text.toPlainText())
                .toList(),
            [
              lines.first,
              if (text.updated != null) text.updated!,
              ...lines.skip(1),
              for (final InfoPageId other in InfoPageId.values)
                if (other != page) labels[language]![other],
            ],
          );
          expect(
            paragraphs(tester).first.textDirection,
            language == InfoLanguage.en ? TextDirection.ltr : TextDirection.rtl,
          );
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text(text.label),
            ),
            findsOneWidget,
          );
        });

        testWidgets('$path links where it should', (tester) async {
          await open(tester, path);
          final int count = linksOnScreen(tester).length;
          expect(count, expectedLinks[name]!.length);

          for (int i = 0; i < count; ++i) {
            await open(tester, path);
            launched.clear();
            final String url = expectedLinks[name]![i];

            await tester.tapAt(linksOnScreen(tester)[i].center);
            await tester.pumpAndSettle();
            if (url.startsWith('/')) {
              expect(router.currentPath, url, reason: 'link $i');
              expect(launched, isEmpty, reason: 'link $i');
            } else {
              expect(router.currentPath, path, reason: 'link $i');
              expect(launched, [url], reason: 'link $i');
            }
          }
        });
      }

      testWidgets(
          '${infoPath(page, InfoLanguage.ar)} and '
          '${infoPath(page, InfoLanguage.en)} link each other', (tester) async {
        await open(tester, infoPath(page, InfoLanguage.ar));

        await tester.tap(find.widgetWithText(TextButton, 'English'));
        await tester.pumpAndSettle();
        expect(router.currentPath, infoPath(page, InfoLanguage.en));
        expect(find.text(texts.en.title), findsWidgets);
        expect(find.text(texts.ar.title), findsNothing);
        // In the Arabic page's place: back doesn't return to it.
        expect(router.stack.length, 1);

        await tester.tap(find.widgetWithText(TextButton, 'العربية'));
        await tester.pumpAndSettle();
        expect(router.currentPath, infoPath(page, InfoLanguage.ar));
        expect(find.text(texts.ar.title), findsWidgets);
        expect(router.stack.length, 1);
      });
    });

    for (final InfoLanguage language in InfoLanguage.values) {
      final String support = infoPath(InfoPageId.support, language);
      final String privacy = infoPath(InfoPageId.privacy, language);

      testWidgets('$support opens the privacy policy, and back returns',
          (tester) async {
        await open(tester, support);

        await tester.tapAt(linksOnScreen(tester)[3].center);
        await tester.pumpAndSettle();
        expect(router.currentPath, privacy);

        await tester.tap(
          find.byTooltip(language == InfoLanguage.en ? 'Back' : 'الرجوع'),
        );
        await tester.pumpAndSettle();
        expect(router.currentPath, support);
        expect(find.text(supportTexts.of(language).title), findsWidgets);
      });
    }
  });
}
