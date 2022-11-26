import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key? key,
    required this.title,
    required this.sectionId,
  }) : super(key: key);

  final String title;
  final int sectionId;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final GlobalKey shareButtonKey = GlobalKey();

  Rect? shareButtonRect() {
    RenderBox renderBox =
        shareButtonKey.currentContext?.findRenderObject() as RenderBox;

    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          key: shareButtonKey,
          onTap: () {
            Share.share(
              sprintf(
                'الإسلام في 200 سؤال وجواب: %s\n\nhttps://islam200qa.com/%d',
                [
                  widget.title,
                  widget.sectionId,
                ],
              ),
              sharePositionOrigin: shareButtonRect(),
            );
          },
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.share,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(
                  text: ' شارك',
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
