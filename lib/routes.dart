import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/pages/section.dart';
import 'package:islam200qa/pages/sections.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    CustomRoute(
        path: '/sections',
        page: SectionsPage,
        customRouteBuilder: sectionsCustomRouteBuilder,
        initial: true,
        children: [
          RedirectRoute(path: '', redirectTo: '1'),
          CustomRoute(
            path: ':sectionId',
            page: SectionPage,
            customRouteBuilder: sectionsCustomRouteBuilder,
          ),
        ]),
  ],
)
class $AppRouter {}

Route<T> sectionsCustomRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return PageRouteBuilder(
    fullscreenDialog: page.fullscreenDialog,
    settings: page,
    pageBuilder: (_, __, ___) => child,
    reverseTransitionDuration: Duration.zero,
    transitionDuration: Duration.zero,
  );
}
