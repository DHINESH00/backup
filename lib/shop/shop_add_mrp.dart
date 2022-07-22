import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lte/shop/start_bid.dart';

class shop_mrp extends StatefulWidget {
  final postData;
  const shop_mrp({Key? key, required this.postData}) : super(key: key);

  @override
  State<shop_mrp> createState() => _shop_mrpState(postData);
}

var datas;
late List list_bid = [];

class _shop_mrpState extends State<shop_mrp> {
  _shop_mrpState(postData) {
    datas = postData;
  }
  @override
  void initState() {
    product_bid(datas);
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
                itemCount: list_bid.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      title: Text(
                          " From Shop ${list_bid[index]["shop"].toString()} \t ${list_bid[index]["mrp"].toString()}RS  Will be given at \t ${list_bid[index]["time"].toString()} \n"),
                    ),
                  );
                }),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => start_bid(postData: datas)));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> product_bid(datas) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image='
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.bid'));
    request.body = json.encode({
      "post_name": {"name": datas["name"].toString()}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message =
          jsonDecode(await response.stream.bytesToString())["message"];
      setState(() {
        list_bid = message;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
