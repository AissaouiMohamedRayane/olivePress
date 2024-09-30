import 'package:flutter/material.dart';

// Define a reusable Layout widget
class ChildPagesLayout extends StatelessWidget {
  final Widget child; // This will hold the main content of the page
  final String text; // This will hold the main content of the page
  final bool center;

  const ChildPagesLayout(
      {super.key,
      required this.child,
      required this.text,
      required this.center});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 209, 248, 119),
                  Color.fromARGB(255, 106, 190, 83)
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
                mainAxisAlignment:
                    center ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  !center
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                text,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          text,
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 247, 250),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: .1) // Shadow color
                            ,
                            spreadRadius: 1, // How much the shadow spreads
                            blurRadius: 5, // How much the shadow is blurred
                            offset: const Offset(0,
                                -5), // Offset in the x (0) and y (-3) direction
                          ),
                        ],
                      ),
                      child: child)
                ])));
  }
}
