import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/models/Company.dart';
import '../services/models/User.dart';
import '../Layout/HomeLayout.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 

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
                    ? Center(
                        child: Text(companyProvider.message!),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )
                : !userProvider.user!.isStaff
                    ? const Center(
                        child: Text('you do not have the permission'),
                      )
                    : Homelayout(
                        child: Column(
                          children: [
                            Center(child: const Text('Main Content Here')),
                          ],
                        ),
                      ));
  }
}
