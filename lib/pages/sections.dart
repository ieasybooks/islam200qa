import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islam200qa/routes.gr.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:sprintf/sprintf.dart';

class SectionsPage extends StatefulWidget {
  const SectionsPage({Key? key}) : super(key: key);

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  final List<ListTile> _sectionTiles = [];

  void _loadIndex() {
    rootBundle
        .loadString('data/index.txt')
        .then((titles) => titles.split('\n'))
        .then(
      (titles) {
        titles.asMap().forEach(
              (index, title) => _sectionTiles.add(
                ListTile(
                  title: Text(
                    sprintf(
                      '%s. %s',
                      [
                        arabizeNumbers((index + 1).toString()),
                        title,
                      ],
                    ),
                  ),
                  onTap: () {
                    AutoRouter.of(context)
                        .push(SectionRoute(sectionId: index + 1));
                    Navigator.pop(context);
                  },
                ),
              ),
            );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadIndex();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          controller: ScrollController(),
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
      body: const AutoRouter(),
    );
  }
}
