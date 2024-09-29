import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.1), // Shadow color with transparency
                spreadRadius: 1, // Spread radius
                blurRadius: 5, // Blur radius
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Icon
              IconButton(
                icon: Icon(
                  Icons.home,
                  color:
                      currentRoute == '/home' ? Colors.green[900] : Colors.grey,
                ),
                onPressed: () {
                  // Handle Home button press
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              // Search Icon
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: currentRoute == '/search'
                      ? Colors.green[900]
                      : Colors.grey,
                ),
                onPressed: () {
                  // Handle Search button press
                  Navigator.pushReplacementNamed(context, '/search');
                },
              ),
              // Profile Icon
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: currentRoute == '/profile'
                      ? Colors.green[900]
                      : Colors.grey,
                ),
                onPressed: () {
                  // Handle Profile button press
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ],
          ),
        ));
  }
}
