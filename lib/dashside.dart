import 'package:flutter/material.dart';
import 'package:lte/login_screen.dart';
import 'package:lte/settings.dart';
import 'package:lte/shop/shop_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

var email_value = " ";
var name = " ";

class _NavBarState extends State<NavBar> {
  @override
  initState() {
    get_user_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email_value),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.VwOipFm0fDDr_KOzoyrgVwAAAA%26pid%3DApi&f=1',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Friends'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () => null,
          ),
          ListTile(
            title: Text('Login as Shop'),
            leading: Icon(Icons.login),
            onTap: () async {
              
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => shop_dash()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => settings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout_outlined),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Logout Successful")));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }

  Future<void> get_user_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    if (email != null) {
      setState(() {
        email_value = email;
        name = email.split('@')[0];
      });
    }
  }
}


