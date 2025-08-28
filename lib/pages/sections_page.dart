import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/keys_to_be_inherited.dart';
import 'package:islam200qa/router/routes.gr.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/index/index_single_section.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';
import 'package:islam200qa/widgets/index/index_widgets_factory.dart';
import 'package:showcaseview/showcaseview.dart';

class SectionsPage extends StatefulWidget {
  const SectionsPage({Key? key}) : super(key: key);

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  final GlobalKey _indexKey = GlobalKey();

  final List<Widget> _indexContent = [];
  final List<Widget> _fullIndexContent = [];
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fullIndexContent.addAll(
      index.map(indexWidgetFactory).cast<Widget>().toList(),
    );

    _indexContent.addAll(_fullIndexContent);
  }

  void search(final String query) {
    if (query.isEmpty) {
      setState(() {
        _indexContent.clear();
        _indexContent.addAll(_fullIndexContent);
      });
    } else {
      final String normalizedQuery = normalizeArabicText(query);

      final List<IndexSingleSection> searchResults = [];

      indexTitlesProcessed.asMap().entries.forEach(
        (entry) {
          if (entry.value.contains(normalizedQuery)) {
            searchResults.add(
              IndexSingleSection(
                indexSingleSectionModel: IndexSingleSectionModel(
                  sectionId: entry.key,
                ),
                rightPadding: indexBasePadding,
              ),
            );
          }
        },
      );

      setState(() {
        _indexContent.clear();
        _indexContent.addAll(searchResults);
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return KeysToBeInherited(
      indexKey: _indexKey,
      child: ShowCaseWidget(
        enableAutoScroll: true,
        builder: (content) => Scaffold(
          appBar: AppBar(
            title: const Text('الإسلام في ٢٠٠ سؤال وجواب'),
            leading: Builder(
              builder: (BuildContext context) {
                return Showcase(
                  key: KeysToBeInherited.of(context).indexKey,
                  title: 'المحتويات',
                  description:
                      'يمكنك تصفّح فهرس الأسئلة والبحث داخله من خلال الضغط على هذا الزر',
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: 'عرض المحتويات',
                  ),
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  AutoRouter.of(context).push(
                    const AboutRoute(),
                  );
                },
                tooltip: 'عن التطبيق',
              ),
            ],
            centerTitle: false,
          ),
          drawer: Drawer(
            child: ListView(
              controller: ScrollController(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      margin: const EdgeInsets.only(bottom: 0.0),
                      child: const Text(
                        'المحتويات',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: editingController,
                      decoration: const InputDecoration(
                        hintText: 'إبحث في المحتويات',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        search(value);
                      },
                    ),
                  ] +
                  _indexContent,
            ),
          ),
          body: const AutoRouter(),
        ),
      ),
    );
  }
}
