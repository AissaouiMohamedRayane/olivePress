import 'package:flutter/material.dart';
import 'package:frontend/services/API/customer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../Layout/ChildPagesLayout.dart';

import '../services/models/Company.dart';
import '../services/models/Customer.dart';
import '../services/models/Token.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  final List<Widget> _addWeightWidgets = [
    AddWeightWidget(
      onWeightValueChange: null,
      index: 1,
      removeAddNewWeightWidget: null,
    ),
  ];
  List<Map<String, int?>> weightWidgetValue = [
    {
      'number': null,
      'weight': null,
    }
  ];

  void _addNewWeightWidget() {
    weightWidgetValue.add({
      'number': null,
      'weight': null,
    });
    setState(() {
      _addWeightWidgets.add(
        AddWeightWidget(
          onWeightValueChange: null,
          index: 1,
          removeAddNewWeightWidget: removeAddNewWeightWidget,
        ),
      );
    });
  }

  void removeAddNewWeightWidget(int index) {
    setState(() {
      _addWeightWidgets.removeAt(index);
    });
  }

  void _onWeightValueChange(int index, Map<String, int?> value) {
    print(index);
    print(value);
    setState(() {
      weightWidgetValue[index] = value;
    });
    print(weightWidgetValue);
  }

  String? _name;
  String? _phone;
  Wilaya? _state;
  String? _zone;
  int? _containersNumber;
  int? _containerCapacity;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _zoneFocusNode = FocusNode();
  final FocusNode _containersNumberFocusNode = FocusNode();
  final FocusNode _containerCapacityFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _containersNumberController =
      TextEditingController();
  final TextEditingController _containerCapacityController =
      TextEditingController();
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
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    final statesProvider = Provider.of<StatesProvider>(context);
    final tokenProvider = Provider.of<TokenProvider>(context);

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: companyProvider.isLoading ||
                statesProvider.isLoading ||
                tokenProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ChildPagesLayout(
                text: 'Add Customer',
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
                          Form(
                              key: _formKey,
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                blurRadius: 5, // Blur radius
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
                                                        'Full Name',
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
                                                            _nameController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        focusNode:
                                                            _nameFocusNode,
                                                        validator: (value) =>
                                                            value!.isEmpty
                                                                ? 'Veuillez entrer le nom et prénom'
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
                                                                  _name != null
                                                              ? null
                                                              : 'Entrer le nom',
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
                                                        'Nemuro',
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
                                                              _phoneController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          focusNode:
                                                              _phoneFocusNode,
                                                          validator: (value) =>
                                                              value!.length !=
                                                                      10
                                                                  ? " incorrecte"
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
                                                                : 'Entrer le Nemuro ',
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
                                                              _phone = null;
                                                            } else {
                                                              _phone = value;
                                                            }
                                                          },
                                                          onSaved: (value) =>
                                                              _phone = value),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'State',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
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
                                                return statesProvider.states!
                                                    .where((state) =>
                                                        // Convert both state name and pattern to lowercase for case-insensitive matching
                                                        state
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(pattern
                                                                .toLowerCase()))
                                                    .toList();
                                              },
                                              builder: (context, suppController,
                                                  focusNode) {
                                                return TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  // validator: (value) => value!.isEmpty
                                                  //     ? 'Veuillez selectionner le nom du fournisseur du produit'
                                                  //     : null,
                                                  controller: suppController,

                                                  focusNode: focusNode,
                                                  onChanged: (value) {
                                                    _state = null;
                                                  },
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                    labelText: _stateFocusNode
                                                                .hasFocus ||
                                                            _state != null
                                                        ? null
                                                        : 'Choose a state ',
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
                                                );
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion.name),
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
                                              'Zone',
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
                                              controller: _zoneController,
                                              focusNode: _zoneFocusNode,
                                              keyboardType: TextInputType.text,
                                              validator: (value) => value!
                                                      .isEmpty
                                                  ? 'Veuillez entrer le nom et prénom'
                                                  : null,
                                              cursorColor: Colors.black,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: InputDecoration(
                                                labelText:
                                                    _zoneFocusNode.hasFocus ||
                                                            _zone != null
                                                        ? null
                                                        : 'Entrer la zone',
                                                labelStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 20,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.green,
                                                          width: 3,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                              ),
                                              onChanged: (value) {
                                                if (value == "") {
                                                  _zone = null;
                                                } else {
                                                  _zone = value;
                                                }
                                              },
                                              onSaved: (value) => _zone = value,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _addWeightWidgets.length,
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
                                                  index:
                                                      index), // Display AddWeightWidget
                                              const SizedBox(
                                                  height:
                                                      10), // Spacing between widgets
                                            ],
                                          );
                                        },
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                            onPressed: _addNewWeightWidget,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(
                                                Colors.green,
                                              ),
                                            ),
                                            child: Text(
                                              'add bag',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            )),
                                      ),
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
                                                blurRadius: 5, // Blur radius
                                              ),
                                            ],
                                            color: Colors.white),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Nombre',
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
                                                        _containersNumberController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    focusNode:
                                                        _containersNumberFocusNode,
                                                    validator: (value) => value!
                                                            .isEmpty
                                                        ? 'Veuillez entrer le nom et prénom'
                                                        : null,
                                                    cursorColor: Colors.black,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration: InputDecoration(
                                                      labelText: _containersNumberFocusNode
                                                                  .hasFocus ||
                                                              _containersNumber !=
                                                                  null
                                                          ? null
                                                          : 'Nombre des récipient',
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
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
                                                            int.parse(value);
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Capacity',
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
                                                          _containerCapacityController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      focusNode:
                                                          _containerCapacityFocusNode,
                                                      cursorColor: Colors.black,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: _containerCapacityFocusNode
                                                                    .hasFocus ||
                                                                _containerCapacity !=
                                                                    null
                                                            ? null
                                                            : "Capacité des récipients",
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
                                                          _containerCapacity =
                                                              null;
                                                        } else {
                                                          _containerCapacity =
                                                              int.parse(value);
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
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _submitForm(tokenProvider.token!);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                              Colors.green,
                                            ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                // Border width
                                              ),
                                            ),
                                            padding: WidgetStateProperty.all<
                                                EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  vertical:
                                                      12.0), // Add padding
                                            ),
                                          ),
                                          child: const Text(
                                            "Enregistrer",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              )),
                          const SizedBox(
                            height: 40,
                          )
                        ]))));
  }

  Future<void> _submitForm(String token) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      List<Bags> bags = weightWidgetValue.map((bag) {
        print(bag);
        return Bags.fromJson(bag);
      }).toList();
      Containers containers =
          Containers(capacity: _containerCapacity, number: _containersNumber);
      Customer customer = Customer(
        name: _name!,
        phone: _phone!,
        state: _state!,
        zone: _zone!,
        bags: bags,
        containers: [containers],
      );
      bool ress = await AddCustomer(token, customer);
      if (ress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' created successfully.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' failed to create.',
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

class AddWeightWidget extends StatefulWidget {
  final int index;
  final Function? removeAddNewWeightWidget;
  final Function? onWeightValueChange;
  AddWeightWidget(
      {required this.index,
      required this.removeAddNewWeightWidget,
      required this.onWeightValueChange});

  @override
  State<AddWeightWidget> createState() => _AddWeightWidgetState();
}

class _AddWeightWidgetState extends State<AddWeightWidget> {
  int? _bagesNumber;
  int? _bageWeight;
  final FocusNode _bagesNumberFocusNode = FocusNode();
  final FocusNode _bageWeightFocusNode = FocusNode();
  final TextEditingController _bagesNumberController = TextEditingController();
  final TextEditingController _bageWeightController = TextEditingController();
  void _onChanged() {
    widget
        .onWeightValueChange!({'number': _bagesNumber, 'weight': _bageWeight});
  }

  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    _bagesNumberFocusNode.addListener(() {
      setState(() {});
    });
    _bageWeightFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose FocusNodes
    _bagesNumberFocusNode.dispose();
    _bageWeightFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.removeAddNewWeightWidget == null ? 130 : 170,
      padding: EdgeInsets.only(
          top: widget.removeAddNewWeightWidget == null ? 20 : 5,
          right: 15,
          left: 15,
          bottom: 15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.green[50]),
      child: Column(children: [
        widget.removeAddNewWeightWidget != null
            ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      widget.removeAddNewWeightWidget!(widget.index),
                ),
              )
            : Container(),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre',
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
                    controller: _bagesNumberController,
                    focusNode: _bagesNumberFocusNode,
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty
                        ? 'Veuillez entrer le nom et prénom'
                        : null,
                    cursorColor: Colors.black,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText:
                          _bagesNumberFocusNode.hasFocus || _bagesNumber != null
                              ? null
                              : 'Nombre des sac',
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
                        _bagesNumber = null;
                      } else {
                        _bagesNumber = int.parse(value);
                      }
                      _onChanged();
                    },
                    onSaved: (value) =>
                        _bagesNumber = value == null ? null : int.parse(value),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Poid',
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
                      controller: _bageWeightController,
                      focusNode: _bageWeightFocusNode,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText:
                            _bageWeightFocusNode.hasFocus || _bageWeight != null
                                ? null
                                : "Poid des sac",
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
                          _bageWeight = null;
                        } else {
                          _bageWeight = int.parse(value);
                        }
                        _onChanged();
                      },
                      onSaved: (value) => _bageWeight =
                          value != null ? int.parse(value) : null),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
