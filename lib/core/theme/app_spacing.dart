class AppSpacing {
  AppSpacing._();

  // ─── Base Scale (4px grid) ──────────────────────────────────────────────
  static const double xs   =  4.0;
  static const double sm   =  8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 24.0;
  static const double x3l  = 30.0;
  static const double x4l  = 40.0;
  static const double x5l  = 50.0;
  static const double x6l  = 60.0;
  static const double x8l  = 78.0; // top padding on auth screens

  // ─── Screen Padding ─────────────────────────────────────────────────────
  static const double screenH = 30.0;
  static const double screenV = 12.0;

  // ─── Border Radii ───────────────────────────────────────────────────────
  static const double radiusXS   =  8.0;  // deck card corner
  static const double radiusSm   = 12.0;  // deck card, badge
  static const double radiusMd   = 16.0;  // session/active cards
  static const double radiusLg   = 20.0;  // place cards, modals
  static const double radiusXl   = 30.0;  // pill — buttons, inputs
  static const double radiusFull = 999.0; // avatars, circular buttons

  // ─── Component Heights ──────────────────────────────────────────────────
  static const double buttonHeightLg = 58.0; // primary gradient button
  static const double buttonHeightMd = 50.0; // gradient onboarding button
  static const double buttonWidthMd  = 330.0;

  // ─── Icon Sizes ─────────────────────────────────────────────────────────
  static const double iconXS = 14.0;
  static const double iconSm = 16.0;
  static const double iconMd = 22.0;
  static const double iconLg = 28.0;

  // ─── Avatar Sizes ───────────────────────────────────────────────────────
  static const double avatarSm    = 30.0; // group overlapping
  static const double avatarMd    = 40.0; // standard
  static const double avatarLg    = 52.0; // profile / session room
  static const double avatarOverlap = 22.0; // offset for group stacking

  // ─── PIN Boxes ──────────────────────────────────────────────────────────
  static const double pinBoxWidth  = 64.0;
  static const double pinBoxHeight = 72.0;
  static const double pinBoxRadius = 14.0;

  // ─── Swipe Action Buttons ───────────────────────────────────────────────
  static const double swipeBtnSm  = 48.0; // X and lightning
  static const double swipeBtnLg  = 62.0; // heart (larger center)

  // ─── Logo / Brand ───────────────────────────────────────────────────────
  static const double logoHeightAuth  = 108.0;
  static const double logoWidthAuth   = 130.0;
  static const double logoWidthSplash = 160.0;

  // ─── Card ───────────────────────────────────────────────────────────────
  static const double cardWidthPlace   = 280.0;
  static const double cardHeightPlace  = 250.0;
  static const double cardImageHeight  = 200.0;  // swipe room image
  static const double deckCardSize     = 104.0;  // deck select card
}
