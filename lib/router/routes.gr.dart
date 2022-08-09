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
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../pages/section_page.dart' as _i2;
import '../pages/sections_page.dart' as _i1;
import 'guards/check_if_section_exists.dart' as _i5;
import 'routes.dart' as _i6;

class AppRouter extends _i3.RootStackRouter {
  AppRouter(
      {_i4.GlobalKey<_i4.NavigatorState>? navigatorKey,
      required this.checkIfSectionExists})
      : super(navigatorKey);

  final _i5.CheckIfSectionExists checkIfSectionExists;

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    SectionsRoute.name: (routeData) {
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.SectionsPage(),
          customRouteBuilder: _i6.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    },
    SectionRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SectionRouteArgs>(
          orElse: () =>
              SectionRouteArgs(sectionId: pathParams.getInt('sectionId')));
      return _i3.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.SectionPage(key: args.key, sectionId: args.sectionId),
          customRouteBuilder: _i6.sectionsCustomRouteBuilder,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(SectionsRoute.name, path: '/', children: [
          _i3.RouteConfig('#redirect',
              path: '',
              parent: SectionsRoute.name,
              redirectTo: '1',
              fullMatch: true),
          _i3.RouteConfig(SectionRoute.name,
              path: ':sectionId',
              parent: SectionsRoute.name,
              guards: [checkIfSectionExists])
        ])
      ];
}

/// generated route for
/// [_i1.SectionsPage]
class SectionsRoute extends _i3.PageRouteInfo<void> {
  const SectionsRoute({List<_i3.PageRouteInfo>? children})
      : super(SectionsRoute.name, path: '/', initialChildren: children);

  static const String name = 'SectionsRoute';
}

/// generated route for
/// [_i2.SectionPage]
class SectionRoute extends _i3.PageRouteInfo<SectionRouteArgs> {
  SectionRoute({_i4.Key? key, required int sectionId})
      : super(SectionRoute.name,
            path: ':sectionId',
            args: SectionRouteArgs(key: key, sectionId: sectionId),
            rawPathParams: {'sectionId': sectionId});

  static const String name = 'SectionRoute';
}

class SectionRouteArgs {
  const SectionRouteArgs({this.key, required this.sectionId});

  final _i4.Key? key;

  final int sectionId;

  @override
  String toString() {
    return 'SectionRouteArgs{key: $key, sectionId: $sectionId}';
  }
}
