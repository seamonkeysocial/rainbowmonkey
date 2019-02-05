import 'dart:ui';

const Size shipSize = Size(384.25, 91.264);

/// Paints a ship at 0,0.
///
/// The dimensions of the ship are given by [shipSize].
Path ship() {
  return Path()
    ..moveTo(348.291, 91.263)
    ..cubicTo(353.396, 81.653, 384.249, 57.615, 384.249, 57.615)
    ..lineTo(336.006, 57.615)
    ..cubicTo(336.006, 57.615, 318.345, 38.831, 307.627, 33.088)
    ..lineTo(307.627, 33.088)
    ..cubicTo(307.627, 33.088, 307.883, 29.277, 309.451, 27.21)
    ..cubicTo(310.566, 25.74, 302.762, 24.169, 295.87, 24.169)
    ..cubicTo(295.87, 24.169, 296.126, 20.358, 297.694, 18.29)
    ..cubicTo(298.809, 16.821, 291.006, 15.25, 284.113, 15.25)
    ..lineTo(145.681, 15.25)
    ..lineTo(116.923, 0.0)
    ..lineTo(101.27, 0.0)
    ..lineTo(116.52, 15.25)
    ..lineTo(84.159, 15.25)
    ..lineTo(68.909, 0.0)
    ..lineTo(64.084, 0.0)
    ..lineTo(68.296, 15.25)
    ..lineTo(47.497, 15.25)
    ..cubicTo(40.605, 15.25, 32.801, 16.821, 33.916, 18.29)
    ..cubicTo(35.485, 20.358, 35.74, 24.169, 35.74, 24.169)
    ..cubicTo(39.305, 24.169, 41.078, 26.264, 41.078, 26.264)
    ..cubicTo(40.171, 26.264, 36.197, 28.666, 31.079, 32.214)
    ..lineTo(48.548, 32.214)
    ..cubicTo(49.078, 32.214, 49.32, 32.874, 48.916, 33.217)
    ..lineTo(45.66, 35.974)
    ..cubicTo(45.561, 36.061, 45.431, 36.109, 45.295, 36.109)
    ..lineTo(25.635, 36.109)
    ..cubicTo(23.823, 37.444, 21.962, 38.851, 20.107, 40.296)
    ..lineTo(37.372, 40.296)
    ..cubicTo(37.902, 40.296, 38.145, 40.957, 37.741, 41.301)
    ..lineTo(34.488, 44.057)
    ..cubicTo(34.385, 44.144, 34.255, 44.192, 34.12, 44.192)
    ..lineTo(15.243, 44.192)
    ..cubicTo(13.534, 45.601, 11.888, 47.006, 10.35, 48.379)
    ..lineTo(28.227, 48.379)
    ..cubicTo(28.757, 48.379, 29.0, 49.041, 28.595, 49.384)
    ..lineTo(25.344, 52.138)
    ..cubicTo(25.241, 52.225, 25.111, 52.273, 24.975, 52.273)
    ..lineTo(6.209, 52.273)
    ..cubicTo(4.211, 54.278, 2.638, 56.1, 1.677, 57.616)
    ..lineTo(1.671, 57.615)
    ..cubicTo(1.013, 58.654, 0.639, 59.552, 0.639, 60.25)
    ..cubicTo(0.639, 78.696, 7.632, 87.717, 7.632, 87.717)
    ..cubicTo(3.764, 88.954, 1.397, 90.269, 0.0, 91.264)
    ..close();
}
