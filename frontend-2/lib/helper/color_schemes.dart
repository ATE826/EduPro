import 'package:flutter/material.dart';

/// Добавляйте цвета по необходмости, в соответствии с рекомендациями из
/// документации Material Design:
/// `https://m2.material.io/design/color/the-color-system.html#color-theme-creation`
/// Для быстрого понимания наведите на название поле, которому задаете цвет
/// Там есть справка, разъясняющая, в каких сценариях применяется цвет.
/// кроме того, просьба придерживаться логичности наименований. Если цвет
/// используется для фона контейнера - используйте ***Container, если это
/// вариант другого цвета, используйте ***Variant

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  /// основной цвет приложения (кнопки, иконки, индикаторы)
  primary: Color(0xFFF0BC1A),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFECB4),
  onPrimaryContainer: Color(0xFFEAA510),

  /// второстепенный цвет
  secondary: Color(0xFF2DA71A),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF44C030),
  onSecondaryContainer: Color(0xFF67CF57),

  /// Серый цвет и оттенки
  tertiary: Color(0xFFA1A1A1),
  tertiaryContainer: Color(0xFFE8E8E8),
  onTertiaryContainer: Color(0xFFA1A1A1),

  /// ошибки
  error: Color(0xFFF54A4A),
  onError: Color(0xFFF9F9F9),
  errorContainer: Color(0xFFFFEDED),
  onErrorContainer: Color(0xFFF54A4A),

  /// цвет фона / поверхности
  surface: Color(0xFFF9F9F9),
  onSurface: Color(0xFF363636),
  onSurfaceVariant: Colors.black,
  surfaceContainerHighest: Colors.white,
);

const ColorScheme lightContrastColorScheme = ColorScheme(
  brightness: Brightness.light,

  /// основной цвет приложения (кнопки, иконки, индикаторы)
  primary: Colors.black,
  onPrimary: Colors.white,
  primaryContainer: Colors.white,
  onPrimaryContainer: Colors.black,

  /// второстепенный цвет
  secondary: Colors.black,
  onSecondary: Colors.white,
  secondaryContainer: Colors.black,
  onSecondaryContainer: Colors.white,

  /// Серый цвет и оттенки
  tertiary: Colors.black,
  tertiaryContainer: Colors.white,
  onTertiaryContainer: Colors.black,

  /// ошибки
  error: Colors.black,
  onError: Colors.white,
  errorContainer: Colors.white,
  onErrorContainer: Colors.black,

  /// цвет фона / поверхности
  surface: Colors.white,
  onSurface: Colors.black,
  onSurfaceVariant: Colors.black,
  surfaceContainerHighest: Colors.white,
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  /// основной цвет приложения (кнопки, иконки, индикаторы)
  primary: Color(0xFFF0BC1A),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFECB4),
  onPrimaryContainer: Color(0xFFEAA510),

  /// второстепенный цвет
  secondary: Color(0xFF135F06),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF44C030),
  onSecondaryContainer: Color(0xFF135F06),

  /// Серый цвет и оттенки
  tertiary: Color(0xFF525252),
  tertiaryContainer: Color(0xFF525252),
  onTertiaryContainer: Color(0xFFA1A1A1),

  /// ошибки
  error: Color(0xFFCE3838),
  onError: Color(0xFFF9F9F9),
  errorContainer: Color(0xFFF5DADA),
  onErrorContainer: Color(0xFFCE3838),

  /// цвет фона / поверхности
  surface: Color(0xFF1C1C1C),
  onSurface: Color(0xFFF3F3F3),
  onSurfaceVariant: Color(0xFFF3F3F3),
  surfaceContainerHighest: Color(0xFF363636),
);

const ColorScheme darkContrastColorScheme = ColorScheme(
  brightness: Brightness.dark,

  /// основной цвет приложения (кнопки, иконки, индикаторы)
  primary: Colors.white,
  onPrimary: Colors.black,
  primaryContainer: Colors.black,
  onPrimaryContainer: Colors.white,

  /// второстепенный цвет
  secondary: Colors.white,
  onSecondary: Colors.black,
  secondaryContainer: Colors.white,
  onSecondaryContainer: Colors.black,

  /// Серый цвет и оттенки
  tertiary: Colors.white,
  tertiaryContainer: Colors.black,
  onTertiaryContainer: Colors.white,

  /// ошибки
  error: Colors.pink,
  onError: Colors.black,
  errorContainer: Colors.black,
  onErrorContainer: Colors.white,

  /// цвет фона / поверхности
  surface: Colors.black,
  onSurface: Colors.white,
  onSurfaceVariant: Colors.white,
  surfaceContainerHighest: Colors.black,
);
