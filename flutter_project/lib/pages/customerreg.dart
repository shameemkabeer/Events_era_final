import 'package:flutter/material.dart';
import 'package:flutter_project/pages/login.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
// import 'package:flutter_application_1/home.dart';
// import 'package:flutter_application_1/customlogin.dart';

class RegisterPage extends StatefulWidget {
  final String ipAddress;

  RegisterPage({required this.ipAddress});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController usertypeController = TextEditingController();

  // TextEditingController bookingDateController = TextEditingController();
  // TextEditingController bookingTimeController = TextEditingController();
  // TextEditingController bookingVenueController = TextEditingController();
  // TextEditingController numberOfPersonsController = TextEditingController();

  String _selectedGender = '';
  var formkey = GlobalKey<FormState>();

  bool _validateEmail(String email) {
    // Regular expression for basic email validation
    String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  void _register() async {
    final String serverUrl = 'http://${widget.ipAddress}/customreginser';

    // Prepare the data to send in the POST request
    Map<String, dynamic> data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'gender': _selectedGender,
      'house_name': houseNameController.text,
      'place': placeController.text,
      'pincode': pincodeController.text,
      'email': emailController.text,
      'phone': phoneNumberController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http.post(Uri.parse(serverUrl), body: data);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Registration successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        firstNameController.clear();
        lastNameController.clear();
        houseNameController.clear();
        placeController.clear();
        pincodeController.clear();
        emailController.clear();
        phoneNumberController.clear();
        passwordController.clear();

        setState(() {
          _selectedGender = ''; // Reset gender selection
        });
      } else {
        Fluttertoast.showToast(
          msg: "Registration failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      // Handle any network or other errors
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Center(
                      child: Text(
                        "𝓡𝓮𝓰𝓲𝓼𝓽𝓮𝓻",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Cera Pro',
                          fontSize: 50,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold, // Add bold for emphasis
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Register Now ",
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        controller: firstNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: Pallete.blackColor,
                          ),
                          labelText: "First Name",
                          labelStyle: TextStyle(color: Pallete.blackColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        controller: lastNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.person_2_rounded,
                            color: Pallete.blackColor,
                          ),
                          labelText: "Last Name",
                          labelStyle: TextStyle(color: Pallete.blackColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                  fontSize: 15, color: Pallete.blackColor),
                            ),
                          ),
                          Radio(
                            value: 'Male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          Text(
                            'Male',
                            style: TextStyle(color: Pallete.blackColor),
                          ),
                          Radio(
                            value: 'Female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          Text(
                            'Female',
                            style: TextStyle(color: Pallete.blackColor),
                          ),
                          Radio(
                            value: 'Others',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          Text('Others',
                              style: TextStyle(color: Pallete.blackColor)),
                        ],
                      ),
                    ),
                    Text(
                      _selectedGender.isEmpty ? 'Please select a gender' : '',
                      style: TextStyle(color: Pallete.AppTheme),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        controller: houseNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.house_sharp,
                            color: Pallete.blackColor,
                          ),
                          labelText: "House Name",
                          labelStyle: TextStyle(color: Pallete.blackColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your house name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        controller: placeController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.place_sharp,
                            color: Pallete.blackColor,
                          ),
                          labelText: "Place",
                          labelStyle: TextStyle(color: Pallete.blackColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your place';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        controller: pincodeController,
                        maxLength: 6,
                        
                        keyboardType: TextInputType.number,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: Pallete.blackColor,
                          ),
                          labelText: "Pincode",
                          
                          labelStyle: TextStyle(color: Pallete.blackColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your pincode';
                          }
                          // Regular expression for basic phone number validation
                          String pattern = r'^[0-9]{6}$';
                          RegExp regExp = RegExp(pattern);
                          if (!regExp.hasMatch(value)) {
                            return 'Please enter a valid 6-digit pincode';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        controller: phoneNumberController,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.phone_android_sharp,
                            color: Pallete.blackColor,
                          ),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(color: Pallete.blackColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          // Regular expression for basic phone number validation
                          String pattern = r'^[0-9]{10}$';
                          RegExp regExp = RegExp(pattern);
                          if (!regExp.hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: TextInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Pallete.blackColor,
                            ),
                            
                            labelText: "Email",
                            labelStyle: TextStyle(color: Pallete.blackColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !_validateEmail(value)) {
                              return 'Please Enter a valid Email';
                            }
                            return null;
                          }),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                          obscureText: _obscureText,
                          controller: passwordController,
                          maxLength: 8,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: TextInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.fingerprint_sharp,
                              color: Pallete.blackColor,
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(color: Pallete.blackColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
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
                                color: Pallete.blackColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      width: 345,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18))),
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            if (!_validateEmail(emailController.text)) {
                              Fluttertoast.showToast(
                                msg: "Enter a valid email address.",
                              );
                              return;
                              // Don't proceed with registration if email is invalid.
                            } else
                              _register();

                            String email = emailController.text;
                            String password = passwordController.text;
                            String usertype = usertypeController.text;

                            if (email == 'admin@gmail.com' &&
                                password == 'admin123') {
                              usertype = 'Admin';
                            } else {
                              usertype = 'Customer';
                            }
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text.rich(TextSpan(
                        text: "Already have an account account?",
                        style: TextStyle(
                            color: Pallete.blackColor,
                            fontSize: 14,
                            fontFamily: 'Cera Pro'),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                  color: Pallete.blackColor,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context,
                                      LoginPage(ipAddress: widget.ipAddress));
                                })
                        ])),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// // import 'package:flutter_application_1/home.dart';
// // import 'package:flutter_application_1/customlogin.dart';

// class RegisterPage extends StatefulWidget {
//   final String ipAddress;

//   RegisterPage({required this.ipAddress});
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   bool _obscureText = true;
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController pincodeController = TextEditingController();
//   TextEditingController houseNameController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController usertypeController = TextEditingController();

//   // TextEditingController bookingDateController = TextEditingController();
//   // TextEditingController bookingTimeController = TextEditingController();
//   // TextEditingController bookingVenueController = TextEditingController();
//   // TextEditingController numberOfPersonsController = TextEditingController();

//   String _selectedGender = '';
//   var formkey = GlobalKey<FormState>();

//   bool _validateEmail(String email) {
//     // Regular expression for basic email validation
//     String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
//     RegExp regExp = RegExp(pattern);
//     return regExp.hasMatch(email);
//   }

//   void _register() async {

//     final String serverUrl = 'http://${widget.ipAddress}/customreginser';

//     // Prepare the data to send in the POST request
//     Map<String, dynamic> data = {
//       'first_name': firstNameController.text,
//       'last_name': lastNameController.text,
//       'gender': _selectedGender,
//       'house_name': houseNameController.text,
//       'place': placeController.text,
//       'pincode': pincodeController.text,
//       'email': emailController.text,
//       'phone': phoneNumberController.text,
//       'password': passwordController.text,
//     };

//     try {
//       final response = await http.post(Uri.parse(serverUrl), body: data);

//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: "Registration successful",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,   
//         );
     

//         firstNameController.clear();
//         lastNameController.clear(); 
//         houseNameController.clear(); 
//         placeController.clear();
//         pincodeController.clear();
//         emailController.clear();
//         phoneNumberController.clear();
//         passwordController.clear();

//         setState(() {
//           _selectedGender = ''; // Reset gender selection
//         });
//       } else {
//         Fluttertoast.showToast(
//           msg: "Registration failed",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         ); 
//       }
//     } catch (e) { 
//       // Handle any network or other errors
//       Fluttertoast.showToast(
//         msg: "Error: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(   
//         backgroundColor: Color.fromARGB(255, 185, 132, 187),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//             gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//         colors: [
//     Color.fromARGB(255, 185, 132, 187), // First shade color
//           Color.fromARGB(255, 173, 35, 146),  // Second shade color
//         ],
//         stops: [0.15, 1.5], // Adjust the stops as needed
//       ),
//     ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(25),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//                 child: Container(
//                   height: 645,
//                   width: 300,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomCenter,
//                       colors: [Color.fromARGB(153, 203, 195, 195), Colors.white10],
//                     ),
//                     borderRadius: BorderRadius.circular(25),
//                     border: Border.all(width: 2, color: Colors.white30),
//                   ),
//                   child: Center(
//                     child: Form(
//                       key: formkey,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                              Center(
//                 child: Text(
//                   "Register",
//                   style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontFamily: 'calligraphy',
//                     fontSize: 60,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold, // Add bold for emphasis
//                   ),
//                 ),
//               ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                 controller: firstNameController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   prefix: Icon(Icons.person_2_outlined),
//                                   labelText: "First Name",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your first name';
//                                   }
//                                   return null;
//                                 }, 
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                 controller: lastNameController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                     prefix: Icon(Icons.person_2_rounded),
//                                   labelText: "Last Name",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your last name';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Text(
//                                       'Gender',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                   ),
//                                   Radio(
//                                     value: 'Male',
//                                     groupValue: _selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedGender = value!;
//                                       });
//                                     },
//                                   ),
//                                   Text('Male'),
//                                   Radio(
//                                     value: 'Female',
//                                     groupValue: _selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedGender = value!;
//                                       });
//                                     },
//                                   ),
//                                   Text('Female'),
//                                   Radio(
//                                     value: 'Others',
//                                     groupValue: _selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedGender = value!;
//                                       });
//                                     },
//                                   ),
//                                   Text('Others'),
//                                 ],
//                               ),
//                             ),
//                             Text(
//                               _selectedGender.isEmpty
//                                   ? 'Please select a gender'
//                                   : '',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                 controller: houseNameController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                     prefix: Icon(Icons.house_sharp),
//                                   labelText: "House Name",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your house name';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                 controller: placeController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                     prefix: Icon(Icons.place_sharp),
//                                   labelText: "Place",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your place';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                 controller: pincodeController,
//                                 maxLength: 6,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 decoration: InputDecoration(
//                                     prefix: Icon(Icons.numbers
//                                     ),
//                                   labelText: "Pincode",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your pincode';
//                                   }
//                                   // Regular expression for basic phone number validation
//                                   String pattern = r'^[0-9]{6}$';
//                                   RegExp regExp = RegExp(pattern);
//                                   if (!regExp.hasMatch(value)) {
//                                     return 'Please enter a valid 6-digit pincode';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                 controller: phoneNumberController,
//                                 maxLength: 10,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 decoration: InputDecoration(
//                                     prefix: Icon(Icons.phone_android_sharp),
//                                   labelText: "Phone Number",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter a phone number';
//                                   }
//                                   // Regular expression for basic phone number validation
//                                   String pattern = r'^[0-9]{10}$';
//                                   RegExp regExp = RegExp(pattern);
//                                   if (!regExp.hasMatch(value)) {
//                                     return 'Please enter a valid 10-digit phone number';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                   controller: emailController,
//                                   decoration: InputDecoration(
//                                       prefix: Icon(Icons.email),
//                                     labelText: "Email",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null ||
//                                         value.isEmpty ||
//                                         !_validateEmail(value)) {
//                                       return 'Enter a valid Email';
//                                     }
//                                     return null;
//                                   }),
//                             ),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                               width: 300,
//                               child: TextFormField(
//                                   obscureText: _obscureText,
//                                   controller: passwordController,
//                                   maxLength: 8,
//                                   keyboardType: TextInputType.visiblePassword,
//                                   decoration: InputDecoration(
//                                       prefix: Icon(Icons.fingerprint_sharp),
//                                     labelText: "Password",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                     suffixIcon: IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           _obscureText = !_obscureText;
//                                         });
//                                       },
//                                       icon: Icon(
//                                         _obscureText  
//                                             ? Icons.visibility_off
//                                             : Icons.visibility,
                                         
//                                       ),
//                                     ),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please enter a password';
//                                     } else if (value.length < 8) {
//                                       return 'Password must be at least 8 characters long';
//                                     }
//                                     return null;
//                                   }),
//                             ),
//                             Padding(padding: EdgeInsets.all(8)),
//                             Container(
//                               child: ClipRRect(
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                     shape: MaterialStateProperty.all(
//                                       RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                     ),
//                                     padding: MaterialStateProperty.all(
//                                       EdgeInsets.symmetric(
//                                         vertical: 15,
//                                         horizontal: 80,
//                                       ),
//                                     ),
//                                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(241, 244, 246, 249)),
//                                   ),
//                                   onPressed: () async {
//                                     if (formkey.currentState!.validate()) {
//                                       if (!_validateEmail(
//                                           emailController.text)) {
//                                         Fluttertoast.showToast(
//                                           msg: "Enter a valid email address.",
//                                         );
//                                         return;
//                                         // Don't proceed with registration if email is invalid.
//                                       } else
//                                         _register();

//                                       String email = emailController.text;
//                                       String password = passwordController.text;
//                                       String usertype = usertypeController.text;

//                                       if (email == 'admin@gmail.com' &&
//                                           password == 'admin123') {
//                                         usertype = 'Admin';
//                                       } else {
//                                         usertype = 'Customer';
//                                       }
//                                     }
//                                   },
//                                   child: Text(
//                                     "Register",
//                                     style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
//                                   ),
//                                 ),
//                               ),
//                               padding: EdgeInsets.all(8),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

