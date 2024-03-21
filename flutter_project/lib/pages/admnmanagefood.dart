import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventFoodPage extends StatefulWidget {
  final String ipAddress;

  EventFoodPage({required this.ipAddress});

  @override
  _EventFoodPageState createState() => _EventFoodPageState();
}

class _EventFoodPageState extends State<EventFoodPage> {
  TextEditingController foodNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController servingTypeController = TextEditingController();
  String? _errorMessage;
  List<DataRow> foodRows = [];
  String? selectedFood;

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateDesController = TextEditingController();
  TextEditingController updateQtyController = TextEditingController();
  TextEditingController updateServeController = TextEditingController();

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
          List<DataRow> rows = [];

          for (var food in foodDataList) {
            // Create DataRow and add to the list of rows
            rows.add(DataRow(
              cells: [
                DataCell(Text(food['food_name'])),
                DataCell(Text(food['description'])),
                DataCell(Text(food['quantity'])),
                DataCell(Text(food['serving_type'])),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    _handleUpdateAction(
                      food['food_name'],
                      food['description'],
                      food['quantity'],
                      food['serving_type'],
                    );
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                )),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    deletefood(food['food_name']);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                )),
              ],
            ));
          }

          setState(() {
            foodRows = rows;
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

  void _handleUpdateAction(String food_name, String description,
      String quantity, String serving_type) {
    updateNameController.text = food_name;
    updateDesController.text = description;
    updateQtyController.text = quantity;
    updateServeController.text = serving_type;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Edit Food Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: updateNameController,
                    decoration: InputDecoration(
                      labelText: 'New Name',
                    ),
                  ),
                  TextFormField(
                    controller: updateDesController,
                    decoration: InputDecoration(
                      labelText: 'New Description',
                    ),
                  ),
                  TextFormField(
                    controller: updateQtyController,
                    decoration: InputDecoration(
                      labelText: 'New Quantity',
                    ),
                  ),
                  TextFormField(
                    controller: updateServeController,
                    decoration: InputDecoration(
                      labelText: 'New Serving Type',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    final newName = updateNameController.text;
                    final newDes = updateDesController.text;
                    final newQty = updateQtyController.text;
                    final newServe = updateServeController.text;

                    if (newName.isNotEmpty) {
                      // Make an HTTP request to update the makeup artist
                      _updateMakeupArtist(
                        food_name,
                        newName,
                        description,
                        newDes,
                        quantity,
                        newQty,
                        serving_type,
                        newServe,
                      );
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateMakeupArtist(
      String oldName,
      String newName,
      String oldDes,
      String newDes,
      String oldQty,
      String newQty,
      String oldServe,
      String newServe) async {
    final String url = 'http://${widget.ipAddress}/updatefoods';

    final Map<String, dynamic> data = {
      'food_name': oldName,
      'new_name': newName,
      'description': oldDes,
      'new_des': newDes,
      'quantity': oldQty,
      'new_qty': newQty,
      'serving_type': oldServe,
      'new_serve': newServe,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Food updated successfully: $newName');
        _getFoods(); // Refresh the makeup artist list
      } else {
        print('Error updating Food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateCategoryInList(
      String oldName,
      String newName,
      String oldDes,
      String newDes,
      String oldQty,
      String newQty,
      String oldServe,
      String newServe) {
    int index = foodRows.indexWhere((row) {
      final categoryText = row.cells[0].child as Text;
      return categoryText.data == oldName;
    });

    if (index != -1) {
      final updatedRow = DataRow(
        cells: [
          DataCell(Text(newName)),
          DataCell(Text(newDes)),
          DataCell(Text(newQty)),
          DataCell(Text(newServe)),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              final food_name = newName;
              final description = newDes;
              final quantity = newQty;
              final serving_type = newServe;
              _handleUpdateAction(
                  food_name, description, quantity, serving_type);
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Color.fromARGB(255, 5, 5, 5)),
            ),
          )),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 248, 250, 253),
            ),
            onPressed: () {
              deletefood(newName);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Color.fromARGB(255, 11, 11, 11)),
            ),
          )),
        ],
      );

      setState(() {
        foodRows[index] = updatedRow;
      });
    }
  }

  Future<void> addFood(String foodName) async {
    final String url = 'http://${widget.ipAddress}/addfoods';
    final Map<String, dynamic> data = {
      'food_name': foodName,
      'description': descriptionController.text,
      'quantity': quantityController.text,
      'serving_type': servingTypeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String fid = responseData['fid'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('fid', fid);

        print('Food added successfully. Food ID: $fid');
        foodNameController.clear();
        descriptionController.clear();
        quantityController.clear();
        servingTypeController.clear();
        setState(() {
          _errorMessage = null;
        });
        Fluttertoast.showToast(
          msg: 'Food Added Successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Refresh the food list after adding a new item
        _getFoods();
      } else {
        print('Error adding event foods: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error adding event foods';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }

  Future<void> deletefood(String foodName) async {
    final String url = 'http://${widget.ipAddress}/deletefoods';
    final Map<String, dynamic> data = {
      'food_name': foodName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Event food deleted successfully: $foodName');
        // Remove the category from the UI
        setState(() {
          foodRows.removeWhere(
              (row) => row.cells[0].child.toString() == 'Text("$foodName")');
        });
        // Clear the selected category
        // selectCategory(null);
      } else {
        print('Error deleting event food: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error deleting event food';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Event Foods'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                        'assets/image/manage_event_food.jpg',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: foodNameController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Food Name',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: descriptionController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Description',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: quantityController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Quantity',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: servingTypeController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Serving Type',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                String foodName = foodNameController.text;
                                if (foodName.isNotEmpty) {
                                  if (selectedFood == null) {
                                    addFood(foodName);
                                  }
                                }
                              },
                              child: Text(
                                selectedFood == null ? 'Add' : 'Update',
                                style: TextStyle(color: Pallete.whiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 15.0),
                    // DataTable to display food items
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: DataTable(
                          columns: _createColumns(),
                          rows: foodRows,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Text(
          'Name',
        ),
      ),
      DataColumn(label: Text('Description')),
      DataColumn(label: Text('Quantity')),
      DataColumn(label: Text('Serving Type')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
    ];
  }
}
