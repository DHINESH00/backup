import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lte/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'place _order.dart';

class data extends StatefulWidget {
  final postData;
  const data({Key? key, required this.postData}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<data> createState() => _dataState(postData);
}

var datas;

late List list_data = [];

class _dataState extends State<data> {
  _dataState(Map postData) {
    datas = postData;
  }
  @override
  void initState() {
    get_data(datas);

    super.initState();
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
          title: Text(datas["p_name"] + " " + datas["qnt"]),
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: list_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: ListTile(
                        title: Text(
                            " From Shop ${list_data[index]["parent"].toString()} \t ${list_data[index]["mrp"].toString()}  NO Rating"),
                      ),
                    );
                  }),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                bottom: 20,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Start_bid(datas);
                    },
                    icon: Icon(Icons.start),
                    label: Text("Start Bidding"))),
            Positioned(
                bottom: 20,
                right: 30,
                child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                    label: Text("Delete"))),
            // Add more floating buttons if you want
            // There is no limit
          ],
        ));
  }

  Future<void> get_data(datas) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.Same_post'));
    request.body = json.encode({
      "product": {"name": datas["p_name"].toString()}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message =
          jsonDecode(await response.stream.bytesToString())["message"];
      setState(() {
        list_data = message;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future Start_bid(datas) async {
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
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.is_bid'));
    request.body = json.encode({
      "user_product": {"user": email, "name": datas["name"].toString()}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message =
          jsonDecode(await response.stream.bytesToString())["message"];
      if (message == "Done") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
