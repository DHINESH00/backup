import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lte/add_adress_place_order.dart';
import 'package:lte/post_data.dart';
import 'package:http/http.dart' as http;

class bid extends StatefulWidget {
  final postData;
  const bid({Key? key, required this.postData}) : super(key: key);

  @override
  State<bid> createState() => _bidState(postData);
}

var value_selected;
var datas;
var bids;
late List list_bid = [];

class _bidState extends State<bid> {
  _bidState(Map postData) {
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
          title: Text(datas["p_name"]),
        ),
        body: Center(
            child: ListView.builder(
                shrinkWrap: false,
                itemCount: list_bid.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Text(
                          "From Shop ${list_bid[index]["shop"].toString()} \t ${list_bid[index]["mrp"].toString()}RS  No ratings ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Radio(
                          value: list_bid[index]["shop"].toString(),
                          onChanged: (value) {
                            setState(() {
                              bids = value;
                            });
                          },
                          groupValue: bids,
                        ),
                      ),
                    ],
                  );
                })),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                bottom: 20,
                child: ElevatedButton.icon(
                    onPressed: () {
                      if (bids == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Place Order needs value')));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => add_adress(
                                  postData: datas,
                                  places: bids,
                                )));
                      }
                    },
                    icon: Icon(Icons.place),
                    label: Text("Place Order"))),
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
