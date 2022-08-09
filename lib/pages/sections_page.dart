import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/index/index_single_section.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';
import 'package:islam200qa/widgets/index/index_widgets_factory.dart';

class SectionsPage extends StatefulWidget {
  const SectionsPage({Key? key}) : super(key: key);

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
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
                  decoration: BoxDecoration(color: Colors.green),
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: Text(
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
    );
  }
}
