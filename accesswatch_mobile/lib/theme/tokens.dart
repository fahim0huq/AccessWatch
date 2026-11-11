// Every colour and size of the app. Widgets read these; no hex values elsewhere.
import 'package:flutter/material.dart';

class AppColors {
  // Base: a soft violet-blue page, white surfaces, deep violet ink.
  static const groundTop = Color(0xFFDDE5FF);
  static const groundBottom = Color(0xFFEDE8FF);
  static const ground = Color(0xFFE6E6FF);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1B1640);
  static const inkSecondary = Color(0xFF4B4A75);
  static const brand = Color(0xFF5B3FD1);
  static const brandLight = Color(0xFF7A55F0);
  static const brandTint = Color(0xFFECE7FF);
  static const brandText = Color(0xFF3A22A0);
  static const line = Color(0xFFDCD6F5);
  static const surfaceMuted = Color(0xFFF1EEFF);

  // Meaning (data colours, unchanged in meaning).
  static const flood = Color(0xFF2F7DE1);
  static const floodFill = Color(0xFFA9CBF7);
  static const floodTint = Color(0xFFDCEBFD);
  static const floodText = Color(0xFF184A8C);
  static const boat = Color(0xFFB64E08);
  static const boatTint = Color(0xFFFFE6D2);
  static const boatText = Color(0xFF7A3A06);
  static const truck = Color(0xFF0B7A73);
  static const truckTint = Color(0xFFD5F3EF);
  static const truckText = Color(0xFF064E49);
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
  static const safestRoute = truck;
  static const shortestRoute = Color(0xFF8D5A3C);
  static const careRoute = Color(0xFFC026D3);
  static const me = Color(0xFF1D5FA8);
  static const mapBackground = Color(0xFFE6E8F5);

  // Road status on the map: who can still use each road piece.
  static const roadAnyCar = reach;
  static const roadHighClearance = truck;
  static const roadFootOnly = Color(0xFFC99A06);
  static const roadImpassable = danger;

  /// Soft violet shadow under cards, bars and floating buttons.
  static const shadow = Color(0x245B3FD1);
}

/// Gradients: the page, the violet hero and primary buttons, and the icon tiles.
class AppGradients {
  static const page = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.groundTop, AppColors.groundBottom],
  );
  static const brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand, AppColors.brandLight],
  );
  static const boatSolid = LinearGradient(colors: [AppColors.boat, AppColors.boat]);
  static const truckSolid = LinearGradient(colors: [AppColors.truck, AppColors.truck]);
  static const boatTile = LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.boatTint, Color(0xFFFFCBA4)]);
  static const truckTile = LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.truckTint, Color(0xFFA6E3DA)]);
  static const floodTile = LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.floodTint, AppColors.floodFill]);
  static const brandTile = LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.brandTint, Color(0xFFD5CAFF)]);
  static const neutralTile = LinearGradient(colors: [AppColors.surfaceMuted, AppColors.surfaceMuted]);
}

/// Soft violet page shadows.
class AppShadows {
  static const card = [BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 6))];
  static const floating = [BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 8))];
}

/// A status look: tint behind, dark text and icon in front. Never colour alone.
enum Tone {
  boat(AppColors.boatTint, AppColors.boatText, AppColors.boat, AppGradients.boatTile),
  truck(AppColors.truckTint, AppColors.truckText, AppColors.truck, AppGradients.truckTile),
  reach(AppColors.reachTint, AppColors.reachText, AppColors.reach, AppGradients.neutralTile),
  flood(AppColors.floodTint, AppColors.floodText, AppColors.flood, AppGradients.floodTile),
  brand(AppColors.brandTint, AppColors.brandText, AppColors.brand, AppGradients.brandTile),
  danger(AppColors.dangerTint, AppColors.dangerText, AppColors.danger, AppGradients.neutralTile),
  notice(AppColors.noticeTint, AppColors.noticeText, AppColors.notice, AppGradients.neutralTile),
  neutral(AppColors.surfaceMuted, AppColors.ink, AppColors.inkSecondary, AppGradients.neutralTile);

  final Color tint, text, strong;
  final Gradient tile;

  const Tone(this.tint, this.text, this.strong, this.tile);
}

class AppSizes {
  static const tap = 48.0;
  static const button = 54.0;
  static const cardRadius = 26.0;
  static const heroRadius = 28.0;
  static const chipRadius = 16.0;
  static const gutter = 16.0;
  static const iconTile = 54.0;
  static const barRadius = 36.0;
  static const barMargin = 14.0;
  static const watchButton = 60.0;
}

class AppFonts {
  static const family = 'Inter';
}
