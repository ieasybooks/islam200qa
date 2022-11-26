import 'package:flutter/material.dart';
import 'package:islam200qa/utils/screen_utils.dart';

class ParagraphCard extends StatelessWidget {
  const ParagraphCard({
    Key? key,
    required this.paragraph,
  }) : super(key: key);

  final String paragraph;

  @override
  Widget build(final BuildContext context) {
    int coloringDepth = 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: getDeviceWidth(context),
          child: Text.rich(
            TextSpan(
              children: paragraph.split(' ').map(
                (word) {
                  if (word.contains('{') || word.contains('«')) {
                    coloringDepth += 1;
                  }

                  if (word == 'س:' || word == 'جـ:') {
                    return TextSpan(
                      text: '$word ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (coloringDepth > 0) {
                    if (word.contains('}') || word.contains('»')) {
                      coloringDepth -= 1;
                    }

                    return TextSpan(
                      text: '$word ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    return TextSpan(
                      text: '$word ',
                      style: const TextStyle(fontSize: 24),
                    );
                  }
                },
              ).toList(),
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
