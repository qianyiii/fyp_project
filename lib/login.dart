import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatefulWidget {
  static String id = 'login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? email;
  String? password;

  bool _isObscure = true;

  //create a private FirebaseAuth instance
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
        body: Stack(
        children: [
          Container(
          //Used to decorate the container widget with an image as its background.
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bckimg.gif'),
              fit: BoxFit.cover,
            ),
          ),
          child: Opacity(
            opacity: 0.5, // 50% opacity
            child: Container(
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 450,
            width: 550,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(45),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      'Welcome Back !',
                      style: TextStyle(fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 40,left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Access your account below',
                        style: TextStyle(fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 450,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    onChanged: (value){
                      email = value;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      } else if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 450,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    onChanged: (value){
                      password = value;
                    },
                    obscureText: _isObscure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure? Icons.visibility: Icons.visibility_off),
                        onPressed: (){
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 25,),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try{
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();


                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter email and password.')),
                          );
                          return;
                        }

                        // 使用 Firebase Authentication 服务来进行身份验证
                        var userCredential = await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // 如果身份验证成功，则跳转到主页
                        if (userCredential.user != null) {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()),);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Log In'),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
      ),
    ),
    );
  }
}
