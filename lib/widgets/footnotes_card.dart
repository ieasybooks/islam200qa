import 'package:flutter/material.dart';

class FootnotesCard extends StatelessWidget {
  const FootnotesCard({
    Key? key,
    required this.footnotes,
  }) : super(key: key);

  final List<String> footnotes;

  List<TextSpan> _buildFootnoteText(
    final BuildContext context,
    final String footnote,
  ) {
    int firstSpaceIndex = footnote.indexOf(' ');

    String footnoteNumber = footnote.substring(0, firstSpaceIndex);
    String footnoteBody = footnote.substring(firstSpaceIndex);

    return [
      TextSpan(
        text: footnoteNumber,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: footnoteBody),
    ];
  }

  @override
  Widget build(final BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        dividerColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: Colors.transparent,
          collapsedIconColor: Colors.transparent,
          tilePadding: const EdgeInsets.only(right: 0.0),
          childrenPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          expandedAlignment: Alignment.topRight,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.list_alt_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(
                  text: ' الحواشي (إضغط للإظهار)',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          children: footnotes
              .map(
                (footnote) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text.rich(
                    TextSpan(children: _buildFootnoteText(context, footnote)),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
