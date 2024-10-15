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
            return AlertDialog(
              title: Text('Delete Confirmation'),
              content: Text('Do you really want to delete the customer?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: ChildPagesLayout(
            text: 'Delete customer',
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
                                  'Reason for deletion',
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
                                      ? 'Veuillez entrer le nom et prénom'
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final bool ress = await _showConfirmationDialog();
                              if (ress) {
                                _submitForm(widget.token);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.red,
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
                              "Delete",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
            )));
  }

  Future<void> _submitForm(String token) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      Customer _customer = widget.customer;
      _customer.isActive = true;
      _customer.cancelReason = _deleteReason;
      final bool ress = await UpdateCustomer(token, _customer.id!, _customer);
      if (ress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' Deleted successfully.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' failed to Delete.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    Navigator.pushReplacementNamed(context, '/');
  }
}
