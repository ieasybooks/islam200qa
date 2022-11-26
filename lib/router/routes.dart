import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/pages/about_page.dart';
import 'package:islam200qa/pages/privacy_page.dart';
import 'package:islam200qa/pages/section_page.dart';
import 'package:islam200qa/pages/sections_page.dart';
import 'package:islam200qa/router/guards/check_if_section_exists.dart';
import 'package:islam200qa/router/guards/redirect_to_bookmark.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/privacy', page: PrivacyPage),
    AutoRoute(path: '/about', page: AboutPage),
    CustomRoute(
      name: 'SectionsPageParent',
      path: '/',
      page: SectionsPage,
      customRouteBuilder: sectionsCustomRouteBuilder,
      initial: true,
      children: [
        CustomRoute(
          name: 'SectionsPageChild',
          path: '',
          page: SectionsPage,
          guards: [RedirectToBookmark],
          customRouteBuilder: sectionsCustomRouteBuilder,
        ),
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
