import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfileView extends StatefulWidget {
  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firebase
  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('admin').get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming there's only one admin document for the current user
          var userDoc = querySnapshot.docs.first.data();
          setState(() {
            _userName = userDoc['name'];
            _userEmail = userDoc['email'];
            _userPhone = userDoc['phone'];
          });
        } else {
          print('Admin document not found for UID: ${_user!.uid}');
        }
      } catch (e) {
        print('Error fetching admin data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/mashimaro.jpg'),
                radius: 70.0,
              ),
              SizedBox(height: 20),
              Text(
                _userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text(
                    _userEmail,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(
                    "(+60) $_userPhone",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
