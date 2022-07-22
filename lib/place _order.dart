import 'package:flutter/material.dart';

List Adress = [];
int c = 0;

class place_order extends StatefulWidget {
  const place_order({Key? key}) : super(key: key);

  @override
  State<place_order> createState() => _place_orderState();
}

class _place_orderState extends State<place_order> {
  var a_value = {};
  final _formKey = GlobalKey<FormState>();
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
          title: Text("Place Order"),
        ),
        body: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofillHints: [AutofillHints.name],
                    decoration: const InputDecoration(
                      hintText: 'Address  line 1',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Address ';
                      }
                      return null;
                    },
                    onChanged: (data) {
                      a_value["a1"] = data.toString();
                    },
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Address  line 2',
                    ),
                    keyboardType: TextInputType.text,
                    autofillHints: [AutofillHints.email],
                    validator: (value) {
                      return null;
                    },
                    onChanged: (data) {
                      a_value["a2"] = data.toString();
                    },
                  ),
                  TextFormField(
                    autofillHints: [AutofillHints.telephoneNumber],
                    decoration: const InputDecoration(
                      hintText: 'Pincode',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (data) {
                      a_value["pin"] = data.toString();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            c = 1;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit Form'),
                    ),
                  ),
                ],
              ),
            )));
  }
}
