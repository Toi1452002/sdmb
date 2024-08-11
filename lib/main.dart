import 'dart:io';
import 'dart:ui';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sdmb/config/info_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();

  /// Lấy version của app
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  APP_VERSION = packageInfo.version;

  runApp(const MyApp());

  /// Nếu là window thì sài sql_common_ffi
  if(Platform.isWindows){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2)
        ))
    );
    double scaleText = MediaQuery.textScalerOf(context).scale(1);

    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                fontSize: 16/scaleText
            ),
            bodyMedium: TextStyle(
                fontSize: 16/scaleText
            ),
            bodySmall: TextStyle(
                fontSize: 16/scaleText
            ),


          ),
        appBarTheme: AppBarTheme(
          color: Colors.teal.shade300
        ),
        drawerTheme: DrawerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          )
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,

        ),
        scaffoldBackgroundColor: Colors.teal.shade50,
        colorSchemeSeed: Colors.white,
        dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
          backgroundColor: Colors.teal.shade100
        ),
        dialogBackgroundColor: Colors.white,
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),

        ),
        cardTheme: CardTheme(
          color: Colors.teal[100],
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: buttonStyle
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: buttonStyle
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: buttonStyle
        )
      ),
      initialRoute: '/login',
      getPages: getPages(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:const [
        // Locale('en', ''),
        Locale('vi', ''), // arabic, no country code
      ],
      builder: (context, _) {
        var child = _!;
        child = Toast(navigatorKey: navigatorKey, child: child);
        return child;
      },
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

