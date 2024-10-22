import 'package:flutter/material.dart';
import '../Layout/ChildPagesLayout.dart';
import '../services/models/Customer.dart';
import '../services/API/Customer.dart';

class DeleteCustomer extends StatefulWidget {
  final Customer customer;
  final String token;
  const DeleteCustomer(
      {super.key, required this.customer, required this.token});

  @override
  State<DeleteCustomer> createState() => _DeleteCustomerState();
}

class _DeleteCustomerState extends State<DeleteCustomer> {
  final _formKey = GlobalKey<FormState>();

  String? _deleteReason;

  final FocusNode _deleteReasonFocusNode = FocusNode();

  final TextEditingController _deleteReasonController = TextEditingController();

  Future<bool> _showConfirmationDialog() async {
    // Show a dialog asking the user if they printed the document
    // Implement this using your preferred method of showing dialogs in Flutter
    // This example assumes a Future that returns true if the user confirms
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: Text('تأكيد الحذف'),
                  content: Text('هل تريد حقًا حذف العميل؟'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('لا'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('نعم'),
                    ),
                  ],
                ));
          },
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    if (!widget.customer.isActive) {
      _deleteReason = widget.customer.cancelReason;
      _deleteReasonController.text = widget.customer.cancelReason ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: ChildPagesLayout(
            text: 'حذف العميل',
            center: false,
            child: Container(
              constraints:
                  BoxConstraints(minHeight: screenHeight, minWidth: 1000),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(15),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سبب الحذف',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: _deleteReasonController,
                                  keyboardType: TextInputType.text,
                                  focusNode: _deleteReasonFocusNode,
                                  validator: (value) => value!.isEmpty
                                      ? 'الرجاء إدخال سبب الحذف'
                                      : null,
                                  cursorColor: Colors.black,

                                  maxLines:
                                      null, // This allows the TextFormField to expand as the user types
                                  minLines: 10,
                                  decoration: InputDecoration(
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.green,
                                          width: 3,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onChanged: (value) {
                                    if (value == "") {
                                      _deleteReason = null;
                                    } else {
                                      _deleteReason = value;
                                    }
                                  },
                                  onSaved: (value) => _deleteReason = value,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.customer.isActive
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final bool ress =
                                        await _showConfirmationDialog();
                                    if (ress) {
                                      _submitForm(widget.token, false);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.red,
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
                                          vertical: 12.0), // Add padding
                                    ),
                                  ),
                                  child: const Text(
                                    "حذف",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final bool ress =
                                            await _showConfirmationDialog();
                                        if (ress) {
                                          _submitForm(widget.token, false);
                                        }
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
                                              vertical: 12.0), // Add padding
                                        ),
                                      ),
                                      child: const Text(
                                        "تعديل",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final bool ress =
                                            await _showConfirmationDialog();
                                        if (ress) {
                                          _submitForm(widget.token, true);
                                        }
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
                                              vertical: 12.0), // Add padding
                                        ),
                                      ),
                                      child: const Text(
                                        "تفعل",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ))
              ]),
            )));
  }

  Future<void> _submitForm(String token, bool isActive) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      Customer _customer = widget.customer;
      _customer.isActive = isActive;
      _customer.cancelReason = !isActive ? _deleteReason : '';
      final bool ress = await UpdateCustomer(token, _customer.id!, _customer);
      if (ress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم الحذف بنجاح.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' فشل في الحذف.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
