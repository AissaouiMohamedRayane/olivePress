import 'package:flutter/material.dart';
import 'package:frontend/screens/AddCustomer.dart';
import 'package:frontend/services/models/Token.dart';
import 'package:provider/provider.dart';
import '../services/models/Company.dart';
import '../services/models/User.dart';
import '../Layout/HomeLayout.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      context.read<UserProvider>().initializeProducts();
      context.read<CompanyProvider>().initializeProducts();
      context.read<TokenProvider>().initializeToken();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final tokenProvider = Provider.of<TokenProvider>(context);

    // Navigate to another page if companyProvider.company is null
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!companyProvider.isLoading &&
          !userProvider.isLoading &&
          !tokenProvider.isLoading) {
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
        body: companyProvider.isLoading ||
                userProvider.isLoading ||
                tokenProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : companyProvider.company == null
                ? !userProvider.user!.isSuperUser && !userProvider.user!.isStaff
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(companyProvider.message!),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await userProvider.logoutUser();
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.red,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // Border width
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 26), // Add padding
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "تسجيل الخروج",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : !userProvider.user!.isSuperUser
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('ليس لديك الإذن بإضافة شركة'),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await userProvider.logoutUser();
                                      Navigator.pushReplacementNamed(
                                          context, '/');
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                        Colors.red,
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          // Border width
                                        ),
                                      ),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 26), // Add padding
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "تسجيل الخروج",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
                : !userProvider.user!.isStaff
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('ليس لديك الإذن لاستخدام التطبيق'),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await userProvider.logoutUser();
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.red,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // Border width
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 26), // Add padding
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "تسجيل الخروج",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Homelayout(
                        child: Column(
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return AddCustomerPage();
                                    }),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.green,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      // Border width
                                    ),
                                  ),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 30), // Add padding
                                  ),
                                ),
                                child: const Text(
                                  "إضافة العميل",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
  }
}
