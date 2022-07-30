import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey, rootBundle;
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/footnotes_card.dart';
import 'package:islam200qa/widgets/paragraph_card.dart';
import 'package:islam200qa/widgets/title_card.dart';
import 'package:sprintf/sprintf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      title: 'الإسلام في ٢٠٠ سؤال وجواب',
      theme: ThemeData(
        fontFamily: 'Amiri',
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ListTile> _sectionTiles = [];
  int _currentSection = 1;
  final List<Widget> _content = [];

  Future<List<String>> _getSectionParagraphs(final int sectionId) async {
    final String filePath = sprintf('data/sections/%d.txt', [sectionId]);
    return await rootBundle
        .loadString(filePath)
        .then((section) => section.split('\n'));
  }

  Widget _getPreviousPageButton(final int sectionId) {
    var onPressCallback;

    if (sectionId - 1 >= 1) {
      onPressCallback = () {
        _loadSection(sectionId - 1);
      };
    }

    return ElevatedButton(
      onPressed: onPressCallback,
      child: const Text('الصفحة السابقة'),
    );
  }

  Widget _getNextPageButton(final int sectionId) {
    var onPressCallback;

    if (sectionId + 1 <= lastSection) {
      onPressCallback = () {
        _loadSection(sectionId + 1);
      };
    }

    return ElevatedButton(
      onPressed: onPressCallback,
      child: const Text('الصفحة التالية'),
    );
  }

  Widget _getPreviousNextButtonsRow(final int sectionId) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: _getPreviousPageButton(sectionId),
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
            child: _getNextPageButton(sectionId),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  void _loadSection(final int sectionId) {
    _getSectionParagraphs(sectionId).then((paragraphs) {
      _content.clear();

      _content.add(_getPreviousNextButtonsRow(sectionId));

      _content.add(TitleCard(paragraph: paragraphs[0]));

      bool isParagraph = true;
      List<String> footnotes = [];
      paragraphs.skip(1).forEach((paragraph) {
        if (paragraph.isEmpty) {
          isParagraph = false;
        } else if (isParagraph) {
          _content.add(ParagraphCard(paragraph: paragraph));
        } else {
          footnotes.add(paragraph);
        }
      });

      if (footnotes.isNotEmpty) {
        _content.add(const SizedBox(height: 10));
        _content.add(FootnotesCard(footnotes: footnotes));
      }

      _content.add(const SizedBox(height: 10));

      setState(() {
        _currentSection = sectionId;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    for (int sectionId = 0; sectionId <= lastSection; ++sectionId) {
      _getSectionParagraphs(sectionId).then(
        (paragraph) {
          _sectionTiles.add(
            ListTile(
              title: Text(
                sprintf(
                  '%s. %s',
                  [
                    arabizeNumbers(sectionId.toString()),
                    paragraph[0],
                  ],
                ),
              ),
              onTap: () {
                _loadSection(sectionId);
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSection(_currentSection);
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPaddingPercentage =
        getHorizontalPaddingPercentageByScreenSize(getScreenSize(context));

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          _loadSection(_currentSection + 1);
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          _loadSection(_currentSection - 1);
        } else if (event.isKeyPressed(LogicalKeyboardKey.home)) {
          _loadSection(1);
        } else if (event.isKeyPressed(LogicalKeyboardKey.end)) {
          _loadSection(lastSection);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإسلام في ٢٠٠ سؤال وجواب'),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: 'عرض المحتويات',
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    margin: EdgeInsets.only(bottom: 0.0),
                    child: Text('المحتويات'),
                  ),
                ] +
                _sectionTiles,
          ),
        ),
        body: SingleChildScrollView(
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
      ),
    );
  }
}
