import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/models/Company.dart';
import '../services/models/User.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    // Navigate to another page if companyProvider.company is null
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
    return Scaffold(
      body: companyProvider.isLoading || userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : companyProvider.company == null
              ? !userProvider.user!.isSuperUser && !userProvider.user!.isStaff
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: Text(companyProvider.message!),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : !userProvider.user!.isStaff
                  ? const Center(
                      child: Text('you do not have the permission'),
                    )
                  : Builder(builder: (context) {
                      // Get the height of the screen
                      final double screenHeight =
                          MediaQuery.of(context).size.height;
                      final double screenWidth =
                          MediaQuery.of(context).size.width;

                      return Container(
                          constraints: BoxConstraints(
                            minHeight: screenHeight,
                            minWidth: screenWidth,
                          ),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 238, 243, 248)),
                          child: Stack(children: [
                            SingleChildScrollView(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Center(child: Text('Main Content Here')),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.home,
                                            color: Colors.green[900]),
                                        onPressed: () {
                                          // Handle Home button press
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.search,
                                            color: Colors.green[900]),
                                        onPressed: () {
                                          // Handle Search button press
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.account_circle,
                                            color: Colors.green[900]),
                                        onPressed: () {
                                          // Handle Profile button press
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                          ]));
                    }),
    );
  }
}
