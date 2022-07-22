import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:lte/dashboard_screen.dart';
import 'package:otp_screen/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'login.dart';

import 'package:http/http.dart' as http;

class otp_n extends StatefulWidget {
  @override
  State<otp_n> createState() => _otpState();
}

var otp_val;

class _otpState extends State<otp_n> {
  @override
  initState() {
    get_otp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialize the OTP screen by passing validation logic and route callback
      home: OtpScreen(
        otpLength: 4,
        subTitle: "please enter the OTP sent to your\n Email",
        validateOtp: validateOtp,
        routeCallback: moveToNextScreen,
        titleColor: Colors.black,
        themeColor: Colors.black,
      ),
    );
  }
}

get_otp() async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie':
        'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
  };
  var request = http.Request(
      'POST',
      Uri.parse(
          'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.otp'));
  request.body = json.encode({
    "data": {
      "email": user.name,
    }
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

Future<String?> validateOtp(String otp) async {
  print("1");
  var headers = {
    'Content-Type': 'application/json',
    'Cookie':
        'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
  };
  print(headers);
  var request = http.Request(
      'POST',
      Uri.parse(
          'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.get_otp'));
  print(request);
  request.body = json.encode({
    "data": {"email": user.name, "otp": otp, "password": user.password}
  });
  print(request);
  request.headers.addAll(headers);
  print("2");

  http.StreamedResponse response = await request.send();
  print(response);
  print("3");
  if (response.statusCode == 200) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user.name);
    print("4");

    return null;
  } else {
    return "The entered Otp is wrong";
  }
}

// action to be performed after OTP validation is success
Future<void> moveToNextScreen(context) async {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => DashboardScreen()));
}
