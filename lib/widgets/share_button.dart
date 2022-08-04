import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key, required this.title, required this.sectionId})
      : super(key: key);

  final String title;
  final int sectionId;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          Share.share(
            sprintf(
              'الإسلام في 200 سؤال وجواب: %s\n\nhttps://islam200qa.netlify.app/%d',
              [
                title,
                sectionId,
              ],
            ),
          );
        },
        child: const Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.share,
                  color: Colors.green,
                ),
              ),
              TextSpan(
                text: ' شارك',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
