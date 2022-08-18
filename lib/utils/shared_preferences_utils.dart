import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getDisplayShowCase() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  bool? showCaseVisibilityStatus =
  sharedPreferences.getBool('displayedShowCase');

  if (showCaseVisibilityStatus == null) {
    sharedPreferences.setBool('displayedShowCase', true);
    return true;
  }

  return false;
}
