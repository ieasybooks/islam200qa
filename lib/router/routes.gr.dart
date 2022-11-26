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
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../pages/about_page.dart' as _i2;
import '../pages/privacy_page.dart' as _i1;
import '../pages/section_page.dart' as _i4;
import '../pages/sections_page.dart' as _i3;
import 'guards/check_if_section_exists.dart' as _i8;
import 'guards/redirect_to_bookmark.dart' as _i7;
import 'routes.dart' as _i9;

class AppRouter extends _i5.RootStackRouter {
  AppRouter(
      {_i6.GlobalKey<_i6.NavigatorState>? navigatorKey,
      required this.redirectToBookmark,
      required this.checkIfSectionExists})
      : super(navigatorKey);

  final _i7.RedirectToBookmark redirectToBookmark;

  final _i8.CheckIfSectionExists checkIfSectionExists;

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    PrivacyRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.PrivacyPage());
    },
    AboutRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.AboutPage());
    },
    SectionsPageParent.name: (routeData) {
      return _i5.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i3.SectionsPage(),
          customRouteBuilder: _i9.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    },
    SectionsPageChild.name: (routeData) {
      return _i5.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i3.SectionsPage(),
          customRouteBuilder: _i9.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    },
    SectionRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SectionRouteArgs>(
          orElse: () =>
              SectionRouteArgs(sectionId: pathParams.getInt('sectionId')));
      return _i5.CustomPage<dynamic>(
          routeData: routeData,
          child: _i4.SectionPage(key: args.key, sectionId: args.sectionId),
          customRouteBuilder: _i9.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(PrivacyRoute.name, path: '/privacy'),
        _i5.RouteConfig(AboutRoute.name, path: '/about'),
        _i5.RouteConfig(SectionsPageParent.name, path: '/', children: [
          _i5.RouteConfig(SectionsPageChild.name,
              path: '',
              parent: SectionsPageParent.name,
              guards: [redirectToBookmark]),
          _i5.RouteConfig(SectionRoute.name,
              path: ':sectionId',
              parent: SectionsPageParent.name,
              guards: [checkIfSectionExists])
        ])
      ];
}

/// generated route for
/// [_i1.PrivacyPage]
class PrivacyRoute extends _i5.PageRouteInfo<void> {
  const PrivacyRoute() : super(PrivacyRoute.name, path: '/privacy');

  static const String name = 'PrivacyRoute';
}

/// generated route for
/// [_i2.AboutPage]
class AboutRoute extends _i5.PageRouteInfo<void> {
  const AboutRoute() : super(AboutRoute.name, path: '/about');

  static const String name = 'AboutRoute';
}

/// generated route for
/// [_i3.SectionsPage]
class SectionsPageParent extends _i5.PageRouteInfo<void> {
  const SectionsPageParent({List<_i5.PageRouteInfo>? children})
      : super(SectionsPageParent.name, path: '/', initialChildren: children);

  static const String name = 'SectionsPageParent';
}

/// generated route for
/// [_i3.SectionsPage]
class SectionsPageChild extends _i5.PageRouteInfo<void> {
  const SectionsPageChild() : super(SectionsPageChild.name, path: '');

  static const String name = 'SectionsPageChild';
}

/// generated route for
/// [_i4.SectionPage]
class SectionRoute extends _i5.PageRouteInfo<SectionRouteArgs> {
  SectionRoute({_i6.Key? key, required int sectionId})
      : super(SectionRoute.name,
            path: ':sectionId',
            args: SectionRouteArgs(key: key, sectionId: sectionId),
            rawPathParams: {'sectionId': sectionId});

  static const String name = 'SectionRoute';
}

class SectionRouteArgs {
  const SectionRouteArgs({this.key, required this.sectionId});

  final _i6.Key? key;

  final int sectionId;

  @override
  String toString() {
    return 'SectionRouteArgs{key: $key, sectionId: $sectionId}';
  }
}
