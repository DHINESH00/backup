import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lte/shop/new_shop.dart';
import 'package:lte/shop/old_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String message_db = "";

class shop_dash extends StatefulWidget {
  const shop_dash({Key? key}) : super(key: key);

  @override
  State<shop_dash> createState() => _shop_dashState();
}

class _shop_dashState extends State<shop_dash> {
  @override
  void initState() {
    get_shop_status();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(message_db);
    return Scaffold(
        appBar: AppBar(
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: const Text("Your Post"),
            backgroundColor: Colors.blue),
        body: Center(
            child: message_db == ""
                ? Text(
                    'Please Wait',
                    style: Theme.of(context).textTheme.headline4,
                  )
                : (message_db == "in verification"
                    ? Text(
                        'Verification \n In Progress',
                        style: Theme.of(context).textTheme.headline4,
                      )
                    : Text(
                        "Loading",
                        style: Theme.of(context).textTheme.headline4,
                      ))));
  }

  Future<void> get_shop_status() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.shop_present'));
    request.body = json.encode({
      "data": {"email": email}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message = jsonDecode(await response.stream.bytesToString())["message"]
          .toString();
      setState(() {
        message_db = message;
        print(message_db);
      });
      if (message == "new shop") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => new_shop()));
      }
      if (message == "sucessfull") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => old_shop()));
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
