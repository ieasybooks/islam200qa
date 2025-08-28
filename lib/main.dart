import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/palette.dart';
import 'package:islam200qa/router/guards/check_if_section_exists.dart';
import 'package:islam200qa/router/guards/redirect_to_bookmark.dart';
import 'package:islam200qa/strategies/url_strategy.dart';

import 'router/routes.gr.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  usePathUrlStrategy();
  runApp(Islam200QaApp());
}

class Islam200QaApp extends StatelessWidget {
  Islam200QaApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter(
    checkIfSectionExists: CheckIfSectionExists(),
    redirectToBookmark: RedirectToBookmark(),
  );

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      title: 'الإسلام في ٢٠٠ سؤال وجواب',
      theme: ThemeData(
        fontFamily: 'Amiri',
        primarySwatch: Palette.brown,
        useMaterial3: false,
      ),
    );
  }
}
