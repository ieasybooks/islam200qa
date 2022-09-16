import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/pages/privacy_page.dart';
import 'package:islam200qa/pages/section_page.dart';
import 'package:islam200qa/pages/sections_page.dart';
import 'package:islam200qa/router/guards/check_if_section_exists.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/privacy', page: PrivacyPage),
    CustomRoute(
      path: '/',
      page: SectionsPage,
      customRouteBuilder: sectionsCustomRouteBuilder,
      initial: true,
      children: [
        RedirectRoute(path: '', redirectTo: '1'),
        CustomRoute(
          path: ':sectionId',
          page: SectionPage,
          customRouteBuilder: sectionsCustomRouteBuilder,
          guards: [CheckIfSectionExists],
        ),
      ],
    ),
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
