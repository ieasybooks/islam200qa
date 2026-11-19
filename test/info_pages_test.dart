import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islam200qa/info_texts.dart';
import 'package:islam200qa/router/guards/check_if_section_exists.dart';
import 'package:islam200qa/router/guards/redirect_to_bookmark.dart';
import 'package:islam200qa/router/routes.gr.dart';

// The app as main.dart builds it, opened at a path.
Widget appAt(final String path) {
  final AppRouter router = AppRouter(
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

// Taps the middle of a part of a rich text, such as one of two links in it.
Future<void> tapSubstring(
  final WidgetTester tester,
  final Finder text,
  final String part,
) async {
  final RenderParagraph paragraph = tester.renderObject<RenderParagraph>(
    find.descendant(of: text, matching: find.byType(RichText)),
  );
  final String plain = paragraph.text.toPlainText();
  final int start = plain.indexOf(part);
  expect(start, isNot(-1), reason: '"$part" in "$plain"');
  final List<TextBox> boxes = paragraph.getBoxesForSelection(
    TextSelection(baseOffset: start, extentOffset: start + part.length),
  );
  await tester.tapAt(paragraph.localToGlobal(boxes.first.toRect().center));
}

Iterable<String> allTexts(final InfoPageText page) sync* {
  yield page.title;
  if (page.updated != null) yield page.updated!;
  yield page.lead;
  for (final InfoSection section in page.sections) {
    yield section.title;
    yield* section.body;
    for (final InfoLink link in section.links) {
      yield link.label;
      yield link.url;
    }
  }
}

void main() {
  const Map<String, InfoTexts<InfoPageText>> pages = {
    'privacy': privacyTexts,
    'support': supportTexts,
  };

  group('texts', () {
    pages.forEach((name, texts) {
      test('$name: Arabic and English match section for section', () {
        expect(texts.en.sections.length, texts.ar.sections.length);
        for (int i = 0; i < texts.ar.sections.length; ++i) {
          final InfoSection ar = texts.ar.sections[i];
          final InfoSection en = texts.en.sections[i];
          expect(en.body.length, ar.body.length, reason: en.title);
          expect(
            en.links.map((link) => link.url.replaceAll('hl=en', 'hl=ar')),
            ar.links.map((link) => link.url),
            reason: en.title,
          );
        }
      });

      test('$name: names the publisher EasyBooks, الكتب المُيسّرة', () {
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

      test('$name: gives the contact address', () {
        for (final InfoPageText page in [texts.ar, texts.en]) {
          expect(
            page.sections.expand((section) => section.links),
            contains(
              isA<InfoLink>()
                  .having((link) => link.url, 'url', 'mailto:$contactEmail'),
            ),
          );
        }
      });
    });

    test('the privacy policy is dated 19 November 2026', () {
      expect(privacyTexts.ar.updated, contains('١٩ نوفمبر ٢٠٢٦'));
      expect(privacyTexts.en.updated, contains('19 November 2026'));
    });

    // Cloudflare adds its Web Analytics beacon to the website's pages (the
    // ieasybooks.com zone installs it automatically); the app has none.
    test('the privacy policy names the website hosts and analytics', () {
      for (final InfoPageText page in [privacyTexts.ar, privacyTexts.en]) {
        final String text = allTexts(page).join('\n');
        for (final String name in [
          'Netlify',
          'Cloudflare Web Analytics',
          'gstatic.com',
        ]) {
          expect(text, contains(name), reason: page.title);
        }
      }
    });

    test('the support page links the privacy policy', () {
      for (final InfoPageText page in [supportTexts.ar, supportTexts.en]) {
        expect(
          page.sections.last.links.map((link) => link.url),
          ['/privacy'],
        );
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
    testWidgets('/privacy shows the policy in Arabic, then English',
        (tester) async {
      await tester.pumpWidget(appAt('/privacy'));
      await tester.pumpAndSettle();

      expect(find.text('سياسة الخصوصية'), findsWidgets);
      expect(find.text('آخر تحديث: ١٩ نوفمبر ٢٠٢٦'), findsOneWidget);
      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Last updated: 19 November 2026'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('ما يُحفظ على جهازك'))),
        TextDirection.rtl,
      );
      expect(
        Directionality.of(
          tester.element(find.text('Information stored on your device')),
        ),
        TextDirection.ltr,
      );
      expect(
        tester.getTopLeft(find.text('Privacy policy')).dy,
        greaterThan(tester.getTopLeft(find.text('تحديث السياسة')).dy),
      );
    });

    testWidgets('/support links the privacy policy, and back returns',
        (tester) async {
      await tester.pumpWidget(appAt('/support'));
      await tester.pumpAndSettle();

      expect(find.text('التواصل والدعم'), findsWidgets);
      expect(find.text('Contact and support'), findsOneWidget);
      expect(find.text(contactEmail), findsNWidgets(2));

      await tester.ensureVisible(find.text('سياسة الخصوصية'));
      await tester.tap(find.text('سياسة الخصوصية'));
      await tester.pumpAndSettle();
      expect(find.text('آخر تحديث: ١٩ نوفمبر ٢٠٢٦'), findsOneWidget);

      await tester.tap(find.byTooltip('الرجوع'));
      await tester.pumpAndSettle();
      expect(find.text('Contact and support'), findsOneWidget);
      expect(find.text('آخر تحديث: ١٩ نوفمبر ٢٠٢٦'), findsNothing);
    });

    testWidgets('the English button scrolls to the English part',
        (tester) async {
      await tester.pumpWidget(appAt('/privacy'));
      await tester.pumpAndSettle();
      final double before = tester.getTopLeft(find.text('Privacy policy')).dy;

      await tester.tap(find.widgetWithText(TextButton, 'English'));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Privacy policy')).dy,
        lessThan(before),
      );
    });

    testWidgets('the about page opens support and the privacy policy',
        (tester) async {
      await tester.pumpWidget(appAt('/about'));
      await tester.pumpAndSettle();

      final Finder links = find.textContaining('التواصل والدعم');
      await tester.ensureVisible(links);
      await tester.pumpAndSettle();
      await tapSubstring(tester, links, 'التواصل والدعم');
      await tester.pumpAndSettle();
      expect(find.text('Contact and support'), findsOneWidget);

      await tester.tap(find.byTooltip('الرجوع'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(links);
      await tester.pumpAndSettle();
      await tapSubstring(tester, links, 'سياسة الخصوصية');
      await tester.pumpAndSettle();
      expect(find.text('Privacy policy'), findsOneWidget);
    });
  });
}
