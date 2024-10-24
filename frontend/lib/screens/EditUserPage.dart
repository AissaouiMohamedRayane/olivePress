import 'package:flutter/material.dart';
import 'package:frontend/services/models/User.dart';
import '../Layout/ChildPagesLayout.dart';

class EditUserPage extends StatefulWidget {
  final UserProvider userProvider;

  const EditUserPage({super.key, required this.userProvider});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _password;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.userProvider.user!.username;
    _nameController.text = widget.userProvider.user!.username;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
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
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ChildPagesLayout(
        text: 'تعديل الحساب',
        center: false,
        child: Container(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'الاسم الكامل',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  focusNode: _nameFocusNode,
                  validator: (value) =>
                      value!.isEmpty ? 'الرجاء إدخال الاسم واللقب' : null,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: _nameFocusNode.hasFocus || _name != null
                        ? null
                        : 'أدخل الاسم',
                    labelStyle: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
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
                      _name = null;
                    } else {
                      _name = value;
                    }
                  },
                  onSaved: (value) => _name = value,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'كلمة المرور',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  focusNode: _passwordFocusNode,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: _passwordFocusNode.hasFocus || _password != null
                        ? null
                        : 'إذا لم ترغب في تغيير كلمة المرور الخاصة بك، فاتركها',
                    labelStyle: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
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
                      _password = null;
                    } else {
                      _password = value;
                    }
                  },
                  onSaved: (value) => _password = value,
                  validator: validatePassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            widget.userProvider.editUser(_name!, _password!);
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.green,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              // Border width
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 12.0), // Add padding
                          ),
                        ),
                        child: const Text(
                          "حفظ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
