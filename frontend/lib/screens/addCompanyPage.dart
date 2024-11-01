import 'package:flutter/material.dart';
import 'package:frontend/services/API/company.dart';
import 'package:frontend/services/models/Token.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/models/Company.dart';
import '../Layout/ChildPagesLayout.dart';

class AddCompanyPage extends StatefulWidget {
  final Company? editCompany;

  AddCompanyPage({Key? key, this.editCompany}) : super(key: key);
  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _address;
  String? _phone1;
  String? _phone2;
  String? _oliveSession;
  String? _oliveSessionStart;
  String? _greenOlive;
  String? _redOlive;
  String? _droOlive;
  String? _sign;

  bool enabeld = false;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _phone1FocusNode = FocusNode();
  FocusNode _phone2FocusNode = FocusNode();
  FocusNode _signFocusNode = FocusNode();
  FocusNode _oliveSessionFocusNode = FocusNode();
  FocusNode _oliveSessionStartFocusNode = FocusNode();
  FocusNode _greenOliveFocusNode = FocusNode();
  FocusNode _redOliveFocusNode = FocusNode();
  FocusNode _droOliveFocusNode = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phone1Controller = TextEditingController();
  TextEditingController _phone2Controller = TextEditingController();
  TextEditingController _signController = TextEditingController();
  TextEditingController _oliveSessionController = TextEditingController();
  TextEditingController _oliveSessionStartController = TextEditingController();
  TextEditingController _greenOliveController = TextEditingController();
  TextEditingController _redOliveController = TextEditingController();
  TextEditingController _droOliveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('ba3');
    // Listen for focus changes

    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _addressFocusNode.addListener(() {
      setState(() {});
    });
    _phone1FocusNode.addListener(() {
      setState(() {});
    });
    _phone2FocusNode.addListener(() {
      setState(() {});
    });
    _signFocusNode.addListener(() {
      setState(() {});
    });
    _oliveSessionFocusNode.addListener(() {
      setState(() {});
    });
    _oliveSessionStartFocusNode.addListener(() {
      setState(() {});
    });
    _greenOliveFocusNode.addListener(() {
      setState(() {});
    });
    _redOliveFocusNode.addListener(() {
      setState(() {});
    });
    _droOliveFocusNode.addListener(() {
      setState(() {});
    });

    if (widget.editCompany != null) {
      enabeld = true;
      _name = widget.editCompany!.name;
      _nameController.text = widget.editCompany!.name;

      _address = widget.editCompany!.address;
      _addressController.text = widget.editCompany!.address;

      _phone1 = widget.editCompany!.phone1;
      _phone1Controller.text = widget.editCompany!.phone1;

      _oliveSession = widget.editCompany!.session;
      _oliveSessionController.text = widget.editCompany!.session;

      _oliveSessionStart = widget.editCompany!.sessionStart;
      _oliveSessionStartController.text = widget.editCompany!.sessionStart;

      _greenOlive = widget.editCompany!.priceGreenOlive.toString();
      _greenOliveController.text =
          widget.editCompany!.priceGreenOlive.toString();

      _droOlive = widget.editCompany!.priceBlackOlive.toString();
      _droOliveController.text = widget.editCompany!.priceBlackOlive.toString();

      _redOlive = widget.editCompany!.priceRedOlive.toString();
      _redOliveController.text = widget.editCompany!.priceRedOlive.toString();

      if (widget.editCompany!.phone2 != null) {
        _phone2 = widget.editCompany!.phone2;
        _phone2Controller.text = widget.editCompany!.phone2!;
      }
      if (widget.editCompany!.sign != null) {
        _sign = widget.editCompany!.sign;
        _signController.text = widget.editCompany!.sign!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
        body: tokenProvider.isLoading || companyProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ChildPagesLayout(
                text:
                    widget.editCompany == null ? 'اضافة شركة' : 'تعديل الشركة',
                center: widget.editCompany == null ? true : false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الاسم',
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
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                focusNode: _nameFocusNode,
                                validator: (value) => value!.isEmpty
                                    ? 'الرجاء إدخال الاسم'
                                    : null,
                                cursorColor: const Color(0xFF757575),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText:
                                      _nameFocusNode.hasFocus || _name != null
                                          ? null
                                          : 'أدخل الاسم',
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
                                'العنوان',
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
                                controller: _addressController,
                                keyboardType: TextInputType.text,
                                focusNode: _addressFocusNode,
                                validator: (value) => value!.isEmpty
                                    ? "الرجاء إدخال العنوان"
                                    : null,
                                cursorColor: const Color(0xFF757575),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: _addressFocusNode.hasFocus ||
                                          _address != null
                                      ? null
                                      : "أدخل العنوان",
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
                                    _address = null;
                                  } else {
                                    _address = value;
                                  }
                                },
                                onSaved: (value) => _address = value,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'الرقم الأول',
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
                                            controller: _phone1Controller,
                                            keyboardType: TextInputType.number,
                                            focusNode: _phone1FocusNode,
                                            validator: (value) =>
                                                value!.length != 10
                                                    ? " الرقم غير صحيح"
                                                    : null,
                                            cursorColor:
                                                const Color(0xFF757575),
                                            decoration: InputDecoration(
                                              labelText:
                                                  _phone1FocusNode.hasFocus ||
                                                          _phone1 != null
                                                      ? null
                                                      : 'أدخل الرقم الأول',
                                              labelStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF757575)),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 20,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF757575),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.green,
                                                    width: 3,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onChanged: (value) {
                                              if (value == "") {
                                                _phone1 = null;
                                              } else {
                                                _phone1 = value;
                                              }
                                              if (value.length == 10) {
                                                setState(() {
                                                  enabeld = true;
                                                });
                                              } else {
                                                setState(() {
                                                  enabeld = false;
                                                });
                                              }
                                            },
                                            onSaved: (value) =>
                                                _phone1 = value),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'الرقم الثاني',
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
                                            controller: _phone2Controller,
                                            enabled: enabeld,
                                            keyboardType: TextInputType.number,
                                            focusNode: _phone2FocusNode,
                                            validator: (value) => enabeld
                                                ? value == null || value == ''
                                                    ? null
                                                    : value.length == 10
                                                        ? null
                                                        : 'الرقم غير صحيح'
                                                : null,
                                            cursorColor:
                                                const Color(0xFF757575),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                              labelText:
                                                  _phone2FocusNode.hasFocus ||
                                                          _phone2 != null
                                                      ? null
                                                      : 'أدخل الرقم الثاني',
                                              labelStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF757575)),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 20,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF757575),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.green,
                                                    width: 3,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onChanged: (value) {
                                              if (value == "") {
                                                _phone2 = null;
                                              } else {
                                                _phone2 = value;
                                              }
                                            },
                                            onSaved: (value) =>
                                                _phone2 = value),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'موسم الزيتون',
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
                                controller: _oliveSessionController,
                                keyboardType: TextInputType.text,
                                focusNode: _oliveSessionFocusNode,
                                validator: (value) {
                                  // Define the pattern for the 'YYYY/YYYY' format
                                  final pattern = RegExp(r'^\d{4}/\d{4}$');

                                  if (value == null || value.isEmpty) {
                                    return "الرجاء إدخال موسم الزيتون";
                                  } else if (!pattern.hasMatch(value)) {
                                    return "التنسيق المطلوب XXXX/XXXX (مثال: 2023/2024)";
                                  } else {
                                    // Split the value into two years and check if the second year is greater by 1
                                    final years = value.split('/');
                                    final firstYear = int.tryParse(years[0]);
                                    final secondYear = int.tryParse(years[1]);

                                    if (firstYear == null ||
                                        secondYear == null ||
                                        secondYear != firstYear + 1) {
                                      return "موسم غير صحيح";
                                    }
                                  }

                                  return null;
                                },
                                cursorColor: const Color(0xFF757575),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: _oliveSessionFocusNode.hasFocus ||
                                          _oliveSession != null
                                      ? null
                                      : "أدخل موسم الزيتون",
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
                                    _oliveSession = null;
                                  } else {
                                    _oliveSession = value;
                                  }
                                },
                                onSaved: (value) => _oliveSession = value,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'بداية الموسم',
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
                                controller: _oliveSessionStartController,
                                keyboardType: TextInputType.text,
                                focusNode: _oliveSessionStartFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "الرجاء إدخال التاريخ";
                                  }

                                  try {
                                    // Define the expected date format (yyyy-MM-dd)
                                    final dateFormat = DateFormat('yyyy-MM-dd');
                                    final parsedDate =
                                        dateFormat.parseStrict(value);

                                    // Check if the input matches exactly the 'yyyy-MM-dd' pattern
                                    final regex =
                                        RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                    if (!regex.hasMatch(value)) {
                                      return "التنسيق المطلوب YYYY-MM-DD";
                                    }

                                    // Check if the year is greater than 2020
                                    if (parsedDate.year <= 2020) {
                                      return "يجب أن يكون العام أكبر من 2020";
                                    }

                                    // Optionally, check if the parsed date is in the future
                                  } catch (e) {
                                    return "التنسيق المطلوب YYYY-MM-DD";
                                  }

                                  return null;
                                },
                                cursorColor: const Color(0xFF757575),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText:
                                      _oliveSessionStartFocusNode.hasFocus ||
                                              _oliveSessionStart != null
                                          ? null
                                          : "أدخل بداية الموسم",
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
                                    _oliveSessionStart = null;
                                  } else {
                                    _oliveSessionStart = value;
                                  }
                                },
                                onSaved: (value) => _oliveSessionStart = value,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Prices',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF757575)),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                        controller: _greenOliveController,
                                        keyboardType: TextInputType.number,
                                        focusNode: _greenOliveFocusNode,
                                        validator: (value) => value!.isEmpty
                                            ? "الرجاء إدخال سعر الزيتون الاخضر"
                                            : null,
                                        cursorColor: const Color(0xFF757575),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText:
                                              _greenOliveFocusNode.hasFocus ||
                                                      _greenOlive != null
                                                  ? null
                                                  : "أخضر",
                                          labelStyle: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF757575)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 20,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF757575),
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
                                            _greenOlive = null;
                                          } else {
                                            _greenOlive = value;
                                          }
                                        },
                                        onSaved: (value) =>
                                            _greenOlive = value),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        controller: _redOliveController,
                                        keyboardType: TextInputType.number,
                                        focusNode: _redOliveFocusNode,
                                        validator: (value) => value!.isEmpty
                                            ? "الرجاء إدخال سعر الزيتون أحمر"
                                            : null,
                                        cursorColor: const Color(0xFF757575),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText:
                                              _redOliveFocusNode.hasFocus ||
                                                      _redOlive != null
                                                  ? null
                                                  : "أحمر",
                                          labelStyle: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF757575)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 20,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF757575),
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
                                            _redOlive = null;
                                          } else {
                                            _redOlive = value;
                                          }
                                        },
                                        onSaved: (value) => _redOlive = value),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        controller: _droOliveController,
                                        keyboardType: TextInputType.number,
                                        focusNode: _droOliveFocusNode,
                                        validator: (value) => value!.isEmpty
                                            ? "الرجاء إدخال سعر الزيتون أسود"
                                            : null,
                                        cursorColor: const Color(0xFF757575),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText:
                                              _droOliveFocusNode.hasFocus ||
                                                      _droOlive != null
                                                  ? null
                                                  : "أسود",
                                          labelStyle: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF757575)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 20,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0xFF757575),
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
                                            _droOlive = null;
                                          } else {
                                            _droOlive = value;
                                          }
                                        },
                                        onSaved: (value) => _droOlive = value),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'علامة',
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
                                controller: _signController,
                                keyboardType: TextInputType.text,
                                focusNode: _signFocusNode,
                                validator: (value) => value!.isEmpty
                                    ? "يرجى إدخال العلامة"
                                    : null,
                                cursorColor: const Color(0xFF757575),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText:
                                      _signFocusNode.hasFocus || _sign != null
                                          ? null
                                          : "أدخل العلامة",
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
                                    _sign = null;
                                  } else {
                                    _sign = value;
                                  }
                                },
                                onSaved: (value) => _sign = value,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _submitForm(
                                        tokenProvider.token!, companyProvider);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.green,
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
                                    "حفظ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ));
  }

  Future<void> _submitForm(
      String token, CompanyProvider companyProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Save the form state

      Company company = Company(
        id: widget.editCompany == null ? null : widget.editCompany!.id,
        name: _name!,
        address: _address!,
        phone1: _phone1!,
        phone2: _phone2,
        sign: _sign,
        session: _oliveSession!,
        sessionStart: _oliveSessionStart!,
        priceGreenOlive: _greenOlive == null || _greenOlive == ''
            ? 0
            : int.parse(_greenOlive!),
        priceRedOlive:
            _redOlive == null || _redOlive == '' ? 0 : int.parse(_redOlive!),
        priceBlackOlive:
            _droOlive == null || _droOlive == '' ? 0 : int.parse(_droOlive!),
      );

      int? id;
      if (widget.editCompany != null) {
        id = await updateCompany(token, company);
      } else {
        id = await addCompany(token, company);
      }
      if (id != null) {
        await companyProvider.addNewCompany(company);

        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' failed to create.')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose FocusNodes
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _phone1FocusNode.dispose();
    _phone2FocusNode.dispose();
    _signFocusNode.dispose();
    _oliveSessionFocusNode.dispose();
    _oliveSessionStartFocusNode.dispose();
    _greenOliveFocusNode.dispose();
    _redOliveFocusNode.dispose();
    _droOliveFocusNode.dispose();

    // Dispose TextEditingControllers
    _nameController.dispose();
    _addressController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _signController.dispose();
    _oliveSessionController.dispose();
    _oliveSessionStartController.dispose();
    _greenOliveController.dispose();
    _redOliveController.dispose();
    _droOliveController.dispose();

    super.dispose();
  }
}
