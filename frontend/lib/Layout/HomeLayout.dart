import 'package:flutter/material.dart';
import 'package:frontend/services/models/Company.dart';
import 'package:frontend/services/models/User.dart';
import '../components/navBar.dart';
import 'package:provider/provider.dart';

// Define a reusable Layout widget
class Homelayout extends StatefulWidget {
  final Widget child; // This will hold the main content of the page

  const Homelayout({super.key, required this.child});

  @override
  State<Homelayout> createState() => _HomelayoutState();
}

class _HomelayoutState extends State<Homelayout> {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!companyProvider.isLoading && !userProvider.isLoading) {
        if (userProvider.user != null) {
          if (companyProvider.company == null &&
              companyProvider.error == null &&
              userProvider.user!.isSuperUser) {
            Navigator.pushReplacementNamed(context,
                '/addCompany'); // Replace with the route name of your page
          }
          if (companyProvider.error == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(companyProvider.message!)),
            );
          }
        }
      }
    });

    return Builder(builder: (context) {
      final String? currentRoute = ModalRoute.of(context)?.settings.name;

      // Get the height of the screen
      final double screenHeight = MediaQuery.of(context).size.height;

      return userProvider.isLoading || companyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 245, 248)),
              child: Stack(children: [
                SingleChildScrollView(
                  child: Container(
                      child: Column(children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currentRoute == '/home'
                                ? 'Home'
                                : currentRoute == '/search'
                                    ? 'Search'
                                    : 'account',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900]),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: Colors.green[900],
                            ),
                            onPressed: () async {
                              await userProvider.logoutUser();
                              Navigator.pushReplacementNamed(context, '/');
                            },
                          )
                        ],
                      ),
                    ),
                    widget.child
                  ])),
                ),
                NavBar()
              ]));
    });
  }
}
