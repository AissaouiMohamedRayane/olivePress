import 'package:flutter/material.dart';

class AddWeightWidget extends StatefulWidget {
  final int index;
  final Function? removeAddNewWeightWidget;
  final Function? onWeightValueChange;
  final Map<String, int?> values;
  AddWeightWidget(
      {required this.index,
      required this.removeAddNewWeightWidget,
      required this.onWeightValueChange,
      required this.values});

  @override
  State<AddWeightWidget> createState() => _AddWeightWidgetState();
}

class _AddWeightWidgetState extends State<AddWeightWidget> {
  int? _bagesNumber;
  int? _bageWeight;
  final FocusNode _bagesNumberFocusNode = FocusNode();
  final FocusNode _bageWeightFocusNode = FocusNode();
  final TextEditingController _bagesNumberController = TextEditingController();
  final TextEditingController _bagesWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onChanged() {
    widget
        .onWeightValueChange!({'number': _bagesNumber, 'weight': _bageWeight});
  }

  @override
  void initState() {
    super.initState();
    _bagesNumber = widget.values['number'];
    _bageWeight = widget.values['weight'];
    _bagesNumberController.text = widget.values['number'] != null
        ? widget.values['number'].toString()
        : '';
    _bagesWeightController.text = widget.values['weight'] != null
        ? widget.values['weight'].toString()
        : '';

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
      height: 135,
      padding: const EdgeInsets.only(top: 20, right: 15, left: 15, bottom: 15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.green[50]),
      child: Stack(clipBehavior: Clip.none, children: [
        widget.removeAddNewWeightWidget != null
            ? Positioned(
                top: -20,
                right: -15,
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
                      controller: _bagesWeightController,
                      focusNode: _bageWeightFocusNode,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? 'Veuillez entrer le nom et prénom'
                          : int.parse(value) < 1
                              ? 'la valeur doit etre > 0'
                              : null,
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
