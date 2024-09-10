import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/models/Company.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    // Navigate to another page if companyProvider.company is null
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!companyProvider.isLoading) {
        if (companyProvider.company == null) {
          Navigator.pushReplacementNamed(context,
              '/addCompany'); // Replace with the route name of your page
        }
      }
    });
    return Scaffold(
      body: companyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: companyProvider.company == null
                  ? null
                  : Center(child: Text(companyProvider.company!.name)),
            ),
    );
  }
}
