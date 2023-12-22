import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomerPage extends StatefulWidget {
  static String id = 'add_customer';

  @override
  State<AddCustomerPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddCustomerPage> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                firstName = value;
              },
              controller: _fnameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                lastName = (value);
              },
              controller: _lnameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                email = value;
              },
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                phone = value;
              },
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone (+60)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Create a map with the input data
                Map<String, dynamic> dataToSave = {
                  'first name': _fnameController.text,
                  'last name': _lnameController.text,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                };

                // Add data to Firestore
                await FirebaseFirestore.instance.collection('customers').add(dataToSave);

                // Show SnackBar for successful addition
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Customer added successfully!'),
                  ),
                );

                // Clear text fields
                _fnameController.clear();
                _lnameController.clear();
                _emailController.clear();
                _phoneController.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
