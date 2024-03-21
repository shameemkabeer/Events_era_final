import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class ResetScreen extends StatefulWidget {
  final String lidpass;
  final String ipAddress;

  ResetScreen({required this.lidpass, required this.ipAddress});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  bool _obscureText = true;
  bool _obscureTexts = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 214, 111, 230),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/resetpass.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        obscureText: _obscureText,
                        style: TextStyle(
                          color: _obscureText
                              ? Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontSize: 18.0,
                        ),
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        obscureText: _obscureTexts,
                        style: TextStyle(
                          color: _obscureTexts
                              ? Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontSize: 18.0,
                        ),
                        controller: reenterPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          labelStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureTexts = !_obscureTexts;
                              });
                            },
                            icon: Icon(
                              _obscureTexts
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please re-enter the password';
                          } else if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String npass = newPasswordController.text;
                            String cpass = reenterPasswordController.text;
                            var lidp = widget.lidpass;

                            final response = await http.post(
                              Uri.parse('http://${widget.ipAddress}/newpass'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode(
                                  {'pass': npass, 'cpass': cpass, 'lid': lidp}),
                            );

                            if (response.statusCode == 200) {
                              Map<String, dynamic>? responseData =
                                  json.decode(response.body);
                              String? message = responseData?['message'];
                              if (message != null) {
                                Fluttertoast.showToast(
                                  msg: message,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                newPasswordController.clear();
                                reenterPasswordController.clear();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage(ipAddress: widget.ipAddress)));
                              } else {
                                // Handle unexpected response from the server
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Failed to update password',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          }
                        },
                        child: Text('Reset Password'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
