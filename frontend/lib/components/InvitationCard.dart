import 'package:flutter/material.dart';
import '../services/models/User.dart';

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.user,
    required this.usersWithNoPermisson,
  });

  final User user;
  final UsersWithNoPermisson usersWithNoPermisson;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.1), // Shadow color with transparency
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
            ),
          ],
          color: Color.fromARGB(255, 248, 248, 250)),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/profile.jpg',
                width: 60, // Same width as the icon size
                height: 60, // Same height as the icon size
                fit: BoxFit
                    .contain, // Optional: Ensures the image fits within the box
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                user.username,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[900]),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  usersWithNoPermisson.GivePermission(user);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Accepte',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  usersWithNoPermisson.RemoveUser(user);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Remove',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
