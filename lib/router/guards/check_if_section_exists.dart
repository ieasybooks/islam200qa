import 'package:auto_route/auto_route.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/router/routes.gr.dart';

class CheckIfSectionExists extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final int sectionId = resolver.route.pathParams.getInt('sectionId');

    if (sectionId >= 1 && sectionId <= lastSection) {
      resolver.next(true); // book was found. proceed to the page
    } else {
      router.push(SectionRoute(sectionId: 1));
    }
  }
}
