import 'package:auto_route/auto_route.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/router/routes.gr.dart';

class CheckIfSectionExists extends AutoRouteGuard {
  @override
  void onNavigation(final NavigationResolver resolver, final StackRouter router) async {
    final int sectionId = resolver.route.pathParams.getInt('sectionId');

    if (sectionId >= 1 && sectionId <= lastSection) {
      resolver.next(true);
    } else {
      router.push(SectionRoute(sectionId: 1));
    }
  }
}
