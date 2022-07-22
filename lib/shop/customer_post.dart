import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lte/shop/shop_add_mrp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class custmer_post extends StatefulWidget {
  const custmer_post({Key? key}) : super(key: key);

  @override
  State<custmer_post> createState() => _custmer_postState();
}

List post_datas = [];

class _custmer_postState extends State<custmer_post> {
  @override
  void initState() {
    get_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Customer Post"), backgroundColor: Colors.blue),
      body: Center(
        child: post_datas != null && (post_datas.isNotEmpty)
            ? ListView.builder(
                shrinkWrap: false,
                itemCount: post_datas.length,
                itemBuilder: (BuildContext context, int index) {
                  print(post_datas);
                  return Card(
                    shadowColor: Colors.black87,
                    elevation: 50,
                    color: index % 2 == 0
                        ? Colors.blue.shade100
                        : Colors.blue.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Row(
                          children: [
                            Center(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => shop_mrp(
                                                  postData:
                                                      post_datas[index])));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 2.0),
                                      primary: Colors.white,
                                      shape: const StadiumBorder(),
                                    ),
                                    icon: const Icon(
                                      Icons.info_outline,
                                      color: (Colors.blue),
                                    ),
                                    label: Text(
                                      post_datas[index]["p_name"] +
                                          " " +
                                          post_datas[index]["qnt"] +
                                          " ",
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 12),
                                    )))
                          ],
                        )),
                  );
                })
            : Text(
                'NO Data',
                style: Theme.of(context).textTheme.headline4,
              ),
      ),
    );
  }

  Future<void> get_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var headers = {'Content-Type': 'application/json', 'Cookie': 'sid=Guest'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.shop_user_post_see'));
    request.body = json.encode({
      "shop_data": {"user": email}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message =
          jsonDecode(await response.stream.bytesToString())["message"];
      if (message != "no user") {
        setState(() {
          post_datas = message;
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
