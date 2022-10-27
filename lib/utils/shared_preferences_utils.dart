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

Future<int> getBookmark() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  int? bookmark = sharedPreferences.getInt('bookmark');

  if (bookmark == null) {
    return -1;
  }

  return bookmark;
}

void setBookmark(int bookmark) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setInt('bookmark', bookmark);
}
