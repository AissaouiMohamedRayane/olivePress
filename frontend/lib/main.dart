import 'package:flutter/material.dart';
import 'package:frontend/services/API/auth.dart';
import './screens/home.dart';
import 'screens/authPages/loginPage.dart';
import 'screens/authPages/register.dart';
import 'package:provider/provider.dart';
import './services/models/Company.dart';
import 'screens/addCompanyPage.dart';
import './services/models/Token.dart';
import './services/models/User.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/addCompany': (context) => AddCompanyPage(),
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
