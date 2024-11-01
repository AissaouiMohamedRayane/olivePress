import 'package:flutter/material.dart';
import 'package:frontend/services/API/customer.dart';
import 'package:frontend/services/API/locations.dart';
import 'package:frontend/services/models/User.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../screens/DeleteCustomer.dart';

import '../Layout/ChildPagesLayout.dart';

import '../components/AddWeightWidget.dart';
import '../components/PaymentReceipt.dart';

import '../services/models/Company.dart';
import '../services/models/Customer.dart';
import '../services/models/Token.dart';
import '../services/models/Locations.dart';

class AddCustomerPage extends StatefulWidget {
  final Customer? customer;
  const AddCustomerPage({super.key, this.customer});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  void _removeFocus() {
    FocusScope.of(context).unfocus();
  }

  void _addNewWeightWidget() {
    setState(() {
      weightWidgetValue.add({
        'id': 0,
        'number': null,
        'weight': null,
      });
    });
  }

  void removeAddNewWeightWidget(int index) {
    setState(() {
      weightWidgetValue.removeAt(index);
    });
  }

  void _onWeightValueChange(int index, Map<String, int?> value) {
    setState(() {
      value['id'] = weightWidgetValue[index]['id']; // Set the 'id'
      print(value);
      weightWidgetValue[index] = value;
      _totalWeight = weightWidgetValue
          .map((value) => (value['weight'] ?? 0))
          .reduce((a, b) => a + b);
      _totalbags = weightWidgetValue
          .map((value) => (value['number'] ?? 0))
          .reduce((a, b) => a + b);
    });
  }

  void _setPdfFile(File file) {
    setState(() {
      _pdfFile = file;
    });
  }

  Future<void> printPdf(String? token, int? customerId) async {
    if (customerId != null) {
      try {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async =>
              pdf2.save(), // Replace with actual PDF data
        );

        // Show a dialog to confirm if the user completed the printing
        bool didPrint = await _showPrintConfirmationDialog();
        if (didPrint) {
          bool success = await setCustomerPrinted(token, customerId);
          if (success) {
            print('Customer printed status updated to true.');
          } else {
            print('Failed to update the customer printed status.');
          }
        } else {
          print('User indicated that the document was not printed.');
        }
      } catch (e) {
        print('An error occurred during PDF printing: $e');
      }
    }
  }

  Future<void> printBagsPdf() async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async =>
            pdfBags.save(), // Replace with actual PDF data
      );
    } catch (e) {}
  }

  Future<bool> _showPrintConfirmationDialog() async {
    // Show a dialog asking the user if they printed the document
    // Implement this using your preferred method of showing dialogs in Flutter
    // This example assumes a Future that returns true if the user confirms
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Print Confirmation'),
              content: Text('Did you complete printing the document?'),
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

  Future<void> _fetchZones(String token, String state) async {
    // Access your provider and call getZones here
    final List<String>? zones = await getZones(token, state);

    // You can update the state if needed
    setState(() {
      _zonesList = zones;
    });
  }

  // Rest of your widget code...

  String? _name;
  String? _phone;
  Wilaya? _state;
  String? _zone;
  List<String>? _zonesList;
  int? _containersNumber;
  int? _containerCapacity;
  int? _daysGone;
  int _totalWeight = 0;
  int _totalbags = 0;
  int _totalSum = 1;

  List<Map<String, int?>> weightWidgetValue = [
    {
      'id': 0,
      'number': null,
      'weight': null,
    }
  ];
  bool _showConf = false;

  File? _pdfFile;

  var pdf = pw.Document();
  final pdf2 = pw.Document();
  final pdfBags = pw.Document();
  // Store the generated PDF file

  Customer? _customer;

  bool disabledButton = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _zoneFocusNode = FocusNode();
  final FocusNode _containersNumberFocusNode = FocusNode();
  final FocusNode _containerCapacityFocusNode = FocusNode();
  final FocusNode _daysGoneFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _containersNumberController =
      TextEditingController();
  final TextEditingController _containerCapacityController =
      TextEditingController();
  final TextEditingController _daysGoneController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _phoneFocusNode.addListener(() {
      setState(() {});
    });
    _stateFocusNode.addListener(() {
      setState(() {});
    });
    _zoneFocusNode.addListener(() {
      setState(() {});
    });

    _containersNumberController.addListener(() {
      setState(() {});
    });
    _containerCapacityController.addListener(() {
      setState(() {});
    });
    _daysGoneFocusNode.addListener(() {
      setState(() {});
    });
    _stateController.text = 'جيجل';
    _state = Wilaya(id: 18, name: 'جيجل');

    //Edit part

    if (widget.customer == null) {
      _stateController.text = 'جيجل';
      _state = Wilaya(id: 18, name: 'جيجل');
    } else {
      _state = widget.customer!.state;
      _stateController.text = widget.customer!.state.name;

      _name = widget.customer!.name;
      _nameController.text = widget.customer!.name;

      _phone = widget.customer!.phone;
      _phoneController.text = widget.customer!.phone;

      _zone = widget.customer!.zone;
      _zoneController.text = widget.customer!.zone;

      _containersNumber = widget.customer!.containers![0].number;
      _containersNumberController.text =
          widget.customer!.containers![0].number.toString();

      _containerCapacity = widget.customer!.containers![0].capacity;
      _containerCapacityController.text =
          widget.customer!.containers![0].capacity.toString();

      _daysGone = widget.customer!.daysGone;
      _daysGoneController.text = widget.customer!.daysGone.toString();

      if (widget.customer?.bags != null) {
        weightWidgetValue = [];
        widget.customer!.bags!.forEach((bag) {
          weightWidgetValue.add({
            'id': bag.id,
            'number': bag.number,
            'weight': bag.weight,
          });
          _totalWeight = _totalWeight + bag.weight!;
          _totalbags = _totalWeight + bag.number!;
        });
      }
    }
    _fetchZones(Provider.of<TokenProvider>(context, listen: false).token!,
        _state!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final statesProvider = Provider.of<StatesProvider>(context);
    final tokenProvider = Provider.of<TokenProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: companyProvider.isLoading ||
                statesProvider.isLoading ||
                tokenProvider.isLoading ||
                userProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ChildPagesLayout(
                text: widget.customer == null ? 'إضافة عميل' : 'تعديل العميل',
                center: false,
                child: Container(
                    constraints: BoxConstraints(
                      minHeight: screenHeight,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          !_showConf
                              ? Form(
                                  key: _formKey,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(
                                                        alpha:
                                                            0.1), // Shadow color with transparency
                                                    spreadRadius:
                                                        1, // Spread radius
                                                    blurRadius:
                                                        5, // Blur radius
                                                  ),
                                                ],
                                                color: Colors.white),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'الاسم الكامل',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                _nameController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            focusNode:
                                                                _nameFocusNode,
                                                            validator: (value) =>
                                                                value!.isEmpty
                                                                    ? 'الرجاء إدخال الاسم واللقب'
                                                                    : null,
                                                            cursorColor:
                                                                Colors.black,
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: _nameFocusNode
                                                                          .hasFocus ||
                                                                      _name !=
                                                                          null
                                                                  ? null
                                                                  : 'أدخل الاسم',
                                                              labelStyle: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .green,
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                            ),
                                                            onChanged: (value) {
                                                              if (value == "") {
                                                                _name = null;
                                                              } else {
                                                                _name = value;
                                                              }
                                                            },
                                                            onSaved: (value) =>
                                                                _name = value,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'الهاتف',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          TextFormField(
                                                              controller:
                                                                  _phoneController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              focusNode:
                                                                  _phoneFocusNode,
                                                              validator: (value) =>
                                                                  value!.length !=
                                                                          10
                                                                      ? " الرقم غير صحيح"
                                                                      : null,
                                                              cursorColor:
                                                                  Colors.black,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: _phoneFocusNode
                                                                            .hasFocus ||
                                                                        _phone !=
                                                                            null
                                                                    ? null
                                                                    : 'أدخل رقم الهاتف ',
                                                                labelStyle: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      10,
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                if (value ==
                                                                    "") {
                                                                  _phone = null;
                                                                } else {
                                                                  _phone =
                                                                      value;
                                                                }
                                                              },
                                                              onSaved: (value) =>
                                                                  _phone =
                                                                      value),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'الولاية',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        TypeAheadField(
                                                          controller:
                                                              _stateController,
                                                          focusNode:
                                                              _stateFocusNode,
                                                          suggestionsCallback:
                                                              (pattern) async {
                                                            return statesProvider
                                                                .states!
                                                                .where(
                                                                    (state) =>
                                                                        // Convert both state name and pattern to lowercase for case-insensitive matching
                                                                        state
                                                                            .name
                                                                            .toString()
                                                                            .toLowerCase()
                                                                            .contains(pattern.toLowerCase()))
                                                                .toList();
                                                          },
                                                          builder: (context,
                                                              suppController,
                                                              focusNode) {
                                                            return TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              validator: (value) =>
                                                                  value!.isEmpty ||
                                                                          _state ==
                                                                              null
                                                                      ? 'الرجاء اختيار الولاية'
                                                                      : null,
                                                              controller:
                                                                  suppController,
                                                              focusNode:
                                                                  focusNode,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              onChanged:
                                                                  (value) {
                                                                _state = null;
                                                                setState(() {
                                                                  _zonesList =
                                                                      null;
                                                                  _zone = null;
                                                                  _zoneController
                                                                          .text =
                                                                      'a';
                                                                  _zoneController
                                                                      .text = '';
                                                                  _zoneFocusNode
                                                                      .unfocus();
                                                                });
                                                              },
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: _stateFocusNode
                                                                            .hasFocus ||
                                                                        _state !=
                                                                            null
                                                                    ? null
                                                                    : 'اختر ولاية ',
                                                                labelStyle: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      20,
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                            );
                                                          },
                                                          itemBuilder: (context,
                                                              suggestion) {
                                                            return ListTile(
                                                              title: Text(
                                                                  suggestion
                                                                      .name),
                                                            );
                                                          },
                                                          onSelected:
                                                              (suggestion) async {
                                                            await _fetchZones(
                                                                tokenProvider
                                                                    .token!,
                                                                suggestion.id
                                                                    .toString());
                                                            setState(() {
                                                              _zoneController
                                                                  .text = '';
                                                              _state =
                                                                  suggestion;
                                                              _stateController
                                                                      .text =
                                                                  suggestion
                                                                      .name;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'المنطقة',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        TypeAheadField(
                                                          controller:
                                                              _zoneController,
                                                          focusNode:
                                                              _zoneFocusNode,
                                                          suggestionsCallback:
                                                              (pattern) async {
                                                            return _zonesList
                                                                ?.where((zone) => zone
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        pattern
                                                                            .toLowerCase()))
                                                                .toList();
                                                          },
                                                          builder: (context,
                                                              suppController,
                                                              focusNode) {
                                                            return TextFormField(
                                                              enabled:
                                                                  _state == null
                                                                      ? false
                                                                      : true,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              validator: (value) =>
                                                                  value!.isEmpty
                                                                      ? 'الرجاء اختيار المنطقة'
                                                                      : null,
                                                              controller:
                                                                  suppController,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              focusNode:
                                                                  focusNode,
                                                              onChanged:
                                                                  (value) {
                                                                if (value ==
                                                                    '') {
                                                                  _zone = null;
                                                                }
                                                                _zone = value;
                                                              },
                                                              cursorColor:
                                                                  Colors.black,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: _zoneFocusNode
                                                                            .hasFocus ||
                                                                        _zone !=
                                                                            null
                                                                    ? null
                                                                    : 'اختر المنطقة ',
                                                                labelStyle: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      20,
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                              ),
                                                            );
                                                          },
                                                          itemBuilder: (context,
                                                              suggestion) {
                                                            return ListTile(
                                                              title: Text(
                                                                  suggestion),
                                                            );
                                                          },
                                                          onSelected:
                                                              (suggestion) {
                                                            setState(() {
                                                              _zone =
                                                                  suggestion;
                                                              _zoneController
                                                                      .text =
                                                                  suggestion;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ])
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                color: Colors.green[50]),
                                            child: ListView.builder(
                                              key: ValueKey(weightWidgetValue
                                                  .length), // Add a unique key based on itemCount

                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  weightWidgetValue.length,
                                              itemBuilder: (context, index) {
                                                return AddWeightWidget(
                                                    onWeightValueChange:
                                                        (value) =>
                                                            _onWeightValueChange(
                                                                index, value),
                                                    removeAddNewWeightWidget:
                                                        index != 0
                                                            ? removeAddNewWeightWidget
                                                            : null,
                                                    index: index,
                                                    values: weightWidgetValue[
                                                        index]); // Display AddWeightWidget
                                                // Spacing between widgets
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Center(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  _addNewWeightWidget();
                                                  _removeFocus();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                          Color>(
                                                    Colors.green,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'أضف حقيبة',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                )),
                                          ),
                                          Text(
                                              'الإجمالي : $_totalbags صناديق = $_totalWeight'),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(
                                                        alpha:
                                                            0.1), // Shadow color with transparency
                                                    spreadRadius:
                                                        1, // Spread radius
                                                    blurRadius:
                                                        5, // Blur radius
                                                  ),
                                                ],
                                                color: Colors.white),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'العدد',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            _containersNumberController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        focusNode:
                                                            _containersNumberFocusNode,
                                                        validator: (value) =>
                                                            value!.isEmpty
                                                                ? 'الرجاء إدخال العدد'
                                                                : null,
                                                        cursorColor:
                                                            Colors.black,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: _containersNumberFocusNode
                                                                      .hasFocus ||
                                                                  _containersNumber !=
                                                                      null
                                                              ? null
                                                              : 'عدد الاوعية',
                                                          labelStyle:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 5,
                                                            horizontal: 10,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 3,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                        ),
                                                        onChanged: (value) {
                                                          if (value == "") {
                                                            _containersNumber =
                                                                null;
                                                          } else {
                                                            _containersNumber =
                                                                int.parse(
                                                                    value);
                                                          }
                                                        },
                                                        onSaved: (value) =>
                                                            _containersNumber =
                                                                value == null
                                                                    ? null
                                                                    : int.parse(
                                                                        value),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'السعة',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      TextFormField(
                                                          controller:
                                                              _containerCapacityController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          focusNode:
                                                              _containerCapacityFocusNode,
                                                          cursorColor:
                                                              Colors.black,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) =>
                                                              value!.isEmpty
                                                                  ? 'الرجاء سعة الاوعية'
                                                                  : null,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: _containerCapacityFocusNode
                                                                        .hasFocus ||
                                                                    _containerCapacity !=
                                                                        null
                                                                ? null
                                                                : "سعة الاوعية",
                                                            labelStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 5,
                                                              horizontal: 10,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width: 3,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                          ),
                                                          onChanged: (value) {
                                                            if (value == "") {
                                                              _containerCapacity =
                                                                  null;
                                                            } else {
                                                              _containerCapacity =
                                                                  int.parse(
                                                                      value);
                                                            }
                                                          },
                                                          onSaved: (value) =>
                                                              _containerCapacity =
                                                                  value != null
                                                                      ? int.parse(
                                                                          value)
                                                                      : null),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha:
                                                                  0.1), // Shadow color with transparency
                                                      spreadRadius:
                                                          1, // Spread radius
                                                      blurRadius:
                                                          5, // Blur radius
                                                    ),
                                                  ],
                                                  color: Colors.white),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text(
                                                    'الأيام',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  TextFormField(
                                                      controller:
                                                          _daysGoneController,
                                                      focusNode:
                                                          _daysGoneFocusNode,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      validator: (value) => value!
                                                              .isEmpty
                                                          ? 'الرجاء إدخال عدد الأيام'
                                                          : null,
                                                      cursorColor: Colors.black,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: _daysGoneFocusNode
                                                                    .hasFocus ||
                                                                _daysGone !=
                                                                    null
                                                            ? null
                                                            : 'الأيام التي مرت',
                                                        labelStyle:
                                                            const TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 5,
                                                          horizontal: 20,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 3,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                      ),
                                                      onChanged: (value) {
                                                        if (value == "") {
                                                          _daysGone = null;
                                                        } else {
                                                          _daysGone =
                                                              int.parse(value);
                                                        }
                                                      },
                                                      onSaved: (value) =>
                                                          _daysGone = int.parse(
                                                              value!)),
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    _formKey.currentState
                                                        ?.save();
                                                    List<Bags> bags =
                                                        weightWidgetValue
                                                            .map((bag) {
                                                      return Bags.fromJson(bag);
                                                    }).toList();

                                                    Containers containers =
                                                        Containers(
                                                            capacity:
                                                                _containerCapacity,
                                                            number:
                                                                _containersNumber);
                                                    Customer customer =
                                                        Customer(
                                                      id: widget.customer?.id,
                                                      name: _name!,
                                                      phone: _phone!,
                                                      state: _state!,
                                                      zone: _zone!,
                                                      bags: bags,
                                                      containers: [containers],
                                                      oliveType: userProvider
                                                          .user!.oliveType!,
                                                      daysGone: _daysGone!,
                                                    );
                                                    print(userProvider
                                                            .user!.oliveType ==
                                                        2);
                                                    setState(() {
                                                      _totalSum = _totalWeight *
                                                          (userProvider.user!
                                                                      .oliveType ==
                                                                  1
                                                              ? companyProvider
                                                                  .company!
                                                                  .priceGreenOlive
                                                              : userProvider
                                                                          .user!
                                                                          .oliveType ==
                                                                      2
                                                                  ? companyProvider
                                                                      .company!
                                                                      .priceRedOlive
                                                                  : companyProvider
                                                                      .company!
                                                                      .priceBlackOlive);
                                                      _customer = customer;
                                                    });
                                                    File tempFile =
                                                        await generatePdf(
                                                            companyProvider,
                                                            userProvider,
                                                            customer,
                                                            _totalSum,
                                                            pdf);
                                                    _setPdfFile(tempFile);
                                                    setState(() {
                                                      _showConf = true;
                                                    });
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                          Color>(
                                                    Colors.green,
                                                  ),
                                                  shape:
                                                      WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      // Border width
                                                    ),
                                                  ),
                                                  padding: WidgetStateProperty
                                                      .all<EdgeInsets>(
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            12.0), // Add padding
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
                                            if (widget.customer != null)
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            if (widget.customer != null)
                                              Expanded(
                                                  child: ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return DeleteCustomer(
                                                                  customer: widget
                                                                      .customer!,
                                                                  token: tokenProvider
                                                                      .token!);
                                                            }),
                                                          ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .all<Color>(
                                                          Colors.red,
                                                        ),
                                                        shape:
                                                            WidgetStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            // Border width
                                                          ),
                                                        ),
                                                        padding:
                                                            WidgetStateProperty
                                                                .all<
                                                                    EdgeInsets>(
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical:
                                                                  12.0), // Add padding
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'إزالة',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                        ),
                                                      )))
                                          ]),
                                        ]),
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      SizedBox(
                                        height: 500,
                                        child: SfPdfViewer.file(_pdfFile!),
                                      ),
                                      Text("السعر الإجمالي: $_totalSum دج"),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showConf = false;
                                                  _customer = null;
                                                  _pdfFile = null;
                                                });
                                                pdf = pw.Document();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all<
                                                        Color>(
                                                  Colors.green,
                                                ),
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // Border width
                                                  ),
                                                ),
                                                padding: WidgetStateProperty
                                                    .all<EdgeInsets>(
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          12.0), // Add padding
                                                ),
                                              ),
                                              child: const Text(
                                                "التعديل",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (!disabledButton) {
                                                  disabledButton = true;
                                                  await _submitForm(
                                                      tokenProvider.token!,
                                                      companyProvider,
                                                      userProvider);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, '/');
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all<
                                                        Color>(
                                                  Colors.green,
                                                ),
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // Border width
                                                  ),
                                                ),
                                                padding: WidgetStateProperty
                                                    .all<EdgeInsets>(
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          12.0), // Add padding
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
                          const SizedBox(
                            height: 40,
                          )
                        ]))));
  }

  Future<void> _submitForm(String token, CompanyProvider companyProvider,
      UserProvider userProvider) async {
    Customer customer = _customer!;
    if (widget.customer == null) {
      int? ress = await AddCustomer(token, customer);
      if (ress != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' تم إنشاؤه بنجاح.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        List<Bags>? bags = await listBags(token, ress.toString());
        await generatePdf(
            companyProvider, userProvider, _customer!, _totalSum, pdf2, ress);
        await generateBagsPdf(bags!, pdfBags, ress, customer);
        await printPdf(token, ress);
        await printBagsPdf();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' فشل في الإنشاء.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      final bool ress =
          await UpdateCustomer(token, widget.customer!.id!, customer);
      if (ress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' updated successfully.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        List<Bags>? bags =
            await listBags(token, widget.customer!.id!.toString());
        await generatePdf(companyProvider, userProvider, customer, _totalSum,
            pdf2, widget.customer!.id);
        await generateBagsPdf(bags!, pdfBags, customer.id!, customer);
        await printPdf(token, widget.customer!.id);
        await printBagsPdf();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' فشل في التحديث.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose FocusNodes
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _stateFocusNode.dispose();
    _zoneFocusNode.dispose();

    // Dispose TextEditingControllers
    _nameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _zoneController.dispose();
    _containerCapacityFocusNode.dispose();

    super.dispose();
  }
}
