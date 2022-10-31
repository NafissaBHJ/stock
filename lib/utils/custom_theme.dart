import 'package:fluent_ui/fluent_ui.dart';

import 'package:system_theme/system_theme.dart';

ThemeData CustomLightTheme(BuildContext context) {
  final ThemeData lightTheme = ThemeData.light();

  return lightTheme.copyWith(
      accentColor: AccentColor.swatch({
    'darkest': SystemTheme.accentColor.darkest,
    'darker': SystemTheme.accentColor.darker,
    'dark': SystemTheme.accentColor.dark,
    'normal': SystemTheme.accentColor.accent,
    'light': SystemTheme.accentColor.light,
    'lighter': SystemTheme.accentColor.lighter,
    'lightest': SystemTheme.accentColor.lightest,
  }));
}

ThemeData CustomDarkTheme(BuildContext context) {
  final ThemeData darkTheme = ThemeData.dark();

  return darkTheme.copyWith(
      accentColor: AccentColor.swatch({
    'darkest': SystemTheme.accentColor.darkest,
    'darker': SystemTheme.accentColor.darker,
    'dark': SystemTheme.accentColor.dark,
    'normal': SystemTheme.accentColor.accent,
    'light': SystemTheme.accentColor.light,
    'lighter': SystemTheme.accentColor.lighter,
    'lightest': SystemTheme.accentColor.lightest,
  }));
}
