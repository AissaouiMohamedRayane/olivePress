import '../../services/API/auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String? username;
  String? password;
  bool _obscurePassword = true;

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    // Listen for focus changes

    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور الخاصة بك';
    }
    if (value.length < 8) {
      return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      // Get the height of the screen
      final double screenHeight = MediaQuery.of(context).size.height;

      return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 209, 248, 119),
                Color.fromARGB(255, 106, 190, 83)
              ],
              stops: [0, .9], // Adjust stops to control gradient spread
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          // Set the minimum height to the screen height
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 160,
                    ),
                    const Center(
                      child: Text(
                        'تسجيل حساب جديد',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align children at the start
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              textAlign:
                                  TextAlign.center, // Center the hint text

                              focusNode:
                                  _usernameFocusNode, // Attach the FocusNode here

                              keyboardType: TextInputType.text,
                              validator: (value) => value!.isEmpty
                                  ? 'الرجاء إدخال اسم المستخدم الخاص بك'
                                  : null,
                              cursorColor: const Color(0xFF757575),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                filled: true,
                                fillColor: Color.fromARGB(255, 106, 190, 83),
                                hintText: 'اسم المستخدم',
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onChanged: (value) {
                                if (value == "") {
                                  username = null;
                                } else {
                                  username = value;
                                }
                              },
                              onSaved: (value) => username = value,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textAlign:
                                  TextAlign.center, // Center the hint text

                              obscureText:
                                  _obscurePassword, // Hide password text
                              focusNode: _passwordFocusNode,
                              keyboardType: TextInputType.text,
                              validator: validatePassword,
                              cursorColor: const Color(0xFF757575),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                suffixIcon: _passwordFocusNode.hasFocus
                                    ? IconButton(
                                        icon: Icon(
                                          color: Colors
                                              .white, // Set the icon color to white

                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      )
                                    : null,
                                contentPadding: EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: _passwordFocusNode.hasFocus ? 48 : 0,
                                    right: 0),
                                filled: true,
                                fillColor: Color.fromARGB(255, 106, 190, 83),
                                hintText: 'كلمة المرور',
                                hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onChanged: (value) {
                                if (value == "") {
                                  password = null;
                                } else {
                                  password = value;
                                }
                              },
                              onSaved: (value) => password = value,
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitForm();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.white,
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
                                        vertical: 12.0), // Add padding
                                  ),
                                ),
                                child: const Text(
                                  "سجل",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 106, 190, 83)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "هل لديك حساب بالفعل؟",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets
                                        .zero, // Remove any default padding
                                    minimumSize: const Size(0,
                                        0), // Ensure no minimum size constraint
                                  ),
                                  child: const Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ));
    }));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Save the form state

      // Call the login function with the username and password
      bool success = await register(username!, password!);

      if (success) {
        // Navigate to the main screen

        Navigator.pushReplacementNamed(context, '/');
      } else {
        // Handle login failure (e.g., show a snackbar or alert)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }
}
