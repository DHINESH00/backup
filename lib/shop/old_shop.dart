import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lte/shop/customer_post.dart';
import 'package:lte/shop/shop_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class old_shop extends StatefulWidget {
  const old_shop({Key? key}) : super(key: key);

  @override
  State<old_shop> createState() => _old_shopState();
}

List shop_post = [];

class _old_shopState extends State<old_shop> {
  @override
  void initState() {
    shop_datas();
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
          title: Text("Shop Data"),
        ),
        body: Center(
          child: shop_post != null && (shop_post.isNotEmpty)
              ? ListView.builder(
                  shrinkWrap: false,
                  itemCount: shop_post.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(shop_post);
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
                                      onPressed: () {},
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
                                        shop_post[index]["product_name"] + " ",
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                bottom: 20,
                left: 30,
                child: ElevatedButton.icon(
                    onPressed: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const custmer_post()));
                    }),
                    icon: Icon(Icons.search),
                    label: Text("See Customer Post"))),
            Positioned(
              bottom: 20,
              right: 30,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => shop_data()));
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ),
          ],
        ));
  }

  Future<void> shop_datas() async {
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
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.shop_data_see'));
    request.body = json.encode({
      "shop_data": {"user": email}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var message =
          jsonDecode(await response.stream.bytesToString())["message"];
      setState(() {
        shop_post = message;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
