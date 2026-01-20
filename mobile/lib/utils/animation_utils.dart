import 'package:flutter/material.dart';

class AnimationUtils {
  // Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);
  static const Duration entranceDuration = Duration(milliseconds: 1000);

  // Curves
  static const Curve defaultCurve = Curves.easeOutQuart;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeOutExpo;

  // Staggered Animation Delay per item
  static const int staggeredDelay = 100; // ms

  // Common styles
  static const double scaleOnTap = 0.98;
}
