import 'package:flutter/material.dart';
import 'package:flutter_project/pages/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(ProfileApp());
// }

class profile {
  final String fname;
  final String lname;
  final String housename;
  final int pincode;
  final String gender;
  final String place;
  final String email;
  final int phone;

  profile(
      {required this.fname,
      required this.lname,
      required this.housename,
      required this.pincode,
      required this.gender,
      required this.place,
      required this.email,
      required this.phone});
}

// class ProfileApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProfilePage(),
//     );
//   }
// }

class ProfilePage extends StatefulWidget {
  final String ipAddress;
  ProfilePage({required this.ipAddress});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<profile> reviewList = [];

  String firstname = 'Loading...';
  String lastname = 'Loading...';
  String housename = 'Loading...';
  String pincode = 'Loading...';
  String gender = 'Loading...';
  String location = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    stfpro();
  }

  Future<void> stfpro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');
    final String url = 'http://${widget.ipAddress}/stpro?authToken=$authToken';
    final Map<String, String> requestBody = {
      'authToken': authToken!,
    };
    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);

        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final data = jsonData["result"];
          setState(() {
            firstname = data[0]['first_name']?.toString() ?? 'N/A';
            lastname = data[0]['last_name']?.toString() ?? 'N/A';
            housename = data[0]['house_name']?.toString() ?? 'N/A';
            pincode = data[0]['pincode'].toString();
            gender = data[0]['gender']?.toString() ?? 'N/A';
            location = data[0]['place']?.toString() ?? 'N/A';
            email = data[0]['email']?.toString() ?? 'N/A';
            phone = data[0]['phone'].toString();
          });
        } else {
          setState(() {
            errorMessage = 'No Profile found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing booked events';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Colors.purple,
        title: Text('Profile'),
         actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
               showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout",style: TextStyle(fontFamily: 'Cera Pro'),),
                      content: const Text("Are you sure want to logout?",style: TextStyle(fontFamily: 'Cera Pro'),),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(ipAddress: widget.ipAddress),
                                  ));
                            },
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))
                      ],
                    );
                  },
                );
             
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
          ),
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: Container(
                child: Icon(
                  Icons.account_circle,
                  size: 200,
                  color: Colors.grey[800],
                ),             
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("First Name",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(firstname,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
                 Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 20,
              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Last Name",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(lastname,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
                Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 20,
              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("House Name",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(housename,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
                Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pin Code",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(pincode,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
                Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 20,
              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Email",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(email,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
                Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 20,
              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Phone",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(phone,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
                Divider(
                color: Colors.purple.withOpacity(0.5),
                height: 20,
              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Location",style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),),
                    Text(location,style: TextStyle(fontSize: 17,fontFamily: 'Cera Pro'),)
                  ],
                ),
               
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
// Widget _buildDoubleShadedCard(Widget child) {
//   return Card(
//     elevation: 10, 
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10.0),
//     ),
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color.fromARGB(255, 7, 253, 249),
//             Color.fromARGB(255, 243, 121, 33),
//           ],
//         ),
//       ),
//       child: child,
//     ),
//   );
// }
}