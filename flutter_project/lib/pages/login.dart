import 'package:flutter/material.dart';
import 'package:flutter_project/pages/customerreg.dart';
import 'package:flutter_project/pages/reset.dart';
import 'package:flutter_project/pages/customerhome.dart';
import 'package:flutter_project/pages/staaffhome.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/pages/adminhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  final String ipAddress;

  LoginPage({required this.ipAddress});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController loginusernameController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  //   late BuildContext _context;

  // @override
  // void initState() {
  //   super.initState();
  //     _context = context;
  //   checkIfAlreadyLoggedIn();
  // }

  // Future<void> checkIfAlreadyLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? lid = prefs.getString('lid');

  //   if (lid != null) {
  //     // User is already logged in
  //     String? userType = prefs.getString('usertype');
  //     redirectToHomePage(userType);
  //   }
  // }

  // void redirectToHomePage(String? userType) {
  //   if (userType == 'admin') {
  //     Navigator.pushReplacement(
  //       _context, // Use the stored context instead of context
  //       MaterialPageRoute(builder: (context) => admhome()),
  //     );
  //   } else if (userType == 'customer') {
  //     Navigator.pushReplacement(
  //       _context, // Use the stored context instead of context
  //       MaterialPageRoute(builder: (context) => cushome()),
  //     );
  //   } else if (userType == 'staff') {
  //     Navigator.pushReplacement(
  //       _context, // Use the stored context instead of context
  //       MaterialPageRoute(builder: (context) => staffhome()),
  //     );
  //   }
  // }

  bool _validateEmail(String Username) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(Username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.only(top: 80)),
                Center(
                  child: const Text(
                    "𝐿𝑜𝑔𝒾𝓃",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cera Pro',
                        fontStyle: FontStyle.italic,
                        color: Colors.purple),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: const Text(
                    "Sign in to continue",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cera Pro',
                        color: Pallete.blackColor),
                  ),
                ),
                SizedBox(
                  height: 230,
                ),
                SizedBox(
                  width: 320,
                  child: TextFormField(
                      controller: loginusernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: TextInputDecoration.copyWith(
                        prefixIcon: Icon(
                          Icons.person_3_rounded,
                          color: Pallete.blackColor,
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Pallete
                              .blackColor, // Set the color of the label text
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !_validateEmail(value)) {
                          return 'Enter a valid Email';
                        }
                        return null;
                      }),
                ),
                SizedBox(
                  height: 8,
                ),
                // Padding(padding: EdgeInsets.all(20)),
                Center(
                  child: SizedBox(
                    width: 320,
                    child: TextFormField(
                        obscureText: _obscureText,
                        controller: loginpasswordController,
                        maxLength: 8,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: TextInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.fingerprint_sharp,
                            color: Pallete.blackColor,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Pallete
                                .blackColor, // Set the color of the label text
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: IconButton(
                            color: Pallete.blackColor,
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
                            return 'Please enter a password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        }),
                  ),
                ),
                Center(
                  child: Container(
                    child: SizedBox(
                      width: 345,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              backgroundColor: Colors.purple),
                          onPressed: () async {
                            String enteredUsername =
                                loginusernameController.text;
                            String enteredPassword =
                                loginpasswordController.text;
                            final response = await http.post(
                              Uri.parse('http://${widget.ipAddress}/login'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'username': enteredUsername,
                                'password': enteredPassword,
                              }),
                            );

                            if (response.statusCode == 200) {
                              Map<String, dynamic> responseData =
                                  json.decode(response.body);
                              String? userType = responseData['usertype'];
                              String lid = responseData['lid'].toString();
                              Fluttertoast.showToast(
                                msg: userType ?? 'No userType',
                              );
                              // Storing data
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('lid', lid);

                              if (userType == 'admin') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => admhome()),
                                );
                              } else if (userType == 'customer') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => cushome()),
                                );
                              } else if (userType == 'staff') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => staffhome()),
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Invalid Username or Password',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white),
                          )),
                    ),
                    // padding: EdgeInsets.all(20),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(
                          ipAddress: widget.ipAddress,
                          lidpass: '',
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Pallete.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                        color: Pallete.blackColor,
                        fontSize: 15,
                        fontFamily: 'Cera Pro'),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register now",
                          style: TextStyle(
                              fontFamily: 'Cera Pro',
                              color: Pallete.blackColor,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context,
                                  RegisterPage(ipAddress: widget.ipAddress));
                            })
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final String ipAddress;
  final String lidpass;
  ResetPasswordScreen({required this.ipAddress, required this.lidpass});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/image/forget_password.png")),
                // Icon(Icons.lock_sharp,
                //     size: 160, color: Color.fromARGB(255, 139, 135, 134)),
                // SizedBox(height: 30, width: 30),
                Text(
                  "Forgot Your Password?",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Pallete.AppTheme),
                ),
                SizedBox(width: 10, height: 15),
                Text("Enter Your Details Below To Reset Your Password",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 13,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: usernameController,
                  decoration: TextInputDecoration.copyWith(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.black87)),
                ),
                SizedBox(width: 10, height: 20),
                TextField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: mobileController,
                  decoration: TextInputDecoration.copyWith(
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixText: "+91",
                      prefixStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      backgroundColor: Colors.purple),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetScreen(
                              lidpass: widget.lidpass,
                              ipAddress: widget.ipAddress),
                        ));

                    //###DATABASE FUNCTION ###///

                    String enteredUsername = usernameController.text;
                    String enteredphone = mobileController.text;

                    final response = await http.post(
                      Uri.parse('http://${widget.ipAddress}/forgot'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(
                          {'forgot': enteredUsername, 'mob': enteredphone}),
                    );

                    if (response.statusCode == 200) {
                      Map<String, dynamic>? responseData =
                          json.decode(response.body);
                      String? message = responseData?['bb'];
                      String? redirect = responseData?['redirect'];

                      if (message != null) {
                        Fluttertoast.showToast(
                          msg: message,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );

                        if (redirect != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetScreen(
                                  ipAddress: widget.ipAddress,
                                  lidpass: message),
                            ),
                          );
                        }
                      } else {
                        // Handle unexpected response from the server
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Invalid Username Or Mobile Number',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:flutter_project/pages/reset.dart';
// import 'package:flutter_project/pages/customerhome.dart';
// import 'package:flutter_project/pages/staaffhome.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_project/pages/adminhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   final String ipAddress;

//   LoginPage({required this.ipAddress});
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _obscureText = true;
//   TextEditingController loginusernameController = TextEditingController();
//   TextEditingController loginpasswordController = TextEditingController();

//   var formkey = GlobalKey<FormState>();

//   //   late BuildContext _context;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //     _context = context;
//   //   checkIfAlreadyLoggedIn();
//   // }

//   // Future<void> checkIfAlreadyLoggedIn() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? lid = prefs.getString('lid');

//   //   if (lid != null) {
//   //     // User is already logged in
//   //     String? userType = prefs.getString('usertype');
//   //     redirectToHomePage(userType);
//   //   }
//   // }

//   // void redirectToHomePage(String? userType) {
//   //   if (userType == 'admin') {
//   //     Navigator.pushReplacement(
//   //       _context, // Use the stored context instead of context
//   //       MaterialPageRoute(builder: (context) => admhome()),
//   //     );
//   //   } else if (userType == 'customer') {
//   //     Navigator.pushReplacement(
//   //       _context, // Use the stored context instead of context
//   //       MaterialPageRoute(builder: (context) => cushome()),
//   //     );
//   //   } else if (userType == 'staff') {
//   //     Navigator.pushReplacement(
//   //       _context, // Use the stored context instead of context
//   //       MaterialPageRoute(builder: (context) => staffhome()),
//   //     );
//   //   }
//   // }

//   bool _validateEmail(String Username) {
//     String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
//     RegExp regExp = RegExp(pattern);
//     return regExp.hasMatch(Username);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 185, 132, 187),
//       ),
//       body: Container(
//         height: 650,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 185, 132, 187), // First shade color
//               Color.fromARGB(227, 130, 23, 128), // Second shade color
//             ],
//             stops: [0.15, 1.0], // Adjust the stops as needed
//           ),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: formkey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Center(
//                         child: Text(
//                           "Login",
//                           style: TextStyle(
//                             fontStyle: FontStyle.italic,
//                             fontFamily: 'calligraphy',
//                             fontSize: 80,
//                             color: Colors.white,
//                             fontWeight:
//                                 FontWeight.bold, // Add bold for emphasis
//                           ),
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.all(35)),
//                       Center(
//                         child: Container(
//                           width: 300,
//                           child: TextFormField(
//                               controller: loginusernameController,
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(Icons.person_3_rounded),
//                                 labelText: "Username",
//                                 labelStyle: TextStyle(
//                                   color: Colors
//                                       .white, // Set the color of the label text
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null ||
//                                     value.isEmpty ||
//                                     !_validateEmail(value)) {
//                                   return 'Enter a valid Email';
//                                 }
//                                 return null;
//                               }),
//                         ),
//                       ),
//                       Padding(padding: EdgeInsets.all(20)),
//                       Center(
//                         child: Container(
//                           width: 300,
//                           child: TextFormField(
//                               obscureText: _obscureText,
//                               controller: loginpasswordController,
//                               maxLength: 8,
//                               keyboardType: TextInputType.visiblePassword,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(Icons.fingerprint_sharp),
//                                 labelText: "Password",
//                                 labelStyle: TextStyle(
//                                   color: Colors
//                                       .white, // Set the color of the label text
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 suffixIcon: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _obscureText = !_obscureText;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     _obscureText
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                   ),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a password';
//                                 } else if (value.length < 8) {
//                                   return 'Password must be at least 8 characters long';
//                                 }
//                                 return null;
//                               }),
//                         ),
//                       ),
//                       Center(
//                         child: Container(
//                           child: ClipRRect(
//                             child: ElevatedButton(
//                                 style: ButtonStyle(
//                                   shape: MaterialStateProperty.all(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                   padding: MaterialStateProperty.all(
//                                     EdgeInsets.symmetric(
//                                         vertical: 20, horizontal: 110),
//                                   ),
//                                   backgroundColor: MaterialStatePropertyAll(
//                                       Color.fromARGB(211, 251, 253, 255)),
//                                 ),
//                                 onPressed: () async {
//                                   String enteredUsername =
//                                       loginusernameController.text;
//                                   String enteredPassword =
//                                       loginpasswordController.text;

//                                   // Uri url = Uri.parse('http://${widget.ipAddress}/login');
//                                   // print('Constructed URL: $url');
//                                   // final response = await http.post(
//                                   //   url,
//                                   //   headers: {'Content-Type': 'application/json'},
//                                   //   body: jsonEncode({
//                                   //     'username': enteredUsername,
//                                   //     'password': enteredPassword,
//                                   //   }),
//                                   // );

//                                   final response = await http.post(
//                                     Uri.parse(
//                                         'http://${widget.ipAddress}/login'),
//                                     headers: {
//                                       'Content-Type': 'application/json'
//                                     },
//                                     body: jsonEncode({
//                                       'username': enteredUsername,
//                                       'password': enteredPassword,
//                                     }),
//                                   );

//                                   if (response.statusCode == 200) {
//                                     Map<String, dynamic> responseData =
//                                         json.decode(response.body);
//                                     String? userType = responseData['usertype'];
//                                     String lid = responseData['lid'].toString();
//                                     Fluttertoast.showToast(
//                                       msg: userType ?? 'No userType',
//                                     );
//                                     // Storing data
//                                     SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                     prefs.setString('lid', lid);

//                                     if (userType == 'admin') {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => admhome()),
//                                       );
//                                     } else if (userType == 'customer') {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => cushome()),
//                                       );
//                                     } else if (userType == 'staff') {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => staffhome()),
//                                       );
//                                     }
//                                   } else {
//                                     Fluttertoast.showToast(
//                                       msg: 'Invalid Username or Password',
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.BOTTOM,
//                                     );
//                                   }
//                                 },
//                                 child: Text(
//                                   "Login",
//                                   style: TextStyle(
//                                       color:
//                                           const Color.fromARGB(255, 0, 0, 0)),
//                                 )),
//                           ),
//                           padding: EdgeInsets.all(20),
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ResetPasswordScreen(
//                                 ipAddress: widget.ipAddress,
//                                 lidpass: '',
//                               ),
//                             ),
//                           );
//                         },
//                         child: Center(
//                           child: Text(
//                             'Forgot Password?',
//                             style: TextStyle(
//                               color: const Color.fromARGB(255, 255, 254, 254),
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
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

// class ResetPasswordScreen extends StatefulWidget {
//   final String ipAddress;
//   final String lidpass;
//   ResetPasswordScreen({required this.ipAddress, required this.lidpass});

//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forgot Password'),
//         backgroundColor: Color.fromRGBO(199, 140, 201, 1),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(70.0),
//         child: SingleChildScrollView(
//           child: Center(
//             child: Container(
//               width: 260,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.lock_sharp,
//                       size: 120, color: Color.fromARGB(255, 139, 135, 134)),
//                   SizedBox(height: 30, width: 30),
//                   Text(
//                     "Forgot Your Password?",
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 216, 108, 246)),
//                   ),
//                   SizedBox(width: 10, height: 20),
//                   Text("Enter Your Details Below To Reset Your Password",
//                       style:
//                           TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                   Container(
//                     width: 300,
//                     child: TextField(
//                       controller: usernameController,
//                       decoration: InputDecoration(
//                         labelText: 'Username',
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10, height: 20),
//                   Container(
//                     width: 300,
//                     child: TextField(
//                       controller: mobileController,
//                       decoration: InputDecoration(
//                         labelText: 'Mobile Number',
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () async {
//                       String enteredUsername = usernameController.text;
//                       String enteredphone = mobileController.text;

//                       final response = await http.post(
//                         Uri.parse('http://${widget.ipAddress}/forgot'),
//                         headers: {'Content-Type': 'application/json'},
//                         body: jsonEncode(
//                             {'forgot': enteredUsername, 'mob': enteredphone}),
//                       );

//                       if (response.statusCode == 200) {
//                         Map<String, dynamic>? responseData =
//                             json.decode(response.body);
//                         String? message = responseData?['bb'];
//                         String? redirect = responseData?['redirect'];

//                         if (message != null) {
//                           Fluttertoast.showToast(
//                             msg: message,
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                           );

//                           if (redirect != null) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ResetScreen(
//                                     ipAddress: widget.ipAddress,
//                                     lidpass: message),
//                               ),
//                             );
//                           }
//                         } else {
//                           // Handle unexpected response from the server
//                         }
//                       } else {
//                         Fluttertoast.showToast(
//                           msg: 'Invalid Username Or Mobile Number',
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                         );
//                       }
//                     },
//                     child: Text('Next'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
