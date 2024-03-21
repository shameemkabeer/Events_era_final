// import 'package:flutter/material.dart';
// import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';

// class review {
//   final String id;
//   final String cusid;
//   final String feedback;
//   final String feedbackdate;

//   review(
//       {required this.id,
//       required this.cusid,
//       required this.feedback,
//       required this.feedbackdate});
// }

// class EmojiRatingPage extends StatefulWidget {
//   final String ipAddress;
//   EmojiRatingPage({required this.ipAddress});
//   @override
//   _EmojiRatingPageState createState() => _EmojiRatingPageState();
// }

// class _EmojiRatingPageState extends State<EmojiRatingPage> {
//   List<review> reviewsList = [];
//   int currentRating = 0; // Initialize with a default rating
//   TextEditingController feedbackController = TextEditingController();
//   String? errorMessage;

//   Future<void> sendFeedback() async {
//     final String url = 'http://${widget.ipAddress}/sendreviews';

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString('lid');

//     final Map<String, String> requestBody = {
//       'feedbac': feedbackController.text,
//       'authToken': authToken!,
//     };
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: json.encode(requestBody),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         errorMessage = null;
//         feedbackController.clear();
//         final jsonData = json.decode(response.body);
//         if (jsonData.containsKey("result") && jsonData["result"] != null) {
//           final bookingsData = jsonData["result"] as List<dynamic>;

//           setState(() {
//             reviewsList = bookingsData.map((data) {
//               return review(
//                 id: data['feedback_id']?.toString() ?? 'N/A',
//                 cusid: data['customer_id']?.toString() ?? 'N/A',
//                 feedback: data['feedback']?.toString() ?? 'N/A',
//                 feedbackdate: data['feedback_date'] ?? 'N/A',
//               );
//             }).toList();
//           });

//         } else {
//           setState(() {
//             errorMessage = 'No feedback submitted';
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Error submitting feedback';
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         errorMessage = 'An error occurred';
//       });
//     }
//   }

//   Future<void> Ratings(int rating) async {
//     final String url = 'http://${widget.ipAddress}/ratings';
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString('lid');

//     final Map<String, dynamic> requestBody = {
//       'rating': rating,
//       'authToken': authToken!,
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: json.encode(requestBody),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         print('Rating submitted successfully');
//       } else {
//         print('Error submitting rating');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         centerTitle: true,
//         leading: Row(
//           children: [
//             IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.arrow_back),
//             ),
//           ],
//         ),
//         title: Text(
//           'Feedback',
//           style: TextStyle(fontFamily: 'Cera Pro'),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 sendFeedback();
//                 Fluttertoast.showToast(
//                   msg: "Feedback Submitted",
//                   toastLength: Toast.LENGTH_SHORT,
//                   gravity: ToastGravity.BOTTOM,
//                   backgroundColor: Color.fromARGB(255, 49, 106, 44),
//                   textColor: Colors.white,
//                 );
//               },
//               child: Text(
//                 "Submit",
//                 style: TextStyle(
//                     color: Colors.white, fontSize: 18, fontFamily: 'Cera Pro'),
//               )),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(padding: EdgeInsets.all(20)),
//               Text(
//                 "What do you think of our App?",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontFamily: 'Cera Pro',
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 height: 150,
//                 width: 330,
//                 padding: EdgeInsets.all(20), // Adjust the padding as needed
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     color: Colors.purple.withOpacity(0.4)),
//                 child: EmojiFeedback(
//                   animDuration: const Duration(milliseconds: 300),
//                   curve: Curves.bounceIn,
//                   inactiveElementScale: .5,
//                   onChanged: (value) {
//                     setState(() {
//                       currentRating = value;
//                     });
//                     Ratings(value);
//                   },
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               Text(
//                 'Current Rating: $currentRating',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               Padding(padding: EdgeInsets.all(20)),
//               Text(
//                 "What would you like to share with us?",
//                 style: TextStyle(
//                     fontFamily: 'Cera Pro',
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: 330,
//                 height: 150,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     color: Colors.purple.withOpacity(0.4)),
//                 child: Center(
//                   child: TextFormField(
//                     controller: feedbackController,
//                     decoration: InputDecoration(
//                       hintText: "Enter Your Thoughts",
//                       hintStyle: TextStyle(
//                         fontSize: 18,
//                         color: Color.fromARGB(255, 99, 95, 95),
//                       ),
//                     ),
//                     maxLines: null,
//                     textInputAction: TextInputAction.newline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class review {
  final String id;
  final String cusid;
  final String feedback;
  final String feedbackdate;

  review(
      {required this.id,
      required this.cusid,
      required this.feedback,
      required this.feedbackdate});
}

class EmojiModel {
  final String emoji;

  EmojiModel(this.emoji);
}

class EmojiRatingPage extends StatefulWidget {
  final String ipAddress;
  EmojiRatingPage({required this.ipAddress});
  @override
  _EmojiRatingPageState createState() => _EmojiRatingPageState();
}

class _EmojiRatingPageState extends State<EmojiRatingPage> {
  List<review> reviewsList = [];
  int currentRating = 0;
  int serviceRating = 0;
  TextEditingController feedbackController = TextEditingController();
  String? selectedEntityType;
  String? selectedType;
  List<String> entityTypes = [
    'Makeup Artists',
    'Costume Designers',
    'Packages',
    'Categories'
  ];
  String? errorMessage;

  Widget buildEntityTypeDropdown() {
    return DropdownButton<String>(
      value: selectedEntityType,
      onChanged: (String? newValue) {
        setState(() {
          selectedEntityType = newValue;
          selectedType = newValue; // Update the selected type
        });
      },
      items: entityTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Map<String, List<EmojiModel>> typeEmojis = {
    'Makeup Artists': [
      EmojiModel('😍'),
      EmojiModel('😊'),
      EmojiModel('😐'),
      EmojiModel('😕'),
      EmojiModel('😠'),
    ],
    'Costume Designers': [
      EmojiModel('😍'),
      EmojiModel('😊'),
      EmojiModel('😐'),
      EmojiModel('😕'),
      EmojiModel('😠'),
    ],
    'Packages': [
      EmojiModel('😍'),
      EmojiModel('😊'),
      EmojiModel('😐'),
      EmojiModel('😕'),
      EmojiModel('😠'),
    ],
    'Categories': [
      EmojiModel('😍'),
      EmojiModel('😊'),
      EmojiModel('😐'),
      EmojiModel('😕'),
      EmojiModel('😠'),
    ],
  };


  int getTypeIndex(String type) {
  switch (type) {
    case 'Makeup Artists':
      return 0;
    case 'Costume Designers':
      return 1;
    case 'Packages':
      return 2;
    case 'Categories':
      return 3;
    default:
      return 0; // Default to 0 or any other index as per your requirement
  }
}


Widget buildEmojiFeedback(int type) {
  List<EmojiModel> emojis =
      typeEmojis[type] ?? []; // Get emojis based on type
  return EmojiFeedback(
    animDuration: const Duration(milliseconds: 300),
    curve: Curves.bounceIn,
    inactiveElementScale: .5,
    onChanged: (value) {
      // Handle selected rating based on the selected type
      setState(() {
        serviceRating = value;
      });
      Ratings(serviceRating,2); // Call Ratings function with rating and type
    },
  );
}



  Future<void> sendFeedback() async {
    final String url = 'http://${widget.ipAddress}/sendreviews';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');

    final Map<String, String> requestBody = {
      'feedbac': feedbackController.text,
      'type': selectedType ?? '',
      'authToken': authToken!,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        errorMessage = null;
        feedbackController.clear();
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final bookingsData = jsonData["result"] as List<dynamic>;

          setState(() {
            reviewsList = bookingsData.map((data) {
              return review(
                id: data['feedback_id']?.toString() ?? 'N/A',
                cusid: data['customer_id']?.toString() ?? 'N/A',
                feedback: data['feedback']?.toString() ?? 'N/A',
                feedbackdate: data['feedback_date'] ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No feedback submitted';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error submitting feedback';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
      });
    }
  }

  // Future<void> Ratings(int rating, int type) async {
  //   final String url = 'http://${widget.ipAddress}/ratings';
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? authToken = prefs.getString('lid');

  //   final Map<String, dynamic> requestBody = {
  //     'rating': rating,
  //     'type': type,
  //     'authToken': authToken!,
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: json.encode(requestBody),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       print('Rating submitted successfully');
  //     } else {
  //       print('Error submitting rating');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }


Future<void> Ratings(int rating, int type) async {
  final String url = 'http://${widget.ipAddress}/ratings';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('lid');

  final Map<String, dynamic> requestBody = {
    'rating': rating,
    'type': type, // Pass the type parameter
    'authToken': authToken!,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Rating submitted successfully');
    } else {
      print('Error submitting rating');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
        title: Text(
          'Feedback',
          style: TextStyle(fontFamily: 'Cera Pro'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              sendFeedback();
              Fluttertoast.showToast(
                msg: "Feedback Submitted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Color.fromARGB(255, 49, 106, 44),
                textColor: Colors.white,
              );
            },
            child: Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Cera Pro',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Text(
                "Rating of our App?",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Cera Pro',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 150,
                width: 330,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.purple.withOpacity(0.4),
                ),
                child: EmojiFeedback(
                  animDuration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                  inactiveElementScale: .5,
                 onChanged: (value) {
                  setState(() {
                    currentRating = value;
                  });
                  Ratings(value, 1); // For app rating
                },
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'App Rating: $currentRating',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text(
  "Rating of our Services?",
  style: TextStyle(
    fontSize: 16,
    fontFamily: 'Cera Pro',
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
),

SizedBox(height: 10),

buildEntityTypeDropdown(),
SizedBox(height: 10),
selectedEntityType != null
    ? Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 100,
            width: 290,
            child: buildEmojiFeedback(getTypeIndex(selectedEntityType!)),
          ),
          SizedBox(height: 15.0),
          Text(
            'Service Rating: ${serviceRating ?? 'N/A'}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      )
    : SizedBox(), // Display nothing when no type is selected


              Padding(padding: EdgeInsets.all(20)),

              Text(
                "What would you like to share with us?",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),
              Container(
                width: 330,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.purple.withOpacity(0.4),
                ),
                child: Center(
                  child: TextFormField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      hintText: "Enter Your Thoughts",
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 99, 95, 95),
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
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