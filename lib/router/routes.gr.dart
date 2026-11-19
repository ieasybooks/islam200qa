// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../pages/about_page.dart' as _i3;
import '../pages/privacy_page.dart' as _i1;
import '../pages/section_page.dart' as _i5;
import '../pages/sections_page.dart' as _i4;
import '../pages/support_page.dart' as _i2;
import 'guards/check_if_section_exists.dart' as _i9;
import 'guards/redirect_to_bookmark.dart' as _i8;
import 'routes.dart' as _i10;

class AppRouter extends _i6.RootStackRouter {
  AppRouter({
    _i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
    required this.redirectToBookmark,
    required this.checkIfSectionExists,
  }) : super(navigatorKey);

  final _i8.RedirectToBookmark redirectToBookmark;

  final _i9.CheckIfSectionExists checkIfSectionExists;

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    PrivacyRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.PrivacyPage(),
      );
    },
    SupportRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SupportPage(),
      );
    },
    AboutRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.AboutPage(),
      );
    },
    SectionsPageParent.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i4.SectionsPage(),
        customRouteBuilder: _i10.sectionsCustomRouteBuilder,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SectionsPageChild.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i4.SectionsPage(),
        customRouteBuilder: _i10.sectionsCustomRouteBuilder,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SectionRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SectionRouteArgs>(
          orElse: () =>
              SectionRouteArgs(sectionId: pathParams.getInt('sectionId')));
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.SectionPage(
          key: args.key,
          sectionId: args.sectionId,
        ),
        customRouteBuilder: _i10.sectionsCustomRouteBuilder,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          PrivacyRoute.name,
          path: '/privacy',
        ),
        _i6.RouteConfig(
          SupportRoute.name,
          path: '/support',
        ),
        _i6.RouteConfig(
          AboutRoute.name,
          path: '/about',
        ),
        _i6.RouteConfig(
          SectionsPageParent.name,
          path: '/',
          children: [
            _i6.RouteConfig(
              SectionsPageChild.name,
              path: '',
              parent: SectionsPageParent.name,
              guards: [redirectToBookmark],
            ),
            _i6.RouteConfig(
              SectionRoute.name,
              path: ':sectionId',
              parent: SectionsPageParent.name,
              guards: [checkIfSectionExists],
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.PrivacyPage]
class PrivacyRoute extends _i6.PageRouteInfo<void> {
  const PrivacyRoute()
      : super(
          PrivacyRoute.name,
          path: '/privacy',
        );

  static const String name = 'PrivacyRoute';
}

/// generated route for
/// [_i2.SupportPage]
class SupportRoute extends _i6.PageRouteInfo<void> {
  const SupportRoute()
      : super(
          SupportRoute.name,
          path: '/support',
        );

  static const String name = 'SupportRoute';
}

/// generated route for
/// [_i3.AboutPage]
class AboutRoute extends _i6.PageRouteInfo<void> {
  const AboutRoute()
      : super(
          AboutRoute.name,
          path: '/about',
        );

  static const String name = 'AboutRoute';
}

/// generated route for
/// [_i4.SectionsPage]
class SectionsPageParent extends _i6.PageRouteInfo<void> {
  const SectionsPageParent({List<_i6.PageRouteInfo>? children})
      : super(
          SectionsPageParent.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'SectionsPageParent';
}

/// generated route for
/// [_i4.SectionsPage]
class SectionsPageChild extends _i6.PageRouteInfo<void> {
  const SectionsPageChild()
      : super(
          SectionsPageChild.name,
          path: '',
        );

  static const String name = 'SectionsPageChild';
}

/// generated route for
/// [_i5.SectionPage]
class SectionRoute extends _i6.PageRouteInfo<SectionRouteArgs> {
  SectionRoute({
    _i7.Key? key,
    required int sectionId,
  }) : super(
          SectionRoute.name,
          path: ':sectionId',
          args: SectionRouteArgs(
            key: key,
            sectionId: sectionId,
          ),
          rawPathParams: {'sectionId': sectionId},
        );

  static const String name = 'SectionRoute';
}

class SectionRouteArgs {
  const SectionRouteArgs({
    this.key,
    required this.sectionId,
  });

  final _i7.Key? key;

  final int sectionId;

  @override
  String toString() {
    return 'SectionRouteArgs{key: $key, sectionId: $sectionId}';
  }
}
