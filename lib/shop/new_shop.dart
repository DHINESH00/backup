import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lte/dashboard_screen.dart';
import 'package:lte/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class new_shop extends StatefulWidget {
  const new_shop({Key? key}) : super(key: key);

  @override
  State<new_shop> createState() => _new_shopState();
}

var name;
var email;
var number;
var adress1;
var adress2;
var varcity;
var pincode;
var gst;
var city;
var _imageshop;
var _imageathar;
var selectedValue;
GlobalKey<FormState> formkey = GlobalKey<FormState>();

class _new_shopState extends State<new_shop> {
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
          title: Text("Shop Verification"),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
              child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: formkey,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                        labelText: ' Email',
                        hintText: 'Enter your  Email'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      EmailValidator(errorText: "It Is Not vaild Email"),
                    ])),
                TextFormField(
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                        labelText: ' Name',
                        hintText: 'Enter your  Name'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      MinLengthValidator(2,
                          errorText: "Username should be atleast 2 characters"),
                    ])),
                TextFormField(
                    onChanged: (value) {
                      setState(() {
                        number = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                        labelText: ' Number',
                        hintText: 'Enter your  Number'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      LengthRangeValidator(
                          min: 10, max: 10, errorText: "10 Numbers"),
                    ])),
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
                      adress2 = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.home_max),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                        labelText: 'Shop Adress Line 2',
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
                      MinLengthValidator(2, errorText: " atleast 2 characters"),
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
                          max: 6, min: 6, errorText: "6 digit Pincode/Zipcode")
                    ])),
                TextFormField(
                    onChanged: (value) {
                      gst = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.code),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.all(16),
                        labelText: 'GST NUMBER',
                        hintText: 'Enter your  GST Number'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      LengthRangeValidator(
                          max: 15, min: 14, errorText: "14/15 digit Code")
                    ])),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.blueAccent,
                    ),
                    validator: (value) =>
                        value == null ? "Select a Category" : null,
                    dropdownColor: Colors.blueAccent,
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        send_data(adress1, adress2, city, email, gst, name,
                            pincode, number, selectedValue);
                      }
                    },
                    child: Text('Submit Form'),
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Future<void> send_data(adress1, adress2, city, email, gst, name, pincode,
      number, selectedValue) async {
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
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.shop_verfication'));
    request.body = json.encode({
      "name": name.toString(),
      "email": email.toString(),
      "number": number.toString(),
      "gst_number": gst.toString(),
      "category1": selectedValue.toString(),
      "shop_adress": adress1.toString() +
          adress2.toString() +
          city.toString() +
          pincode.toString(),
      "user": email
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Construction"), value: "Construction"),
      DropdownMenuItem(child: Text("Furniture"), value: "Furniture"),
      DropdownMenuItem(child: Text("Medicine"), value: "Medicine"),

      DropdownMenuItem(child: Text("Food"), value: "Food"),
      DropdownMenuItem(child: Text("Electronics"), value: "Electronics"),
    ];
    return menuItems;
  }
}
