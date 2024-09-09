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

  String _usernameLabelText = 'Entrer le username';
  String _passwordLabelText = 'Entrer le password';

  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus) {
        setState(() {
          _usernameLabelText = '';
        });
      } else {
        setState(() {
          _usernameLabelText = username == null ? 'Entrer le username' : '';
        });
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _passwordLabelText = '';
        });
      } else {
        setState(() {
          _passwordLabelText = password == null ? 'Entrer le password' : '';
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 160,
            ),
            const Center(
              child: Text(
                'Register',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align children at the start
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      focusNode:
                          _usernameFocusNode, // Attach the FocusNode here

                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? 'Veuillez entrer le username' : null,
                      cursorColor: const Color(0xFF757575),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: _usernameLabelText,
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF757575)),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF757575),
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10)),
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
                    const Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF757575)),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFormField(
                      obscureText: _obscurePassword, // Hide password text
                      focusNode: _passwordFocusNode,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? 'Veuillez entrer le password' : null,
                      cursorColor: const Color(0xFF757575),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: _passwordLabelText,
                        suffixIcon: _passwordFocusNode.hasFocus
                            ? IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              )
                            : null,
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF757575)),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF757575),
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10)),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.green,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              // Border width
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 12.0), // Add padding
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Center(
                      child: Text(
                        "Vous avez déjà un compte?",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF757575)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 12.0), // Add padding
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF757575))
                                // Border width
                                ),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ));
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
