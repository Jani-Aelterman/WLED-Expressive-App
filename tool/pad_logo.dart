import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // Read the rounded image
  final imagePath = 'AIgnore/RoundLogo.png';
  final bytes = File(imagePath).readAsBytesSync();
  final image = img.decodeImage(bytes);

  if (image == null) {
    print('Failed to decode image');
    return;
  }

  // Android 12+ requires the icon to be inside a "safe zone" (inner 2/3 of the canvas).
  // So the total canvas should be 1.5x the size of the image.
  final int newSize = (image.width * 1.5).round();
  final int offsetX = ((newSize - image.width) / 2).round();
  final int offsetY = ((newSize - image.height) / 2).round();

  // Create a new empty image with transparent background
  final result = img.Image(width: newSize, height: newSize, numChannels: 4);

  // Fill with transparent background
  for (int y = 0; y < newSize; y++) {
    for (int x = 0; x < newSize; x++) {
      result.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0));
    }
  }

  // Draw the original image onto the center of the new canvas
  img.compositeImage(result, image, dstX: offsetX, dstY: offsetY);

  // Save the image specifically for Android 12
  final outputPath = 'AIgnore/SplashLogoAndroid12.png';
  File(outputPath).writeAsBytesSync(img.encodePng(result));
  print('Successfully created padded logo at $outputPath');
}
