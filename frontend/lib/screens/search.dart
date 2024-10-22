import 'package:flutter/material.dart';
import '../Layout/HomeLayout.dart';
import '../services/models/Customer.dart';
import '../services/API/Customer.dart';
import '../services/models/Token.dart';
import 'package:provider/provider.dart';
import '../components/CustomerCardWidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Customer> customers = [];
  bool _isLoading = false;
  bool _searchWithId = false;

  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen for focus changes

    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  Future<void> setCustomers(String? token, String query) async {
    final tempCustomers = await searchCustomers(token, query);
    setState(() {
      customers = tempCustomers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokenProvider = Provider.of<TokenProvider>(context);

    return Scaffold(
      body: tokenProvider.isLoading
          ? Center(child: const CircularProgressIndicator())
          : Homelayout(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: !_isLoading
                    ? Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              focusNode:
                                  _searchFocusNode, // Attach the FocusNode here

                              keyboardType: TextInputType.text,

                              cursorColor: const Color(0xFF757575),

                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search, // Search icon
                                  color: Colors.white, // Icon color
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                filled: true,
                                fillColor: Colors.green[800],
                                hintText: 'البحث عن العميل',
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
                                setState(() {
                                  _isLoading = true;
                                });
                                if (value != "") {
                                  setCustomers(tokenProvider.token, value);
                                } else {
                                  setState(() {
                                    customers = [];
                                  });
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GridView.count(
                              physics:
                                  NeverScrollableScrollPhysics(), // Disables scrolling
                              shrinkWrap:
                                  true, // Makes the GridView take the minimum height required

                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10, // Space between columns
                              mainAxisSpacing: 10, // Space between rows
                              padding: EdgeInsets.all(10),

                              children:
                                  List.generate(customers.length, (index) {
                                return Customercardwidget(
                                  customer: customers[index],
                                  token: tokenProvider.token!,
                                );
                              }),
                            ),
                            const SizedBox(
                              height: 80,
                            )
                          ],
                        ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator(
                            color: Colors.green[900],
                          )
                        ],
                      ),
              ),
            ),
    );
  }
}
