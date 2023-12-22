import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/add_customer.dart';
import 'package:fyp_project/update_customer.dart'; // Import the UpdateCustomerPage

class SelectCustomerPage extends StatefulWidget {
  static String id = 'select_customer';

  @override
  State<SelectCustomerPage> createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  final TextEditingController _searchController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  void _navigateToUpdateCustomer(String customerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCustomerPage(customerId: customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Customer'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          // Add Customer Icon Button
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              // Navigate to the AddCustomerPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCustomerPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Trigger the stream again with the updated search term
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search Customers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('customers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs;

                if (docs == null || docs.isEmpty) {
                  return Center(child: Text('No available customer.'));
                }

                var filteredDocs = docs.where((doc) {
                  final firstName = doc['first name'].toString().toLowerCase();
                  final searchTerm = _searchController.text.toLowerCase();
                  return firstName.contains(searchTerm);
                }).toList();

                return ListView(
                  children: filteredDocs.map((doc) {
                    final firstName = doc['first name'];
                    final lastName = doc['last name'];
                    final email = doc['email'];
                    final phone = doc['phone'];
                    final id = doc.id;

                    return GestureDetector(
                      onTap: () {
                        // Send the selected customer information back to the previous screen
                        Navigator.pop(context, {
                          'firstName': firstName,
                          'lastName': lastName,
                          'email': email,
                          'phone': phone,
                        });
                      },
                      onLongPress: () {
                        // Navigate to the UpdateCustomerPage with the selected customer ID
                        _navigateToUpdateCustomer(id);
                      },
                      child: Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('First Name: $firstName'),
                              Text('Last Name: $lastName'),
                              Text('Email: $email'),
                              Text('Phone: (+60) $phone'),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text('Are you sure you want to delete $lastName?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _firestore.collection('customers').doc(id).delete();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('$lastName deleted'),
                                            ));
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (value == 'update') {
                                // Navigate to the UpdateCustomerPage with the selected customer ID
                                _navigateToUpdateCustomer(id);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'update',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Update'),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
