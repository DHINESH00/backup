import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lte/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

List? post_datas;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  var email = prefs.getString('email');
  var dark = prefs.getBool('Dark');
  
  print(dark);
  print(email);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark == null
          ? (ThemeData.light())
          : (dark ? ThemeData.dark() : ThemeData.light()),
      home: email == null || email == '' ? LoginScreen() : DashboardScreen()));
}

