import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/search.dart';
import 'screens/authPages/loginPage.dart';
import 'screens/authPages/register.dart';
import 'screens/addCompanyPage.dart';

import './services/models/Company.dart';
import './services/models/Token.dart';
import './services/models/User.dart';
import './services/API/auth.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UsersWithNoPermisson()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'olivePress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        scaffoldBackgroundColor:
            Colors.white, //Set the background color to white
      ),
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/addCompany': (context) => AddCompanyPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/search': (context) => SearchPage(),
      },
      home: SplashScreen(), // Start with the splash screen
    );
  }
}

// Splash screen to check if the token is available
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check the token when the app starts
  }

  Future<void> checkLoginStatus() async {
    // Try to get the token from shared preferences
    bool? ress = await validateToken();
    if (ress) {
      print('rayane');
      // If the token is found, navigate to the HomePage
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If no token is found, navigate to the LoginPage
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Basic splash screen (could be replaced with any loading indicator)
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
