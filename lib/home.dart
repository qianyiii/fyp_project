import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/payment_method.dart';
import 'add_product.dart';
import 'select_customer.dart';
import 'update_product.dart'; // Import the UpdateProductPage
import 'profile_info.dart';

class Home extends StatefulWidget {
  static String id = 'home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _cartItems = [];
  Map<String, dynamic>? _selectedCustomer;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _buildAppBarTitle(),
      ),
      body: _buildBodyContent(), // Use the method to build body content
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu_outlined),
            label: 'Purchase History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Hold Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[200],
        unselectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildAppBarTitle() {
    if (_selectedIndex == 0) {
      return Text('Smart Checkout');
    } else if (_selectedIndex == 3) {
      return Row(
        children: [
          Expanded(
            child: Text('About Us'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout here
              _handleLogout();
            },
          ),
        ],
      );
    } else {
      // Add your search bar or other widgets here for other conditions
      return Text('Default Title');
    }
  }

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'login'); // Replace with your login page route
  }

  // Method to build body content based on the selected index
  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
      // Home
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: YourProductListView(),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.green[50],
                child: Center(
                  // Show cart details here
                  child: Column(
                    children: [
                      // Display selected customer name

                      InkWell(
                        onTap: () {
                          // Navigate to the Select Customer page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectCustomerPage()),
                          ).then((selectedCustomer) {
                            // Update the selected customer when the SelectCustomerPage is popped
                            if (selectedCustomer != null) {
                              setState(() {
                                _selectedCustomer = selectedCustomer;
                              });
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_circle_rounded),
                            // Display the customer's name if selected
                            Text(_selectedCustomer != null
                                ? ' ${_selectedCustomer!['firstName']} ${_selectedCustomer!['lastName']}'
                                : ' Customer'),
                          ],
                        ),
                      ),
                      // Display cart items
                      Expanded(
                        child: YourCartDetailsListView(), // Use a separate widget for your cart details list
                      ),
                      Divider(),
                      Text('Total: RM ${_calculateTotal()}'),
                      ElevatedButton(
                        onPressed: () {
                          // Handle the "Pay" button click event
                          _handlePay();
                        },
                        child: Text('Pay'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
      // Purchase History
        return YourPurchaseHistoryView(); // Implement YourPurchaseHistoryView
      case 2:
      // Hold Cart
        return YourHoldCartView(); // Implement YourHoldCartView
      case 3:
      // More
        return YourAdminProfileView(); // Implement YourAdminProfileView
      default:
        return Container();
    }
  }

// YourProductListView Widget
  Widget YourProductListView() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var products = snapshot.data!.docs;

        // Filter products based on search query
        var filteredProducts = products.where((product) {
          String productName = product['name'].toString().toLowerCase();
          return productName.contains(_searchQuery.toLowerCase());
        }).toList();

        return Column(
          children: [
            // Add a search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  var product = filteredProducts[index];
                  var code = product['code'];
                  var productName = product['name'];
                  var price = product['price'];
                  var quantity = product['quantity'];

                  return InkWell(
                    onTap: () {
                      _addToCart(product);
                    },
                    child: Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Code: ${code ?? 'N/A'}'),
                            Text('Product Name: $productName'),
                            Text('Price: RM $price'),
                            Text('Quantity: $quantity'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'update') {
                              _navigateToUpdateProduct(product);
                            } else if (value == 'delete') {
                              _handleDeleteProduct(product);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'update',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
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
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProductPage()),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// YourCartDetailsListView Widget
  Widget YourCartDetailsListView() {
    return ListView.builder(
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        var cartItem = _cartItems[index];
        double subtotal = cartItem['price'] * cartItem['quantity'];

        return ListTile(
          title: Text('${cartItem['name']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: RM ${cartItem['price']}'),
              Text('Quantity: ${cartItem['quantity']}'),
              Text('Subtotal: RM $subtotal'),
            ],
          ),
        );
      },
    );
  }

  void _addToCart(QueryDocumentSnapshot<Object?> product) {
    setState(() {
      var existingIndex = _cartItems.indexWhere((item) => item['name'] == product['name']);

      if (existingIndex != -1) {
        _cartItems[existingIndex]['quantity'] += 1;
      } else {
        _cartItems.add({
          'name': product['name'],
          'price': product['price'],
          'quantity': 1,
        });
      }

      int remainingQuantity = product['quantity'] - 1;
      if (remainingQuantity >= 0) {
        FirebaseFirestore.instance
            .collection('products')
            .doc(product.id)
            .update({'quantity': remainingQuantity});
      }
    });
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var cartItem in _cartItems) {
      total += cartItem['price'] * cartItem['quantity'];
    }
    return total;
  }

  Future<void> _handlePay() async {
    if (_selectedCustomer != null && _cartItems.isNotEmpty) {
      var paymentResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectPaymentMethodPage(
            selectedCustomer: _selectedCustomer!,
            cartItems: _cartItems,
            totalAmount: _calculateTotal(),
          ),
        ),
      );

      if (paymentResult == 'success') {
        await _updateProductQuantities();
      } else {
        print('Payment failed. Please try again.');
      }
    } else {
      print('Error: No customer selected or cart is empty.');
    }
  }

  Future<void> _updateProductQuantities() async {
    for (var cartItem in _cartItems) {
      var productRef = FirebaseFirestore.instance.collection('products').where('name', isEqualTo: cartItem['name']);

      await productRef.get().then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var productDoc = querySnapshot.docs.first;
          var remainingQuantity = productDoc['quantity'] - cartItem['quantity'];

          if (remainingQuantity >= 0) {
            productDoc.reference.update({'quantity': remainingQuantity});
          } else {
            print('Error: Insufficient quantity for ${cartItem['name']}.');
          }
        }
      });
    }
  }

  void _navigateToUpdateProduct(QueryDocumentSnapshot<Object?> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(productId: product.id),
      ),
    );
  }

  void _handleDeleteProduct(QueryDocumentSnapshot<Object?> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${product['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('products').doc(product.id).delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${product['name']} deleted'),
                ));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget YourPurchaseHistoryView() {
    // Placeholder method for YourPurchaseHistoryView
    return Center(
      child: Text('Your Purchase History View'),
    );
  }

  Widget YourHoldCartView() {
    // Placeholder method for YourHoldCartView
    return Center(
      child: Text('Your Hold Cart View'),
    );
  }

  // YourAdminProfileView Widget
  Widget YourAdminProfileView() {
    return AdminProfileView();
  }
}

