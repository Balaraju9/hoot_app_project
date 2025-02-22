// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hoot/Constants/Colors.dart';
import 'package:hoot/Constants/typography.dart';
import 'package:hoot/Screens/home_page.dart';
import 'package:sizer/sizer.dart';

final navigationKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext context, Orientation orientation,
        DeviceType deviceType) {
      return GetMaterialApp(
        title: "Technical Hub",
        theme: ThemeData(
            primaryColor: AppColors.logoLightGreen,
            primaryColorDark: AppColors.logoGreen,
            primarySwatch: Colors.green,
            fontFamily: "Lato",
            appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                titleTextStyle: AppTypography.tabBodyTextWhite,
                systemOverlayStyle: SystemUiOverlayStyle.dark),
          ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      );
    });
  }
}
