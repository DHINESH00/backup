import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:lte/shop/customer_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class start_bid extends StatefulWidget {
  final postData;
  const start_bid({Key? key, required this.postData}) : super(key: key);

  @override
  State<start_bid> createState() => _start_bidState(postData);
}

var time;
var datas;
var mrp;
GlobalKey<FormState> formkey = GlobalKey<FormState>();

class _start_bidState extends State<start_bid> {
  _start_bidState(postData) {
    datas = postData;
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Bid For " + datas["p_name"] + " " + datas["qnt"]),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Container(
            child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: formkey,
                child: ListView(
                  shrinkWrap: false,
                  children: [
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            mrp = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.price_change),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.all(16),
                            labelText: 'MRP',
                            hintText: 'Enter your Price for  Bidding'),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(1, errorText: "1")
                        ])),
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            time = value;
                          });
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.all(16),
                            labelText: ' Time taken to Deliver in Hour',
                            hintText: ''),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(1, errorText: "1 characters"),
                        ])),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            send_data(mrp, time, datas);
                          }
                        },
                        child: Text('Submit Form'),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  Future<void> send_data(mrp, time, datas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.update_bid'));
    request.body = json.encode({
      "post_name": {
        "shop": email,
        "mrp": mrp,
        "time": time.toString(),
        "name": datas["name"].toString()
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => custmer_post()));
    } else {
      print(response.reasonPhrase);
    }
  }
}
