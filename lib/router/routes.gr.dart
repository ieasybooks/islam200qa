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
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../pages/privacy_page.dart' as _i1;
import '../pages/section_page.dart' as _i3;
import '../pages/sections_page.dart' as _i2;
import 'guards/check_if_section_exists.dart' as _i6;
import 'routes.dart' as _i7;

class AppRouter extends _i4.RootStackRouter {
  AppRouter(
      {_i5.GlobalKey<_i5.NavigatorState>? navigatorKey,
      required this.checkIfSectionExists})
      : super(navigatorKey);

  final _i6.CheckIfSectionExists checkIfSectionExists;

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    PrivacyRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.PrivacyPage());
    },
    SectionsRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.SectionsPage(),
          customRouteBuilder: _i7.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    },
    SectionRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SectionRouteArgs>(
          orElse: () =>
              SectionRouteArgs(sectionId: pathParams.getInt('sectionId')));
      return _i4.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.SectionPage(key: args.key, sectionId: args.sectionId),
          customRouteBuilder: _i7.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(PrivacyRoute.name, path: '/privacy'),
        _i4.RouteConfig(SectionsRoute.name, path: '/', children: [
          _i4.RouteConfig('#redirect',
              path: '',
              parent: SectionsRoute.name,
              redirectTo: '1',
              fullMatch: true),
          _i4.RouteConfig(SectionRoute.name,
              path: ':sectionId',
              parent: SectionsRoute.name,
              guards: [checkIfSectionExists])
        ])
      ];
}

/// generated route for
/// [_i1.PrivacyPage]
class PrivacyRoute extends _i4.PageRouteInfo<void> {
  const PrivacyRoute() : super(PrivacyRoute.name, path: '/privacy');

  static const String name = 'PrivacyRoute';
}

/// generated route for
/// [_i2.SectionsPage]
class SectionsRoute extends _i4.PageRouteInfo<void> {
  const SectionsRoute({List<_i4.PageRouteInfo>? children})
      : super(SectionsRoute.name, path: '/', initialChildren: children);

  static const String name = 'SectionsRoute';
}

/// generated route for
/// [_i3.SectionPage]
class SectionRoute extends _i4.PageRouteInfo<SectionRouteArgs> {
  SectionRoute({_i5.Key? key, required int sectionId})
      : super(SectionRoute.name,
            path: ':sectionId',
            args: SectionRouteArgs(key: key, sectionId: sectionId),
            rawPathParams: {'sectionId': sectionId});

  static const String name = 'SectionRoute';
}

class SectionRouteArgs {
  const SectionRouteArgs({this.key, required this.sectionId});

  final _i5.Key? key;

  final int sectionId;

  @override
  String toString() {
    return 'SectionRouteArgs{key: $key, sectionId: $sectionId}';
  }
}
