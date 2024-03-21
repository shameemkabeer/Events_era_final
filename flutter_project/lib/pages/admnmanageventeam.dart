import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'admnviewteam.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Eventeamanage extends StatefulWidget {
  final String ipAddress;

  Eventeamanage({required this.ipAddress});

  @override
  _EventeamanageState createState() => _EventeamanageState();
}

class _EventeamanageState extends State<Eventeamanage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedGender;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Event Team Management',
          style: TextStyle(color: Pallete.whiteColor),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 645,
            width: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.white60, Colors.white10],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: Colors.white30),
            ),
            child: Center(
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: firstNameController,
                        decoration: TextInputDecoration.copyWith(
                            labelText: 'First Name'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: lastNameController,
                        decoration: TextInputDecoration.copyWith(
                            labelText: 'Last Name'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        title: Text('Gender'),
                        contentPadding: EdgeInsets
                            .zero, // Remove padding to prevent width issues
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile<String>(
                              title: Text('Male'),
                              value: 'Male',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Female'),
                              value: 'Female',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Other'),
                              value: 'Other',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: houseNameController,
                        decoration: TextInputDecoration.copyWith(
                            labelText: 'House Name'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: placeController,
                        decoration:
                            TextInputDecoration.copyWith(labelText: 'Place'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        controller: pincodeController,
                        decoration:
                            TextInputDecoration.copyWith(labelText: 'Pincode'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration:
                            TextInputDecoration.copyWith(labelText: 'Email'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        decoration: TextInputDecoration.copyWith(
                            labelText: 'Phone Number'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        decoration:
                            TextInputDecoration.copyWith(labelText: 'Password'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top:
                                10.0), // Adjust the top value to control the spacing
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly, // Adjust alignment as needed
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                _addEventTeamMember();
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    fontFamily: 'Cera Pro',
                                    color: Pallete.whiteColor),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Eventeamview(
                                            ipAddress: widget.ipAddress,
                                          )),
                                );
                              },
                              child: Text(
                                'View',
                                style: TextStyle(
                                    fontFamily: 'Cera Pro',
                                    color: Pallete.whiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addEventTeamMember() async {
    final String url = 'http://${widget.ipAddress}/addeventteam';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');

    final Map<String, String> requestBody = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'gender': selectedGender ?? '',
      'house_name': houseNameController.text,
      'place': placeController.text,
      'pincode': pincodeController.text,
      'email': emailController.text,
      'phone': phoneNumberController.text,
      'password': passwordController.text,
      'authToken': authToken.toString(),
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('staffid')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? staffID = prefs.getString('staffid');
          print(staffID);

          print('Event team member added successfully.Staff ID: $staffID');
          firstNameController.clear();
          lastNameController.clear();
          houseNameController.clear();
          placeController.clear();
          pincodeController.clear();
          emailController.clear();
          phoneNumberController.clear();
          passwordController.clear();
          setState(() {
            _errorMessage = null;
            selectedGender = null;
          });
        }
        Fluttertoast.showToast(
          msg: 'Added An Event Team Member',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print('Error adding event team member: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error adding event team member';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:ui';
// import 'admnviewteam.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class Eventeamanage extends StatefulWidget {
//   final String ipAddress;

//   Eventeamanage({required this.ipAddress});

//   @override
//   _EventeamanageState createState() => _EventeamanageState();
// }

// class _EventeamanageState extends State<Eventeamanage> {
//   final GlobalKey<FormState> formkey = GlobalKey<FormState>();

//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController houseNameController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController pincodeController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   String? selectedGender;
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Event Team Management',
//           style: TextStyle(color: Color.fromARGB(255, 9, 9, 8)),
//         ),
//         backgroundColor: Color.fromARGB(255, 185, 132, 187),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromARGB(255, 252, 146, 245), Color.fromARGB(255, 107, 19, 125)
//                 ],
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(25),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                 child: Container(
//                   height: 645,
//                   width: 300,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomCenter,
//                       colors: [Colors.white60, Colors.white10],
//                     ),
//                     borderRadius: BorderRadius.circular(25),
//                     border: Border.all(width: 2, color: Colors.white30),
//                   ),
//                   child: Center(
//                     child: Form(
//                       key: formkey,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextFormField(
//                               keyboardType: TextInputType.name,
//                               controller: firstNameController,
//                               decoration:
//                                   InputDecoration(labelText: 'First Name'),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.name,
//                               controller: lastNameController,
//                               decoration:
//                                   InputDecoration(labelText: 'Last Name'),
//                             ),
//                             ListTile(
//                               title: Text('Gender'),
//                               contentPadding: EdgeInsets
//                                   .zero, // Remove padding to prevent width issues
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   RadioListTile<String>(
//                                     title: Text('Male'),
//                                     value: 'Male',
//                                     groupValue: selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedGender = value;
//                                       });
//                                     },
//                                   ),
//                                   RadioListTile<String>(
//                                     title: Text('Female'),
//                                     value: 'Female',
//                                     groupValue: selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedGender = value;
//                                       });
//                                     },
//                                   ),
//                                   RadioListTile<String>(
//                                     title: Text('Other'),
//                                     value: 'Other',
//                                     groupValue: selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedGender = value;
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.streetAddress,
//                               controller: houseNameController,
//                               decoration:
//                                   InputDecoration(labelText: 'House Name'),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.text,
//                               controller: placeController,
//                               decoration: InputDecoration(labelText: 'Place'),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: pincodeController,
//                               decoration: InputDecoration(labelText: 'Pincode'),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.emailAddress,
//                               controller: emailController,
//                               decoration: InputDecoration(labelText: 'Email'),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.phone,
//                               controller: phoneNumberController,
//                               decoration:
//                                   InputDecoration(labelText: 'Phone Number'),
//                             ),
//                             TextFormField(
//                               keyboardType: TextInputType.visiblePassword,
//                               controller: passwordController,
//                               decoration:
//                                   InputDecoration(labelText: 'Password'),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   top:
//                                       10.0), // Adjust the top value to control the spacing
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment
//                                     .spaceEvenly, // Adjust alignment as needed
//                                 children: [
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Color.fromARGB(255, 238, 241, 244),
//                                     ),
//                                     onPressed: () {
//                                       _addEventTeamMember();
//                                     },
//                                     child: Text(
//                                       'Add',
//                                       style: TextStyle(
//                                           color: Color.fromARGB(255, 0, 0, 0)),
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Color.fromARGB(255, 228, 231, 233),
//                                     ),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => Eventeamview(
//                                                   ipAddress: widget.ipAddress,
//                                                 )),
//                                       );
//                                     },
//                                     child: Text(
//                                       'View',
//                                       style: TextStyle(
//                                           color: Color.fromARGB(255, 0, 0, 0)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (_errorMessage != null)
//                               Text(
//                                 _errorMessage!,
//                                 style: TextStyle(color: Colors.red),
//                               ),
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

//   Future<void> _addEventTeamMember() async {
//     final String url = 'http://${widget.ipAddress}/addeventteam';
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString('lid');

//     final Map<String, String> requestBody = {
//       'first_name': firstNameController.text,
//       'last_name': lastNameController.text,
//       'gender': selectedGender ?? '',
//       'house_name': houseNameController.text,
//       'place': placeController.text,
//       'pincode': pincodeController.text,
//       'email': emailController.text,
//       'phone': phoneNumberController.text,
//       'password': passwordController.text,
//       'authToken': authToken.toString(),
//     };

//     try {
//       final response = await http.post(Uri.parse(url), body: requestBody);

//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(response.body);
//         if (responseData.containsKey('staffid')) {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           String? staffID = prefs.getString('staffid');
//           print(staffID);

//           print('Event team member added successfully.Staff ID: $staffID');
//           firstNameController.clear();
//           lastNameController.clear();
//           houseNameController.clear();
//           placeController.clear();
//           pincodeController.clear();
//           emailController.clear();
//           phoneNumberController.clear();
//           passwordController.clear();
//           setState(() {
//             _errorMessage = null;
//             selectedGender = null;
//           });
//         }
//       } else {
//         print('Error adding event team member: ${response.statusCode}');
//         setState(() {
//           _errorMessage = 'Error adding event team member';
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         _errorMessage = 'An error occurred';
//       });
//     }
//   }

//   bool _isValidEmail(String email) {
//     final RegExp emailRegex = RegExp(
//       r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
//       caseSensitive: false,
//     );
//     return emailRegex.hasMatch(email);
//   }
// }
