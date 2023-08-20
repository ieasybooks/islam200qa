import 'package:flutter/material.dart';
import 'package:islam200qa/utils/url_utils.dart';

class WebsiteButton extends StatelessWidget {
  const WebsiteButton({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            launchUrlWrapper(Uri.parse('https://islam200qa.ieasybooks.com'));
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
