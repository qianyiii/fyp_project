import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProductPage extends StatefulWidget {
  static String id = 'update_product';

  final String productId;

  UpdateProductPage({required this.productId});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate and update product
                _updateProduct();
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load the existing product data when the page is initialized
    _loadProductData();
  }

  void _loadProductData() async {
    // Fetch the product data from Firestore using the provided product ID
    var productDoc = await _firestore.collection('products').doc(widget.productId).get();

    if (productDoc.exists) {
      // Update the text controllers with the existing product data
      var data = productDoc.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? '';
      _priceController.text = data['price']?.toString() ?? '';
      _quantityController.text = data['quantity']?.toString() ?? '';
    }
  }

  void _updateProduct() {
    // Validate product data
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _quantityController.text.isEmpty) {
      // Show an error message if required fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product Name, Price, and Quantity are required.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Update product data in Firestore
    _firestore.collection('products').doc(widget.productId).update({
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'quantity': int.parse(_quantityController.text),
    }).then((value) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product updated successfully.'),
        backgroundColor: Colors.green,
      ));
      // Navigate back to the previous screen
      Navigator.pop(context);
    }).catchError((error) {
      // Show an error message if updating fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating product: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
