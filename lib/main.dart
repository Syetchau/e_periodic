import 'package:e_periodic/Repo/SPHelper.dart';
import 'package:flutter/material.dart';

import 'View/home.dart';
import 'View/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString(SPHelper.userInfo);

  final appSupportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('fr'),
    Locale('es'),
    Locale('de'),
    Locale('ru'),
    Locale('ja'),
    Locale('ar'),
    Locale('fa'),
    Locale("es"),
  ];

  runApp(MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: appSupportedLocales,
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : HomePage(initialDate: DateTime.now())));
}
