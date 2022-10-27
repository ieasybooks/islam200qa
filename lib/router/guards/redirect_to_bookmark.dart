import 'package:auto_route/auto_route.dart';
import 'package:islam200qa/router/routes.gr.dart';
import 'package:islam200qa/utils/shared_preferences_utils.dart';

class RedirectToBookmark extends AutoRouteGuard {
  @override
  void onNavigation(
      final NavigationResolver resolver, final StackRouter router) async {
    final int bookmark = await getBookmark();

    if (bookmark != -1) {
      router.push(SectionRoute(sectionId: bookmark));
    } else {
      router.push(SectionRoute(sectionId: 1));
    }
  }
}
