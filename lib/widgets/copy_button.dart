import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

class CopyButton extends StatelessWidget {
  CopyButton({
    Key? key,
    required List<String> paragraphs,
    required this.sectionId,
  })  : content = (paragraphs +
                [
                  '',
                  sprintf(
                    'https://islam200qa.ieasybooks.com/%d',
                    [sectionId],
                  ),
                ])
            .join('\n'),
        super(key: key);

  final String content;
  final int sectionId;

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: content));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم نسخ محتوى الصفحة.'),
                duration: Duration(milliseconds: 1000),
              ),
            );
          },
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.copy,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(
                  text: ' نسخ المتحوى',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
