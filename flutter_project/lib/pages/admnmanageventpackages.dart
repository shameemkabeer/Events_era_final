import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admnviewpackages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventPackage {
  final String packageId;
  final String categoryId;
  final String foodId;
  final String title;
  final double amount;
  final String description;

  EventPackage({
    required this.packageId,
    required this.categoryId,
    required this.foodId,
    required this.title,
    required this.amount,
    required this.description,
  });
}

class EventPackagePage extends StatefulWidget {
  final String ipAddress;

  EventPackagePage({required this.ipAddress});

  @override
  _EventPackagePageState createState() => _EventPackagePageState();
}

class _EventPackagePageState extends State<EventPackagePage> {
  List<EventPackage> eventPackages = [];
  List<String> foods = [];
  String? selectedFood;

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getFoods();
  }

  TextEditingController packageTitleController = TextEditingController();
  TextEditingController packageAmountController = TextEditingController();
  TextEditingController packageDescriptionController = TextEditingController();

  String? selectedCategory;
  String? _errorMessage;
  String? selectedPackageId;
  int selectedPackageIndex = -1;
  List<String> categories = [];
  List<bool> selectedStates = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Manage Event Packages'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Text(
                  //   'Select a Category:',
                  //   style: TextStyle(fontSize: 16,color: const Color.fromARGB(255, 87, 84, 84)),
                  // ),
                  DropdownButtonFormField<String>(
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'select a Category',
                    ),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),   
                  SizedBox(height: 5),
                  // Text(
                  //   'Select a Food:',
                  //   style: TextStyle(fontSize: 16,color: const Color.fromARGB(255, 87, 84, 84)),
                  // ),
                  // DropdownButtonFormField<String>(
                  //   decoration: TextInputDecoration.copyWith(
                  //     labelText: 'Select a Food',
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
                  // SizedBox(
                  //   height: 50,
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
                    controller: packageTitleController,
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'Package Title',
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: packageDescriptionController,
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'Package Description',
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: packageAmountController,
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'Package Amount',
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                          ),
                          onPressed: () {
                            _addEventPackage();
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(color: Pallete.whiteColor),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Packageview(
                                        ipAddress: widget.ipAddress,
                                      )),
                            );
                          },
                          child: Text(
                            'View',
                            style: TextStyle(color: Pallete.whiteColor),
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
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  Future<void> _getCategories() async {
    final String url = 'http://${widget.ipAddress}/getcategories';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey("message") &&
            responseData["message"] is List) {
          List<dynamic> categoryDataList = responseData["message"];
          List<String> categoriesList = [];

          for (var category in categoryDataList) {
            categoriesList.add(category['category_name']);
          }

          setState(() {
            categories = categoriesList;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "message" key or not a list');
        }
      } else {
        print('Error fetching categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> getCategoryID(String categoryName) async {
    final String url = 'http://${widget.ipAddress}/get_category_id';

    final Map<String, String> requestBody = {
      'category_name': categoryName,
    };

    try {
      final response = await http.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String categoryID = responseData['category_id'].toString();
        return categoryID;
      } else {
        print('Error fetching Category ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _addEventPackage() async {
    final String url = 'http://${widget.ipAddress}/addeventpackages';
    String categoryID = await getCategoryID(selectedCategory!) ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? foodID = prefs.getString('foodid');
    print(foodID);


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



     String foodIDsString = selectedFoodIDs.join(',');

    if (categoryID != null) {
      final Map<String, String> requestBody = {
        'auth': categoryID,
        // 'foodid': foodID.toString(),
        'foodid': foodIDsString,
        'package_name': packageTitleController.text,
        'package_description': packageDescriptionController.text,
        'package_amount': packageAmountController.text,
      };

      print(foodID);

      try {
        final response = await http.post(Uri.parse(url), body: requestBody);

        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData.containsKey('pid')) {
            String pid = responseData['pid'].toString();
            prefs.setString('pid', pid);

            print('Event package added successfully. Package ID: $pid');

            packageTitleController.clear();
            packageDescriptionController.clear();
            packageAmountController.clear();
            setState(() {
              _errorMessage = null;
              selectedCategory = null;
            });
            Fluttertoast.showToast(
              msg: 'Event Package Added',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            print('Error adding packages: Invalid response');
            setState(() {
              _errorMessage = 'An error occurred';
            });
          }
        } else {
          print('Error adding packages: ${response.statusCode}');
          setState(() {
            _errorMessage = 'Error adding pack';
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
}
