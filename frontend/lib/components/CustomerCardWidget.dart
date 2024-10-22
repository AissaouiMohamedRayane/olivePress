import 'package:flutter/material.dart';
import '../screens/AddCustomer.dart';
import '../screens/DeleteCustomer.dart';
import '../services/models/Customer.dart';

class Customercardwidget extends StatefulWidget {
  final Customer customer;
  final String token;
  const Customercardwidget(
      {super.key, required this.customer, required this.token});

  @override
  State<Customercardwidget> createState() => _CustomercardwidgetState();
}

class _CustomercardwidgetState extends State<Customercardwidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Your onPressed function logic here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return widget.customer.isActive
                  ? AddCustomerPage(
                      customer: widget.customer,
                    )
                  : DeleteCustomer(customer: widget.customer, token: widget.token);
            }),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: widget.customer.isActive
                              ? Image.asset(
                                  'assets/images/profile2.png',
                                )
                              : Text(
                                  'تم الحذف',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                )),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.customer.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                              width:
                                  10), // Optional: Adds space between the name and ID
                          Text(
                            widget.customer.id.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )),
                ]),
          ),
        ));
  }
}
