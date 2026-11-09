// Every colour and size of the app. Widgets read these; no hex values elsewhere.
import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const ground = Color(0xFFF4F9F8);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0F2A2E);
  static const inkSecondary = Color(0xFF3F5A5E);
  static const brand = Color(0xFF0B6E6E);
  static const line = Color(0xFFD3E2E0);
  static const surfaceMuted = Color(0xFFE8F1F0);

  // Meaning
  static const flood = Color(0xFF4F9AE0);
  static const floodFill = Color(0xFF8CC0EE);
  static const boat = Color(0xFFB64E08);
  static const boatTint = Color(0xFFFDEBDD);
  static const boatText = Color(0xFF7A3A06);
  static const truck = Color(0xFF0B6E6E);
  static const truckTint = Color(0xFFD7EEEC);
  static const truckText = Color(0xFF0A4F4F);
  static const reach = Color(0xFF17603B);
  static const reachTint = Color(0xFFDDF3E6);
  static const reachText = Color(0xFF17603B);
  static const danger = Color(0xFF8F1D14);
  static const dangerTint = Color(0xFFFCE3E0);
  static const dangerText = Color(0xFF8F1D14);
  static const notice = Color(0xFF5C4300);
  static const noticeTint = Color(0xFFFFF4CC);
  static const noticeText = Color(0xFF5C4300);
  static const cautionTint = Color(0xFFFFF3E6);

  // Map drawing: the notebook's depth palette and the route lines.
  static const floodShallow = Color(0xFF9ECAE1);
  static const floodMedium = Color(0xFF3182BD);
  static const floodDeep = Color(0xFF08306B);
  static const floodBaseline = Color(0xFF7C3AED);
  static const safestRoute = Color(0xFF0B6E6E);
  static const shortestRoute = Color(0xFF8D5A3C);
  static const careRoute = Color(0xFFC026D3);
  static const me = Color(0xFF1D5FA8);
  static const mapBackground = Color(0xFFE3ECEB);
  static const shadow = Color(0x22000000);
}

/// A status look: tint behind, dark text and icon in front. Never colour alone.
enum Tone {
  boat(AppColors.boatTint, AppColors.boatText, AppColors.boat),
  truck(AppColors.truckTint, AppColors.truckText, AppColors.truck),
  reach(AppColors.reachTint, AppColors.reachText, AppColors.reach),
  danger(AppColors.dangerTint, AppColors.dangerText, AppColors.danger),
  notice(AppColors.noticeTint, AppColors.noticeText, AppColors.notice),
  neutral(AppColors.surfaceMuted, AppColors.ink, AppColors.inkSecondary);

  final Color tint, text, strong;

  const Tone(this.tint, this.text, this.strong);
}

class AppSizes {
  static const tap = 48.0;
  static const button = 56.0;
  static const cardRadius = 20.0;
  static const chipRadius = 12.0;
  static const gutter = 16.0;
}

class AppFonts {
  static const family = 'Inter';
}
