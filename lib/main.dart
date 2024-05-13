import 'package:dhan_prabandh/common/color_extension.dart';
import 'package:dhan_prabandh/db/database_helper.dart';
import 'package:dhan_prabandh/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';

// for windows and linux plateform run
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart'

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  // await Future.delayed(
  //   const Duration(seconds: 10),
  // );
  // FlutterNativeSplash.remove();

  // Check if the platform is Windows or Linux
  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  //  databaseFactory = databaseFactoryFfi;
  // }

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseHelper().initDB();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackerized',
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
          background: TColor.gray80,
          primary: TColor.primary,
          primaryContainer: TColor.gray60,
          secondary: TColor.secondary,
        ),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
