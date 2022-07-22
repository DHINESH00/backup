import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lte/last.dart';
import 'package:lte/post.dart';
import 'package:lte/post_data.dart';
import 'package:lte/shop/bid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashside.dart';
import 'main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    get_data();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(post_datas);
    return Scaffold(
      drawer: NavBar(),
      appBar:
          AppBar(title: const Text("Your Post"), backgroundColor: Colors.blue),
      body: Center(
        child: post_datas != null
            ? ListView.builder(
                shrinkWrap: false,
                itemCount: post_datas?.length,
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
                                      if (post_datas?[index]
                                              ["is_oder_placed"] ==
                                          1) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => oder_last(
                                                    postData:
                                                        post_datas?[index])));
                                      } else {
                                        if (post_datas?[index]["is_bid"] == 1) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => bid(
                                                      postData:
                                                          post_datas?[index])));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => data(
                                                      postData:
                                                          post_datas?[index])));
                                        }
                                      }
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
                                      post_datas?[index]["p_name"] +
                                          " " +
                                          post_datas?[index]["qnt"] +
                                          " ",
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 12),
                                    )))
                          ],
                        )),
                  );
                })
            : Text(
                'No Data',
                style: Theme.of(context).textTheme.headline4,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => post()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
            'http://192.168.111.171:8001/api/method/my_bid.my_bid.doctype.user_login.user_login.get_posting'));
    request.body = json.encode({
      "data": {"email": email}
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
