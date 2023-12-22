import 'package:flutter/material.dart';
import 'package:fyp_project/payment_status.dart';

class SelectPaymentMethodPage extends StatefulWidget {
  static String id = 'payment_method';

  final Map<String, dynamic> selectedCustomer;
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  SelectPaymentMethodPage({
    required this.selectedCustomer,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  _SelectPaymentMethodPageState createState() => _SelectPaymentMethodPageState();
}

class _SelectPaymentMethodPageState extends State<SelectPaymentMethodPage> {
  String _selectedPaymentMethod = 'Cash';
  double _cashGiven = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer: ${widget.selectedCustomer['firstName']} ${widget.selectedCustomer['lastName']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text('Selected Payment Method: $_selectedPaymentMethod'),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _updatePaymentMethod('Cash');
                    },
                    child: Text('Cash'),
                  ),
                ),
                SizedBox(width: 16.0), // Add some spacing between the buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _updatePaymentMethod('Credit Card');
                    },
                    child: Text('Credit Card'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Total Amount: RM ${widget.totalAmount}'),
            Divider(),
            if (_selectedPaymentMethod == 'Cash')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cash Payment:'),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0.00', // Set the initial value to 0.00
                    onChanged: (value) {
                      setState(() {
                        _cashGiven = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(hintText: 'Enter Cash Amount (RM)'),
                  ),
                  SizedBox(height: 16.0),
                  Text('Change Amount: RM ${_cashGiven >= widget.totalAmount ? (_cashGiven - widget.totalAmount) : 0.00}'),
                ],
              ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _placeOrder();
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _placeOrder() {
    // Implement the logic to place the order with the selected payment method
    // You can use the values from widget.selectedCustomer, widget.cartItems, and widget.totalAmount
    // Navigate to the OrderSuccessPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessPage(
          totalAmount: widget.totalAmount,
          numberOfItems: widget.cartItems.length,
        ),
      ),
    );
  }
}
