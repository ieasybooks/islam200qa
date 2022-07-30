import 'package:flutter/material.dart';

class FootnotesCard extends StatelessWidget {
  const FootnotesCard({Key? key, required this.footnotes}) : super(key: key);

  final List<String> footnotes;

  List<TextSpan> _buildFootnoteText(final String footnote) {
    int firstSpaceIndex = footnote.indexOf(' ');

    String footnoteNumber = footnote.substring(0, firstSpaceIndex);
    String footnoteBody = footnote.substring(firstSpaceIndex);

    return [
      TextSpan(
        text: footnoteNumber,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: footnoteBody),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        dividerColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: Colors.transparent,
        collapsedIconColor: Colors.transparent,
        childrenPadding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
        expandedAlignment: Alignment.topRight,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: const Text(
          'الحواشي (إضغط للإظهار)',
          style: TextStyle(fontSize: 14),
        ),
        children: footnotes
            .map(
              (footnote) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SelectableText.rich(
                  TextSpan(children: _buildFootnoteText(footnote)),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
