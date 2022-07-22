import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:otp_screen/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'Otp_screen.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

var user;
var type;

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    user = data;
    type = "login";
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    user = data;
    type = "signup";
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'MY BID',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () async {
        var headers = {
          'Content-Type': 'application/json',
          'Cookie':
              'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
        };
        var request = http.Request(
            'POST',
            Uri.parse(
                'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.sigup'));
        request.body = json.encode({
          "data": {
            "email": user.name,
            "password": user.password,
            "type": type,
          }
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var message =
              jsonDecode(await response.stream.bytesToString())["message"];
          if (message == "New User") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => otp_n()));
          } else if (message == "true") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', user.name);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          } else {
            if (message == "Email exist") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Email Already Exists \n Please Login')));
            } else if (message == "false") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Wrong Username or Password \n Please Try Again')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please Try After Sometime')));
            }
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          }
        } else {
          print(response.reasonPhrase);
        }
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
