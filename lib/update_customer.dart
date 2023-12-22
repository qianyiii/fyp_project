import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCustomerPage extends StatefulWidget {
  static String id = 'update_customer';

  final String customerId;

  UpdateCustomerPage({required this.customerId});

  @override
  State<UpdateCustomerPage> createState() => _UpdateCustomerPageState();
}

class _UpdateCustomerPageState extends State<UpdateCustomerPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate and update customer
                _updateCustomer();
              },
              child: Text('Update Customer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load the existing customer data when the page is initialized
    _loadCustomerData();
  }

  void _loadCustomerData() async {
    // Fetch the customer data from Firestore using the provided customer ID
    var customerDoc = await _firestore.collection('customers').doc(widget.customerId).get();

    if (customerDoc.exists) {
      // Update the text controllers with the existing customer data
      var data = customerDoc.data() as Map<String, dynamic>;
      _firstNameController.text = data['first name'] ?? '';
      _lastNameController.text = data['last name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
    }
  }

  void _updateCustomer() {
    // Validate customer data
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      // Show an error message if required fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('First Name and Last Name are required.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Update customer data in Firestore
    _firestore.collection('customers').doc(widget.customerId).update({
      'first name': _firstNameController.text,
      'last name': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    }).then((value) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Customer updated successfully.'),
        backgroundColor: Colors.green,
      ));
      // Navigate back to the previous screen
      Navigator.pop(context);
    }).catchError((error) {
      // Show an error message if updating fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating customer: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
