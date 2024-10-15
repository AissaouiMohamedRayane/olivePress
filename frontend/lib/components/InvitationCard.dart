import 'package:flutter/material.dart';
import '../services/models/User.dart';
import '../services/API/auth.dart';

class InvitationCard extends StatefulWidget {
  InvitationCard({
    super.key,
    required this.user,
    required this.usersWithNoPermisson,
  });

  final User user;
  final UsersWithNoPermisson usersWithNoPermisson;

  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
  int _selectedOliveType = 1;

  void _setOliveType(String value) {
    setState(() {
      _selectedOliveType = value == 'Green'
          ? 1
          : value == 'Red'
              ? 2
              : 3;
    });
    print(_selectedOliveType);
  }

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
              Column(
                children: [
                  Text(
                    widget.user.username,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[900]),
                  ),
                  ChoiceDropdown(
                    setOliveType: _setOliveType,
                  )
                ],
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () async {
                  widget.usersWithNoPermisson
                      .GivePermission(widget.user, _selectedOliveType);
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
                  widget.usersWithNoPermisson.RemoveUser(widget.user);
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

class ChoiceDropdown extends StatefulWidget {
  ChoiceDropdown({
    super.key,
    required this.setOliveType,
  });

  final Function setOliveType;
  @override
  _ChoiceDropdownState createState() => _ChoiceDropdownState();
}

class _ChoiceDropdownState extends State<ChoiceDropdown> {
  // List of choices
  List<String> choices = [
    'Green',
    'Red',
    'Black',
  ];

  // Default selected value

  String selectedChoice = 'Green';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: selectedChoice,
        items: choices.map((String choice) {
          return DropdownMenuItem<String>(
            value: choice,
            child: Text(
              choice,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedChoice = newValue!;
          });
          widget.setOliveType(newValue);
        },
      ),
    );
  }
}
