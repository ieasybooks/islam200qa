import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteButton extends StatelessWidget {
  const WebsiteButton({Key? key}) : super(key: key);

  Future<void> _launchUrl(final Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            _launchUrl(Uri.parse('https://islam200qa.com'));
          },
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.home,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(
                  text: ' تصفح موقعنا',
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
