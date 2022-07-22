import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:lte/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings_page.dart';
import 'cache_provider.dart';

var accentColor = ValueNotifier(Colors.blueAccent);

bool _isDarkTheme = false;

class settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  initState() {
    get_dark();
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

get_dark() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var dark = prefs.getBool('Dark');
  if (dark != null) {
    if (dark) {
      _isDarkTheme = true;
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: accentColor,
      builder: (_, color, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Settings',
        theme: _isDarkTheme
            ? ThemeData.dark().copyWith(accentColor: color)
            : ThemeData.light().copyWith(accentColor: color),
        home: Scaffold(
          appBar: AppBar(
            title: Text(""),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                _buildThemeSwitch(context),
                SizedBox(
                  height: 50.0,
                ),
                AppBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Light Theme'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: _isDarkTheme,
            onChanged: (newVal) {
              _isDarkTheme = newVal;
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 25.0,
        ),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('Dark', _isDarkTheme);
            openAppSettings(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void openAppSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DashboardScreen(),
    ));
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}

class HiveCache extends CacheProvider {
  @override
  bool? containsKey(String key) {
    // TODO: implement containsKey
    throw UnimplementedError();
  }

  @override
  bool? getBool(String key) {
    // TODO: implement getBool
    throw UnimplementedError();
  }

  @override
  double? getDouble(String key) {
    // TODO: implement getDouble
    throw UnimplementedError();
  }

  @override
  int? getInt(String key) {
    // TODO: implement getInt
    throw UnimplementedError();
  }

  @override
  Set? getKeys() {
    // TODO: implement getKeys
    throw UnimplementedError();
  }

  @override
  String? getString(String key) {
    // TODO: implement getString
    throw UnimplementedError();
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    // TODO: implement getValue
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> remove(String key) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<void> removeAll() {
    // TODO: implement removeAll
    throw UnimplementedError();
  }

  @override
  Future<void> setBool(String key, bool? value, {bool? defaultValue}) {
    // TODO: implement setBool
    throw UnimplementedError();
  }

  @override
  Future<void> setDouble(String key, double? value, {double? defaultValue}) {
    // TODO: implement setDouble
    throw UnimplementedError();
  }

  @override
  Future<void> setInt(String key, int? value, {int? defaultValue}) {
    // TODO: implement setInt
    throw UnimplementedError();
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    // TODO: implement setObject
    throw UnimplementedError();
  }

  @override
  Future<void> setString(String key, String? value, {String? defaultValue}) {
    // TODO: implement setString
    throw UnimplementedError();
  }
  //...
}
