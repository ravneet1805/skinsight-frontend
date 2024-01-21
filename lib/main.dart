import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/API/authServices.dart';
import 'package:skinsight/Model/resultModel.dart';
import 'package:skinsight/Screens/chatScreen.dart';
import 'package:skinsight/Screens/resultScreen.dart';
import 'package:skinsight/Screens/splashScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'AuthScreens/loginScreen.dart';
import 'AuthScreens/signupScreen.dart';
import 'Screens/home.dart';



AuthService authService = AuthService();
var token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  SharedPreferences prefs = await SharedPreferences.getInstance();
    token =  prefs.getString('user_token');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(titleTextStyle: TextStyle(fontSize: 22,fontWeight: FontWeight.w500, color: Colors.black))
      ),
      
      home: SplashScreen(),
    
      
      
      

        //initialRoute: '/signup',
      routes: {
         //'/nav':(context) => MyNavbar(),
        '/home': (context) => HomeScreen(),
        //"/res": (context) => ResultScreen(),
        "/chat": (context) => ChatScreen(),
         '/signup': (context) => SignupScreen(),
        // '/add': (context) => AddScreen(),
        // '/search': (context) => HomeScreen(),
        // '/profile': (context) => HomeScreen(),
        // '/navbar': (context) => MyNavbar(),
      },
    );
  }
}