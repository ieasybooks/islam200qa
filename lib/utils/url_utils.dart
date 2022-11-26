import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlWrapper(final Uri url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
