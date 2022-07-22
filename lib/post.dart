import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:lte/dashboard_screen.dart';
import 'package:lte/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

var post_data = {};
var selectedValue;

class post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTitle = 'New Post';
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
        title: Text(appTitle),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              onChanged: (value) {
                setState(() {
                  post_data["p_name"] = value;
                });
              },
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                  labelText: ' Product  ',
                  hintText: 'Enter your  Product'),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Required"),
                MinLengthValidator(2, errorText: "atleast 2 characters"),
              ])),
          TextFormField(
              onChanged: (value) {
                setState(() {
                  post_data["qnt"] = value;
                });
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.production_quantity_limits),
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                  labelText: ' Quantity',
                  hintText: 'Enter your  Quantity'),
              validator: MultiValidator([
                RequiredValidator(errorText: "* Required"),
                MinLengthValidator(1, errorText: "")
              ])),
          SizedBox(
            height: 15,
          ),
          DropdownButtonFormField(
              icon: Icon(Icons.production_quantity_limits),
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
              validator: (value) => value == null ? "Select a Category" : null,
              dropdownColor: Colors.blueAccent,
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue!;
                  post_data["category"] = newValue;
                });
              },
              items: dropdownItems),
          TextFormField(
              onChanged: (value) {
                setState(() {
                  post_data["number"] = value;
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
                LengthRangeValidator(min: 10, max: 10, errorText: "10 Numbers"),
              ])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  print('0');
                  post_data_method(post_data);
                  post_data = {};
                }
              },
              child: Text('Submit Form'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> post_data_method(Map post_data) async {
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
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.posting'));
    request.body = json.encode({
      "data": {"email": email},
      "post": {
        "post_name": post_data["p_name"],
        "category": post_data["category"],
        "number": post_data["number"],
        "qnt": post_data["qnt"],
        "email": email,
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
