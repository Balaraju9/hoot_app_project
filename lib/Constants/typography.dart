import 'package:flutter/material.dart';
import 'package:hoot/Constants/Colors.dart';

class AppTypography {
  static TextStyle mobileBodyText = const TextStyle(
    color: Colors.black,
    fontSize: 13,
    overflow: TextOverflow.fade,
    fontFamily: 'Lato',
  );

  static TextStyle mobileBodyTextWhite = const TextStyle(
    color: Colors.white,
    fontSize: 13,
    overflow: TextOverflow.fade,
    fontFamily: 'Lato',
  );

  static TextStyle tabBodyText = const TextStyle(
      color: Colors.black,
      fontSize: 18,
      overflow: TextOverflow.fade,
      fontFamily: 'Lato');

  static TextStyle tabBodyTextWhite = const TextStyle(
      color: Colors.white,
      fontSize: 18,
      overflow: TextOverflow.fade,
      fontFamily: 'Lato');

  static TextStyle textFieldTop = const TextStyle(
      color: Colors.black,
      overflow: TextOverflow.fade,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w500,
      fontSize: 15);

  static TextStyle cardSmallGreenText = TextStyle(
      color: AppColors.logoGreen,
      overflow: TextOverflow.fade,
      fontFamily: 'Lato',
      fontSize: 10);

  static TextStyle cardHeadingGreenText = TextStyle(
      color: AppColors.logoGreen,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.w500,
      fontFamily: 'Lato',
      fontSize: 18);
  static TextStyle cardNumbersGreenText = TextStyle(
      color: AppColors.logoGreen,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
      fontSize: 24);
  
  static TextStyle numbersGreenText = TextStyle(
      color: AppColors.logoGreen,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
      fontSize: 18);

  static TextStyle cardNumbersBlackext = const TextStyle(
      color: Colors.black,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
      fontSize: 24);

  static TextStyle tileHeadingBlackText = const TextStyle(
      color: Colors.black,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.w600,
      fontFamily: 'Lato',
      fontSize: 15);

  static TextStyle tileHeadingGreenText = TextStyle(
      color: AppColors.logoGreen,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.w600,
      fontFamily: 'Lato',
      fontSize: 18);

  static TextStyle trailingTextGreen = TextStyle(
      fontFamily: 'Lato',
      fontWeight: FontWeight.bold,
      color: AppColors.logoGreen,
      fontSize: 12);
  static TextStyle headingGreenBoldText = TextStyle(
      color: AppColors.logoGreen,
      overflow: TextOverflow.fade,
      fontWeight: FontWeight.bold,
      fontFamily: 'Lato',
      fontSize: 18);
}
