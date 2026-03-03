import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';

void main() {
  // Read the original image
  final imagePath = 'AIgnore/NewLogo.png';
  final bytes = File(imagePath).readAsBytesSync();
  final image = img.decodeImage(bytes);

  if (image == null) {
    print('Failed to decode image');
    return;
  }

  final int width = image.width;
  final int height = image.height;
  final int size = min(width, height);
  final double radius = size / 2;

  final centerX = width / 2;
  final centerY = height / 2;

  // Create a new empty image with transparent background
  final result = img.Image(width: size, height: size, numChannels: 4);

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      // Calculate original coordinates
      final origX = (centerX - radius + x).floor();
      final origY = (centerY - radius + y).floor();

      // Calculate distance from center to determine if point is inside circle
      final dx = x - (size / 2);
      final dy = y - (size / 2);
      final dist = sqrt(dx * dx + dy * dy);

      if (dist <= radius) {
        // Inside circle
        img.Pixel srcPixel = image.getPixelSafe(origX, origY);
        // Anti-aliasing logic on edges
        if (radius - dist < 1.0) {
          final alphaMultiplier = radius - dist;
          final num newAlpha = (srcPixel.a * alphaMultiplier).clamp(0, 255);
          result.setPixel(
              x,
              y,
              img.ColorRgba8(srcPixel.r.toInt(), srcPixel.g.toInt(),
                  srcPixel.b.toInt(), newAlpha.toInt()));
        } else {
          result.setPixel(x, y, srcPixel);
        }
      } else {
        // Outside circle (transparent)
        result.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
      }
    }
  }

  // Save the image
  final outputPath = 'AIgnore/RoundLogo.png';
  File(outputPath).writeAsBytesSync(img.encodePng(result));
  print('Successfully created round logo at $outputPath');
}
