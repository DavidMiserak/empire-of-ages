import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'age_of_war_game.dart';

/// Landscape theme for the background.
enum LandscapeTheme { mountains, hills, caves, clouds, sky }

/// Helper to map LandscapeTheme to its asset prefix.
String _getAssetPrefix(LandscapeTheme theme) {
  return switch (theme) {
    LandscapeTheme.mountains => '17',
    LandscapeTheme.hills => '3',
    LandscapeTheme.caves => '11',
    LandscapeTheme.clouds => '4',
    LandscapeTheme.sky => '18',
  };
}

/// Background system managing parallax landscape layers for a level.
class BackgroundSystem extends Component with HasGameRef<AgeOfWarGame> {
  final LandscapeTheme theme;
  final List<int> layerIndices;
  final List<double> parallaxFactors;
  final Color? skyColor;

  /// Create a background system with given landscape theme.
  /// [layerIndices] specifies which asset images to use (1-based).
  /// [parallaxFactors] (0-1) control scroll depth per layer.
  /// [skyColor] optionally overlays a solid sky behind the landscape.
  BackgroundSystem({
    required this.theme,
    this.layerIndices = const [1, 2, 3],
    this.parallaxFactors = const [0.3, 0.6, 1.0],
    this.skyColor,
  }) : super(
    priority: -25,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final worldSize = Vector2(1200, 600);

    // Add sky color background if specified.
    if (skyColor != null) {
      add(RectangleComponent(
        size: worldSize,
        paint: Paint()..color = skyColor!,
        priority: -30,
      ));
    }

    // Add landscape layers in order (back to front).
    final themeName = theme.toString().split('.').last;
    final prefix = _getAssetPrefix(theme);

    debugPrint('BackgroundSystem.onLoad: theme=$themeName, prefix=$prefix, indices=$layerIndices');

    for (var i = 0; i < layerIndices.length; i++) {
      final imageIndex = layerIndices[i];
      final imagePath = 'landscapes/$themeName/Game_Assets_$prefix-${imageIndex.toString().padLeft(2, '0')}.png';

      try {
        debugPrint('Loading background image: $imagePath');
        final image = await game.images.load(imagePath);
        debugPrint('Loaded image $imagePath successfully, creating sprite component');

        final sprite = Sprite(image);
        add(SpriteComponent(
          sprite: sprite,
          size: worldSize,
          anchor: Anchor.topLeft,
          priority: -25 + i,
        ));
        debugPrint('Added SpriteComponent for $imagePath');
      } catch (e, st) {
        debugPrint('Failed to load background image $imagePath: $e');
        debugPrint('Stack trace: $st');

        // Add a fallback colored rectangle so the game doesn't crash
        add(RectangleComponent(
          size: worldSize,
          paint: Paint()..color = const Color(0xFF4A6FA5),
          priority: -25 + i,
        ));
      }
    }
  }
}
