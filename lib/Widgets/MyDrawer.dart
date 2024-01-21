import 'package:flutter/material.dart';
import 'package:skinsight/API/authServices.dart';
import 'package:skinsight/AuthScreens/loginScreen.dart';
import 'package:skinsight/utils/constant.dart';


class MyDrawer extends StatelessWidget {
  final String? name;
  final String? email;

  MyDrawer({required this.name, required this.email});
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: kGreencolor,
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? 'Guest', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                Text(email ?? 'sample@gmail.com', style: TextStyle(fontSize: 14)),
                SizedBox(height: 5,)
                ],
              )),
          SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home_outlined,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text('Logout', style: TextStyle()),
                  onTap: () {
                    authService.signOut();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            ),
          ),
          // Add more ListTile widgets for additional options
        ],
      ),
    );
  }
}
