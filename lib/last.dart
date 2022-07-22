import 'package:flutter/material.dart';

class oder_last extends StatefulWidget {
  final postData;
  const oder_last({Key? key, required this.postData}) : super(key: key);

  @override
  State<oder_last> createState() => _oder_lastState(postData);
}

class _oder_lastState extends State<oder_last> {
  var datas;
  _oder_lastState(postData) {
    datas = postData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text("${datas["p_name"]}"),leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),),
          body: Center(
            child: Container(
               child: ListView(
                children: [
                  Text(
                'If you have any queries please check your Email \n And if you want to cancel please contact your Shop \n or call 9500985129',
                style: Theme.of(context).textTheme.headline6,
              ),
                ],
               )
            ),
          ),
    );
  }
}
