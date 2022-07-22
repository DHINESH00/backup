import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:lte/shop/old_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class shop_data extends StatefulWidget {
  const shop_data({Key? key}) : super(key: key);

  @override
  State<shop_data> createState() => _shop_dataState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
var product;
var mrp;
var selectedValue;

class _shop_dataState extends State<shop_data> {
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
        title: Text("Shop Data"),
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
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
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
                    TextFormField(
                        onChanged: (value) {
                          setState(() {
                            product = value;
                          });
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.production_quantity_limits),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.all(16),
                            labelText: 'Product Name',
                            hintText: 'Enter your  Product Nmae'),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(2, errorText: "2")
                        ])),
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
                            hintText: 'Enter your  Product Price'),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          MinLengthValidator(2, errorText: "2")
                        ])),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            send_data(mrp, product, selectedValue);
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

  Future<void> send_data(mrp, product, category) async {
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
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.shop_datas'));
    request.body = json.encode({
      "shop_data": {
        "user": email.toString(),
        "product_name": product.toString(),
        "category": category.toString(),
        "mrp": mrp.toString()
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message =
          jsonDecode(await response.stream.bytesToString())["message"];
      if (message == "Done") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Done')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => old_shop()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please Try After Sometime')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => old_shop()));
      }
    } else {
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Try After Sometime')));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => old_shop()));
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
