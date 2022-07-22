import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:lte/dashboard_screen.dart';

class add_adress extends StatefulWidget {
  final postData;
  final places;
  const add_adress({Key? key, required this.postData, required this.places})
      : super(key: key);

  @override
  State<add_adress> createState() => _add_adressState(postData, places);
}

var datas;
var adress1;
var Order;
var pincode;
var city;
GlobalKey<FormState> formkey = GlobalKey<FormState>();

class _add_adressState extends State<add_adress> {
  _add_adressState(postData, places) {
    datas = postData;
    Order = places;
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
          title: Text("Address"),
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
                child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: formkey,
                    child: ListView(shrinkWrap: true, children: [
                      TextFormField(
                          onChanged: (value) {
                            setState(() {
                              adress1 = value;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.home),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                              labelText: 'Shop Adress Line 1',
                              hintText: 'Shop Adress'),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                          ])),
                      TextFormField(
                          onChanged: (value) {
                            setState(() {
                              city = value;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                              labelText: 'City',
                              hintText: 'Enter your  City'),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            MinLengthValidator(2,
                                errorText: " atleast 2 characters"),
                          ])),
                      TextFormField(
                          onChanged: (value) {
                            setState(() {
                              pincode = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.code),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                              labelText: 'PinCode',
                              hintText: ' Enter your PinCode'),
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            LengthRangeValidator(
                                max: 6,
                                min: 6,
                                errorText: "6 digit Pincode/Zipcode")
                          ])),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              // onPressed:
                              // () {
                              //   return showDialog(
                              //       context: context,
                              //       builder: (ctx) => AlertDialog(
                              //             title: Text("Alert"),
                              //             content: Text(
                              //                 "You are About to Place the order do you want to Continue"),
                              //             actions: <Widget>[
                              //               FlatButton(
                              //                 onPressed: () {
                              //                   Navigator.of(context).pop();
                              //                 },
                              //                 child: Text("NO"),
                              //               ),
                              //               FlatButton(
                              //                 onPressed: () {

                              //                 },
                              //                 child: Text("OK"),
                              //               ),
                              //             ],
                              //           ));
                              // };
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Alert'),
                                        content: const Text(
                                            'You are About to Place the order do you want to Continue'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              send_data(adress1, city, pincode);
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            }
                          },
                          child: Text('Submit Form'),
                        ),
                      ),
                    ])))));
  }

  Future<void> send_data(adress1, city, pincode) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.add_adress'));
    request.body = json.encode({
      "post_data": {
        "name": datas["name"],
        "shop": Order,
        "adress": adress1.toString(),
        "city": city.toString(),
        "pincode": pincode.toString(),
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      print(response.reasonPhrase);
    }
  }
}
