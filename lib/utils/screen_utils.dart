import 'package:flutter/material.dart';

enum ScreenSize { Small, Normal, Large, ExtraLarge }

double getDeviceHeight(final BuildContext context) => MediaQuery.of(context).size.height;

double getDeviceWidth(final BuildContext context) => MediaQuery.of(context).size.width;

ScreenSize getScreenSize(final BuildContext context) {
  double deviceWidth = getDeviceWidth(context);
  if (deviceWidth > 900) return ScreenSize.ExtraLarge;
  if (deviceWidth > 600) return ScreenSize.Large;
  if (deviceWidth > 300) return ScreenSize.Normal;
  return ScreenSize.Small;
}

double getHorizontalPaddingPercentageByScreenSize(final ScreenSize screenSize) {
  switch (screenSize) {
    case ScreenSize.ExtraLarge: return 0.15;
    case ScreenSize.Large: return 0.1;
    case ScreenSize.Normal:
    case ScreenSize.Small: return 0.025;
  }
}
