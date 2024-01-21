import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/resultModel.dart';
import '../Screens/home.dart';

class AuthService {
  String BaseUrl = 'https://skinsight-kctt.onrender.com';

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    var url = '$BaseUrl/api/v1/auth/login';

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Lottie.asset(
              'assets/icons/loader.json',
              width: 200,
              height: 200,
            ),
          );
        });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print('login entered');

    if (response.statusCode == 200) {
      Navigator.pop(context);
      // Successful login, handle the response accordingly
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
        ),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("token is ${responseData['user']['token']}");
      prefs.setString('user_token', responseData['user']['token']);
      prefs.setString('name', responseData['user']['username']);
      prefs.setString('email', responseData['user']['email']);
      prefs.setString('userID', responseData['user']['_id']);
      print(prefs.getString('userID'));

      print('this is name from storage:' + prefs.getString('name').toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false);

      print(responseData);
    } else {
      Navigator.pop(context);
      // Handle errors, you can show an error message to the user
      final responseData = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
        ),
      );

      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  Future<void> registerUser(
      String name, String email, String password, BuildContext context) async {
    print("entered block");
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Lottie.asset(
              'assets/icons/loader.json',
              width: 200,
              height: 200,
            ),
          );
        });
    var url =
        '$BaseUrl/api/v1/auth/signup'; // Replace with your actual API endpoint

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Store the user token using shared preferences
      Navigator.pop(context);
      print('Got here');
      print(responseData);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("token is ${responseData['user']['token']}");
      prefs.setString('user_token', responseData['user']['token']);
      prefs.setString('name', responseData['user']['username']);
      prefs.setString('email', responseData['user']['email']);

      print(responseData);
    } else {
      Navigator.pop(context);
      // Handle errors, you can show an error message to the user
      final responseData = json.decode(response.body);

      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(message: responseData['message']),
      // );
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_token');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('userID');
    prefs.remove('image');
  }
}
