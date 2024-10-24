import 'package:flutter/material.dart';
import 'EditUserPage.dart';
import 'package:provider/provider.dart';

import '../Layout/HomeLayout.dart';
import '../screens/addCompanyPage.dart';

import '../services/models/User.dart';
import '../services/models/Company.dart';

import '../components/InvitationCard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      context.read<UsersWithNoPermisson>().initializeUsers();
    }
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);
    final usersWithNoPermisson = Provider.of<UsersWithNoPermisson>(context);

    return Scaffold(
        body: userProvider.isLoading || companyProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Homelayout(
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                        alpha:
                                            0.1), // Shadow color with transparency
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius
                                  )
                                ],
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        50), // Make the image circular
                                    child: const Icon(
                                      Icons.account_circle,
                                      color: Colors.black,
                                      size: 80,
                                    )
                                    // Image.asset(
                                    //   'assets/images/profile.jpg', // Path to your image
                                    //   width: 80, // Set the width to 100 pixels
                                    //   height: 80, // Set the height to 100 pixels
                                    //   fit: BoxFit
                                    //       .cover, // Ensure the image covers the entire area
                                    // ),
                                    ),
                                Text(
                                  userProvider.user!.username,
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return EditUserPage(userProvider: userProvider,);
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // Border width
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              vertical: 12.0,
                                              horizontal: 30), // Add padding
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            "تعديل",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
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
                                                BorderRadius.circular(10),
                                            // Border width
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              vertical: 12.0,
                                              horizontal: 26), // Add padding
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            " الخروج",
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                        alpha:
                                            0.1), // Shadow color with transparency
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius
                                  ),
                                ],
                                color: Colors.white),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.store_mall_directory_outlined,
                                      color: Colors.green[300],
                                      size: 60,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: userProvider.user!.isSuperUser
                                          ? 120
                                          : 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            companyProvider.company!.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green[900]),
                                          ),
                                          Text(
                                            companyProvider.company!.address,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                userProvider.user!.isSuperUser
                                    ? ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return AddCompanyPage(
                                                editCompany:
                                                    companyProvider.company,
                                              );
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // Border width
                                            ),
                                          ),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 30), // Add padding
                                          ),
                                        ),
                                        child: const Text(
                                          "تعديل",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          usersWithNoPermisson.isLoading
                              ? const CircularProgressIndicator()
                              : userProvider.user!.isSuperUser
                                  ? usersWithNoPermisson.users.isEmpty
                                      ? const Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text('كافة المستخدمين لديهم الإذن'),
                                          ],
                                        )
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              usersWithNoPermisson.users.length,
                                          itemBuilder: (context, index) {
                                            return InvitationCard(
                                                user: usersWithNoPermisson
                                                    .users[index],
                                                usersWithNoPermisson:
                                                    usersWithNoPermisson);
                                          },
                                        )
                                  : const Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            "ليس لديك الإذن لرؤية جميع المستخدمين"),
                                      ],
                                    ),
                          const SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    )),
              ));
  }
}
