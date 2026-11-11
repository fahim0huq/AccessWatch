import 'package:flutter/material.dart';

import 'tokens.dart';

export 'tokens.dart';

/// One light Material 3 theme in Inter: big type, 48 dp targets, 56 dp buttons.
class AppTheme {
  static const _text = TextTheme(
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.2),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.25),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.3),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.3),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.3),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.ink, height: 1.45),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.ink, height: 1.45),
    bodySmall: TextStyle(fontSize: 14, color: AppColors.inkSecondary, height: 1.4),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.2),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.2),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.2),
  );

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.brand,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.brandTint,
      onPrimaryContainer: AppColors.brandText,
      secondary: AppColors.brand,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.brandTint,
      onSecondaryContainer: AppColors.brandText,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkSecondary,
      surfaceContainerHighest: AppColors.surfaceMuted,
      outline: AppColors.line,
      outlineVariant: AppColors.line,
      error: AppColors.danger,
      onError: AppColors.surface,
    );
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.button / 2));
    const buttonSize = Size(AppSizes.tap, AppSizes.button);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppFonts.family,
      textTheme: _text,
      scaffoldBackgroundColor: AppColors.ground,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      appBarTheme: const AppBarTheme(
        // The page gradient shows through.
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: _text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          foregroundColor: AppColors.brand,
          side: const BorderSide(color: AppColors.brand, width: 1.5),
          textStyle: _text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSizes.tap, AppSizes.tap),
          foregroundColor: AppColors.brand,
          textStyle: _text.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(AppSizes.tap, AppSizes.tap)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.brandTint,
        side: const BorderSide(color: AppColors.line),
        labelStyle: _text.labelMedium!.copyWith(color: AppColors.ink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
          side: const BorderSide(color: AppColors.line),
        ),
        checkmarkColor: AppColors.brandText,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.brandTint,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => _text.labelMedium!.copyWith(
              color: states.contains(WidgetState.selected) ? AppColors.brandText : AppColors.inkSecondary,
              fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            )),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? AppColors.brandText : AppColors.inkSecondary,
            )),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: AppColors.surface, surfaceTintColor: Colors.transparent),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.cardRadius))),
      ),
      sliderTheme: const SliderThemeData(activeTrackColor: AppColors.brand, thumbColor: AppColors.brand),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.surface : AppColors.inkSecondary),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.brand : AppColors.surfaceMuted),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: _text.bodyMedium!.copyWith(color: AppColors.surface),
      ),
    );
  }
}
