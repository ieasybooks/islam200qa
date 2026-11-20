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
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../pages/about_page.dart' as _i1;
import '../pages/privacy_page.dart' as _i2;
import '../pages/section_page.dart' as _i6;
import '../pages/sections_page.dart' as _i5;
import '../pages/support_page.dart' as _i4;
import '../pages/terms_page.dart' as _i3;
import 'guards/check_if_section_exists.dart' as _i10;
import 'guards/redirect_to_bookmark.dart' as _i9;
import 'routes.dart' as _i11;

class AppRouter extends _i7.RootStackRouter {
  AppRouter({
    _i8.GlobalKey<_i8.NavigatorState>? navigatorKey,
    required this.redirectToBookmark,
    required this.checkIfSectionExists,
  }) : super(navigatorKey);

  final _i9.RedirectToBookmark redirectToBookmark;

  final _i10.CheckIfSectionExists checkIfSectionExists;

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    AboutRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.AboutPage(),
      );
    },
    PrivacyRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.PrivacyPage(),
      );
    },
    TermsRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.TermsPage(),
      );
    },
    SupportRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.SupportPage(),
      );
    },
    EnglishAboutRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.EnglishAboutPage(),
      );
    },
    EnglishPrivacyRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EnglishPrivacyPage(),
      );
    },
    EnglishTermsRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.EnglishTermsPage(),
      );
    },
    EnglishSupportRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.EnglishSupportPage(),
      );
    },
    SectionsPageParent.name: (routeData) {
      return _i7.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.SectionsPage(),
        customRouteBuilder: _i11.sectionsCustomRouteBuilder,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SectionsPageChild.name: (routeData) {
      return _i7.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.SectionsPage(),
        customRouteBuilder: _i11.sectionsCustomRouteBuilder,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SectionRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SectionRouteArgs>(
          orElse: () =>
              SectionRouteArgs(sectionId: pathParams.getInt('sectionId')));
      return _i7.CustomPage<dynamic>(
        routeData: routeData,
        child: _i6.SectionPage(
          key: args.key,
          sectionId: args.sectionId,
        ),
        customRouteBuilder: _i11.sectionsCustomRouteBuilder,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          AboutRoute.name,
          path: '/about',
        ),
        _i7.RouteConfig(
          PrivacyRoute.name,
          path: '/privacy',
        ),
        _i7.RouteConfig(
          TermsRoute.name,
          path: '/terms',
        ),
        _i7.RouteConfig(
          SupportRoute.name,
          path: '/support',
        ),
        _i7.RouteConfig(
          EnglishAboutRoute.name,
          path: '/en/about',
        ),
        _i7.RouteConfig(
          EnglishPrivacyRoute.name,
          path: '/en/privacy',
        ),
        _i7.RouteConfig(
          EnglishTermsRoute.name,
          path: '/en/terms',
        ),
        _i7.RouteConfig(
          EnglishSupportRoute.name,
          path: '/en/support',
        ),
        _i7.RouteConfig(
          SectionsPageParent.name,
          path: '/',
          children: [
            _i7.RouteConfig(
              SectionsPageChild.name,
              path: '',
              parent: SectionsPageParent.name,
              guards: [redirectToBookmark],
            ),
            _i7.RouteConfig(
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
/// [_i1.AboutPage]
class AboutRoute extends _i7.PageRouteInfo<void> {
  const AboutRoute()
      : super(
          AboutRoute.name,
          path: '/about',
        );

  static const String name = 'AboutRoute';
}

/// generated route for
/// [_i2.PrivacyPage]
class PrivacyRoute extends _i7.PageRouteInfo<void> {
  const PrivacyRoute()
      : super(
          PrivacyRoute.name,
          path: '/privacy',
        );

  static const String name = 'PrivacyRoute';
}

/// generated route for
/// [_i3.TermsPage]
class TermsRoute extends _i7.PageRouteInfo<void> {
  const TermsRoute()
      : super(
          TermsRoute.name,
          path: '/terms',
        );

  static const String name = 'TermsRoute';
}

/// generated route for
/// [_i4.SupportPage]
class SupportRoute extends _i7.PageRouteInfo<void> {
  const SupportRoute()
      : super(
          SupportRoute.name,
          path: '/support',
        );

  static const String name = 'SupportRoute';
}

/// generated route for
/// [_i1.EnglishAboutPage]
class EnglishAboutRoute extends _i7.PageRouteInfo<void> {
  const EnglishAboutRoute()
      : super(
          EnglishAboutRoute.name,
          path: '/en/about',
        );

  static const String name = 'EnglishAboutRoute';
}

/// generated route for
/// [_i2.EnglishPrivacyPage]
class EnglishPrivacyRoute extends _i7.PageRouteInfo<void> {
  const EnglishPrivacyRoute()
      : super(
          EnglishPrivacyRoute.name,
          path: '/en/privacy',
        );

  static const String name = 'EnglishPrivacyRoute';
}

/// generated route for
/// [_i3.EnglishTermsPage]
class EnglishTermsRoute extends _i7.PageRouteInfo<void> {
  const EnglishTermsRoute()
      : super(
          EnglishTermsRoute.name,
          path: '/en/terms',
        );

  static const String name = 'EnglishTermsRoute';
}

/// generated route for
/// [_i4.EnglishSupportPage]
class EnglishSupportRoute extends _i7.PageRouteInfo<void> {
  const EnglishSupportRoute()
      : super(
          EnglishSupportRoute.name,
          path: '/en/support',
        );

  static const String name = 'EnglishSupportRoute';
}

/// generated route for
/// [_i5.SectionsPage]
class SectionsPageParent extends _i7.PageRouteInfo<void> {
  const SectionsPageParent({List<_i7.PageRouteInfo>? children})
      : super(
          SectionsPageParent.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'SectionsPageParent';
}

/// generated route for
/// [_i5.SectionsPage]
class SectionsPageChild extends _i7.PageRouteInfo<void> {
  const SectionsPageChild()
      : super(
          SectionsPageChild.name,
          path: '',
        );

  static const String name = 'SectionsPageChild';
}

/// generated route for
/// [_i6.SectionPage]
class SectionRoute extends _i7.PageRouteInfo<SectionRouteArgs> {
  SectionRoute({
    _i8.Key? key,
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

  final _i8.Key? key;

  final int sectionId;

  @override
  String toString() {
    return 'SectionRouteArgs{key: $key, sectionId: $sectionId}';
  }
}
