import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'customerviewcustomevents.dart';
import 'dart:convert';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomEvent {
  final String customEventId;
  final String customerId;
  final String customEventTitle;
  final String budgetAmount;
  final String place;
  final String noOfPersons;
  final String customEventDate;
  final String customEventStatus;

  CustomEvent({
    required this.customEventId,
    required this.customerId,
    required this.customEventTitle,
    required this.budgetAmount,
    required this.place,
    required this.noOfPersons,
    required this.customEventDate,
    required this.customEventStatus,
  });
}

class CustomEventPage extends StatefulWidget {
  final String ipAddress;
  CustomEventPage({required this.ipAddress});

  @override
  _CustomEventPageState createState() => _CustomEventPageState();
}

class _CustomEventPageState extends State<CustomEventPage> {
  List<CustomEvent> customEvents = [];
  List<String> foods = [];
  String? selectedFood;
  List<bool> selectedStates = [false, false, false, false];

  TextEditingController titleController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController personsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  String? _errorMessage;
  String? selectedVenue;
  DateTime? selectedDate;

  List<String> availableplaces = [
    'Conference Center',
    'Hotel Ballroom',
    'Outdoor Park',
    'Auditorium',
    'Banquet Hall',
    'Community Center',
    'Convention Center',
    'Restaurant',
    'Rooftop Terrace',
    'Beach Resort',
    'Country Club',
    'Sports Stadium',
    'Art Gallery',
    'Theater',
    'Wedding Chapel',
    'Museum',
    'Vineyard',
    'Yacht Club',
    'Farm or Barn',
    'Botanical Garden',
    'Historic Mansion'
  ];

  @override
  void initState() {
    super.initState();
    _getFoods();
  }

  Future<void> _getFoods() async {
    final String url = 'http://${widget.ipAddress}/getfoods';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("message") &&
            responseData["message"] is List) {
          List<dynamic> foodDataList = responseData["message"];
          List<String> foodsList = [];

          for (var food in foodDataList) {
            foodsList.add(food['food_name']);
          }

          setState(() {
            foods = foodsList;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "message" key or not a list');
        }
      } else {
        print('Error fetching foods: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getFoodID(String foodName) async {
    final String url = 'http://${widget.ipAddress}/get_food_id';

    final Map<String, String> requestBody = {
      'food_name': foodName,
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String foodID = responseData['food_id'].toString();
        return foodID;
      } else {
        print('Error fetching food ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> _selectBookingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text(
          'Manage Custom Events',
          style: TextStyle(fontFamily: 'Cera Pro'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Event Title',
                        labelStyle: TextStyle(
                          color: Colors.black, // Set your desired color
                        ),
                      ),
                    ),
                    // SizedBox(height: 50),
                    // DropdownButtonFormField<String>(
                    //   decoration: TextInputDecoration.copyWith(
                    //     labelText: 'Select a Food',
                    //     labelStyle: TextStyle(
                    //       color: Colors.black, // Set your desired color
                    //     ),
                    //   ),
                    //   value: selectedFood,
                    //   onChanged: (String? newValue) async {
                    //     setState(() {
                    //       selectedFood = newValue;
                    //     });
                    //     String? foodID = await getFoodID(newValue!);
                    //     if (foodID != null) {
                    //       SharedPreferences prefs =
                    //           await SharedPreferences.getInstance();
                    //       prefs.setString('foodid', foodID);
                    //     }
                    //   },
                    //   items: foods.map((String food) {
                    //     return DropdownMenuItem<String>(
                    //       value: food,
                    //       child: Text(food),
                    //     );
                    //   }).toList(),
                    // ),
                      SizedBox(height: 5),
            Text(
        'Select Food',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
            ),
            
            SizedBox(height: 5),
      Column(
  children: List.generate(foods.length, (index) {
    return CheckboxListTile(
      title: Text(foods[index]),
      value: selectedStates[index],
      onChanged: (bool? value) async {
        setState(() {
          selectedStates[index] = value ?? false;
        });
        if (value == true) {
          String? foodID = await getFoodID(foods[index]);
          if (foodID != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('foodid', foodID);
          }
        }
      },
    );
  }),
),
        SizedBox(height: 5),
                    TextField(
                      controller: budgetController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Budget Amount',
                        labelStyle: TextStyle(
                          color: Colors.black, // Set your desired color
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedVenue,
                      onChanged: (value) {
                        setState(() {
                          selectedVenue = value;
                        });
                      },
                      items: availableplaces.map((venue) {
                        return DropdownMenuItem<String>(
                          value: venue,
                          child: Text(venue),
                        );
                      }).toList(),
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Select Booking Venue',
                        labelStyle: TextStyle(
                          color: Colors.black, // Set your desired color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: personsController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Number of Persons',
                        labelStyle: TextStyle(
                          color: Colors.black, // Set your desired color
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Booking Date: ${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : ''}',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'Cera Pro'),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.purple.withOpacity(0.7)),
                          onPressed: () => _selectBookingDate(context),
                          child: Text('Select Date',
                              style: TextStyle(color: Pallete.whiteColor)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.purple),
                            onPressed: () {
                              _addCustomEvent();
        
                            },
                            child: Text('Add',
                                style: TextStyle(color: Pallete.whiteColor)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.purple),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Customeventview(
                                          ipAddress: widget.ipAddress,
                                        )),
                              );
                            },
                            child: Text('View',
                                style: TextStyle(color: Pallete.whiteColor)),
                          ),
                        ],
                      ),
                    ),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _addCustomEvent() async {
  //   final String url = 'http://${widget.ipAddress}/addcustomevent';
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? authToken = prefs.getString('lid');
  //   String? foodID = prefs.getString('foodid');
  //   print(foodID);

  //   final Map<String, String> requestBody = {
  //     'customeventname': titleController.text,
  //     'budget_amt': double.parse(budgetController.text).toString(),
  //     'place': selectedVenue ?? '',
  //     'noofpersons': personsController.text,
  //     'authToken': authToken.toString(),
  //     'foodid': foodID.toString(),
  //     'date': selectedDate != null ? selectedDate.toString() : '',
  //   };

  //   try {
  //     final response = await http.post(Uri.parse(url), body: requestBody);

  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = json.decode(response.body);
  //       if (responseData.containsKey('cuseventid')) {
  //         String cuseventid = responseData['cuseventid'].toString();
  //         prefs.setString('cuseventid', cuseventid);

  //         print(
  //             'Custom events added successfully, Custom event ID: $cuseventid');
  //         titleController.clear();
  //         budgetController.clear();
  //         selectedVenue = null;
  //         personsController.clear();
  //         selectedDate = null;
  //         setState(() {
  //           _errorMessage = null;
  //         });

  //           Fluttertoast.showToast(
  //           msg: 'Custom Event Added',
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );

  //       } else {
  //         print('Error adding custom events: Invalid response');
  //         setState(() {
  //           _errorMessage = 'An error occurred';
  //         });
  //       }
  //     } else {
  //       print('Error adding custom events: ${response.statusCode}');
  //       setState(() {
  //         _errorMessage = 'Error adding custom events';
  //       });
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     setState(() {
  //       _errorMessage = 'An error occurred';
  //     });
  //   }
  // }

Future<void> _addCustomEvent() async {
  final String url = 'http://${widget.ipAddress}/addcustomevent';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('lid');  
  
 List<String> selectedFoodIDs = [];
 for (int i = 0; i < selectedStates.length; i++) {
  if (selectedStates[i]) {
    String? foodID = await getFoodID(foods[i]);
    if (foodID != null) {
      selectedFoodIDs.add(foodID);
    } else {
      print('Food ID not found for ${foods[i]}');
    }
  }
}


  // Check if selectedFoodIDs is empty or contains only null values
  if (selectedFoodIDs.isEmpty || selectedFoodIDs.every((id) => id == null)) {
    // Handle the case where no valid food IDs are selected
    print('No valid food IDs selected');
    return;
  }

  // Convert the list of food IDs to a comma-separated string
  String foodIDsString = selectedFoodIDs.join(',');

  // Create the request body as a map
  final Map<String, dynamic> requestBody = {
    'customeventname': titleController.text,
    'budget_amt': double.parse(budgetController.text).toString(),
    'place': selectedVenue ?? '',
    'noofpersons': personsController.text,
    'authToken': authToken.toString(),
    'foodid': foodIDsString, // Pass the list of selected food IDs as a comma-separated string
    'date': selectedDate != null ? selectedDate.toString() : '',
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      body: requestBody,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Set content type
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('cuseventid')) {
        String cuseventid = responseData['cuseventid'].toString();
        prefs.setString('cuseventid', cuseventid);

        print(
            'Custom events added successfully, Custom event ID: $cuseventid');
        titleController.clear();
        budgetController.clear();
        selectedVenue = null;
        personsController.clear();
        selectedDate = null;
        setState(() {
          _errorMessage = null;
        });

        Fluttertoast.showToast(
          msg: 'Custom Event Added',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print('Error adding custom events: Invalid response');
        setState(() {
          _errorMessage = 'An error occurred';
        });
      }
    } else {
      print('Error adding custom events: ${response.statusCode}');
      setState(() {
        _errorMessage = 'Error adding custom events';
      });
    }
  } catch (e) {
    print('Error: $e');
    setState(() {
      _errorMessage = 'An error occurred';
    });
  }
}

}