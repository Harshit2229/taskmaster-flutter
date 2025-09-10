import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text styles used throughout the TaskMaster app
/// This class provides consistent typography across the application
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // App bar and navigation (used in our app)
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 2.0,
  );

  static const TextStyle appBarSubtitle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  // Splash screen (used in our app)
  static const TextStyle splashTitle = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 2.0,
  );

  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: 1.0,
  );

  // Task related (used in our app)
  static const TextStyle taskTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskTitleCompleted = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle taskCounter = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Dialog (used in our app)
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
  );

  static const TextStyle dialogHint = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle dialogInput = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Empty state (used in our app)
  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
  );

  static const TextStyle emptyStateSubtitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Button text (used in our app)
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Label text (used in our app)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
