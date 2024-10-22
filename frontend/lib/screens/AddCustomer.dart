import 'package:flutter/material.dart';
import 'package:frontend/services/API/customer.dart';
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
      weightWidgetValue[index] = value;
      _totalWeight = weightWidgetValue
          .map((value) => (value['weight'] ?? 0))
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

  String? _name;
  String? _phone;
  Wilaya? _state;
  String? _zone;
  int? _containersNumber;
  int? _containerCapacity;
  int? _daysGone;
  int _totalWeight = 0;
  int _totalSum = 1;

  List<Map<String, int?>> weightWidgetValue = [
    {
      'number': null,
      'weight': null,
    }
  ];
  bool _showConf = false;

  File? _pdfFile;

  var pdf = pw.Document();
  final pdf2 = pw.Document();
  // Store the generated PDF file

  Customer? _customer;

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
            'number': bag.number,
            'weight': bag.weight,
          });
          _totalWeight = _totalWeight + bag.weight!;
        });
      }
    }
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
                                                            'الرقم',
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
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText: _phoneFocusNode
                                                                            .hasFocus ||
                                                                        _phone !=
                                                                            null
                                                                    ? null
                                                                    : 'أدخل الرقم ',
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
                                                const Text(
                                                  'الولاية',
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
                                                TypeAheadField(
                                                  controller: _stateController,
                                                  focusNode: _stateFocusNode,
                                                  suggestionsCallback:
                                                      (pattern) async {
                                                    return statesProvider
                                                        .states!
                                                        .where((state) =>
                                                            // Convert both state name and pattern to lowercase for case-insensitive matching
                                                            state.name
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(pattern
                                                                    .toLowerCase()))
                                                        .toList();
                                                  },
                                                  builder: (context,
                                                      suppController,
                                                      focusNode) {
                                                    return TextFormField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      // validator: (value) => value!.isEmpty
                                                      //     ? 'Veuillez selectionner le nom du fournisseur du produit'
                                                      //     : null,
                                                      controller:
                                                          suppController,

                                                      focusNode: focusNode,
                                                      onChanged: (value) {
                                                        _state = null;
                                                      },
                                                      cursorColor: Colors.black,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: _stateFocusNode
                                                                    .hasFocus ||
                                                                _state != null
                                                            ? null
                                                            : 'اختر ولاية ',
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
                                                    );
                                                  },
                                                  itemBuilder:
                                                      (context, suggestion) {
                                                    return ListTile(
                                                      title:
                                                          Text(suggestion.name),
                                                    );
                                                  },
                                                  onSelected: (suggestion) {
                                                    setState(() {
                                                      _state = suggestion;
                                                      _stateController.text =
                                                          suggestion.name;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                  'البلدية',
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
                                                  controller: _zoneController,
                                                  focusNode: _zoneFocusNode,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? 'الرجاء إدخال البلدية'
                                                      : null,
                                                  cursorColor: Colors.black,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    labelText: _zoneFocusNode
                                                                .hasFocus ||
                                                            _zone != null
                                                        ? null
                                                        : 'أدخل البلدية',
                                                    labelStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
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
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.green,
                                                              width: 3,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                  ),
                                                  onChanged: (value) {
                                                    if (value == "") {
                                                      _zone = null;
                                                    } else {
                                                      _zone = value;
                                                    }
                                                  },
                                                  onSaved: (value) =>
                                                      _zone = value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            key: ValueKey(weightWidgetValue
                                                .length), // Add a unique key based on itemCount

                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: weightWidgetValue.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  AddWeightWidget(
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
                                                          index]), // Display AddWeightWidget
                                                  const SizedBox(
                                                      height:
                                                          10), // Spacing between widgets
                                                ],
                                              );
                                            },
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
                                              'الوزن الإجمالي : $_totalWeight'),
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
                                                await _submitForm(
                                                    tokenProvider.token!,
                                                    companyProvider);
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

  Future<void> _submitForm(
      String token, CompanyProvider companyProvider) async {
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
        await generatePdf(companyProvider, _customer!, _totalSum, pdf2, ress);
        await printPdf(token, ress);
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
      bool ress = await UpdateCustomer(token, widget.customer!.id!, customer);
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
        await generatePdf(
            companyProvider, _customer!, _totalSum, pdf2, widget.customer!.id);
        await printPdf(token, widget.customer!.id);
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
    Navigator.pushReplacementNamed(context, '/');
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
