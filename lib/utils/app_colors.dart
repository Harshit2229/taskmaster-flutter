import 'package:flutter/material.dart';

/// Custom color palette for the TaskMaster app
/// This class contains all the colors used throughout the application
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary gradient colors (used in our app)
  static const Color primaryBlue = Color(0xFF667eea);
  static const Color primaryPurple = Color(0xFF764ba2);
  static const Color primaryPink = Color(0xFFf093fb);
  
  // Secondary colors (used in our app)
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53E3E);
  
  // Neutral colors (used in our app)
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  
  // Background colors (used in our app)
  static const Color backgroundLight = Color(0xFFf8f9ff);
  static const Color surfaceLight = Color(0xFFFAFAFA);
  
  // Text colors (used in our app)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  // Border colors (used in our app)
  static const Color borderLight = Color(0xFFE0E0E0);
  
  // Shadow colors (used in our app)
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  
  // Gradient definitions (used in our app)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryPurple, primaryPink],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, primaryPurple],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, backgroundLight],
  );
  
  // Helper methods for opacity variations (used in our app)
  static Color primaryBlueWithOpacity(double opacity) {
    return primaryBlue.withValues(alpha: opacity);
  }
  
  static Color whiteWithOpacity(double opacity) {
    return white.withValues(alpha: opacity);
  }
}