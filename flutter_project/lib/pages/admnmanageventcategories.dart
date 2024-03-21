import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventCategoryPage extends StatefulWidget {
  final String ipAddress;

  EventCategoryPage({required this.ipAddress});
  @override
  _EventCategoryPageState createState() => _EventCategoryPageState();
}

class _EventCategoryPageState extends State<EventCategoryPage> {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController newCategoryController = TextEditingController();
  String? _errorMessage;
  List<DataRow> categoryRows = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _getCategories();
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
          List<DataRow> rows = [];

          for (var category in categoryDataList) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(category['category_name'])),
                DataCell(ElevatedButton(
                  onPressed: () {
                    final categoryName = category['category_name'];
                    _handleUpdateAction(categoryName);
                  },
                  child: Text('Edit'),
                )),
                DataCell(ElevatedButton(
                  onPressed: () {
                    deleteCategory(category['category_name']);
                  },
                  child: Text('Delete'),
                )),
              ],
            ));
          }

          setState(() {
            categoryRows = rows;
          });
          for (var category in categoryDataList) {
            updateCategoryInList(
                category['category_name'], category['category_name']);
          }
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

  // void _handleUpdateAction(String categoryName) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Edit Category Name'),
  //         content: TextField(
  //           controller: newCategoryController, // Updated the controller
  //           decoration: InputDecoration(
  //             labelText: 'New Category Name',
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Update'),
  //             onPressed: () {
  //               final newCategoryName = newCategoryController.text;
  //               if (newCategoryName.isNotEmpty) {
  //                 // Make an HTTP request to update the category name
  //                 updateCategory(categoryName, newCategoryName);
  //               }
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _handleUpdateAction(String categoryName) {
    newCategoryController.text = categoryName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category Name'),
          content: TextField(
            controller: newCategoryController,
            decoration: TextInputDecoration.copyWith(
              labelText: 'New Category Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () {
                final newCategoryName = newCategoryController.text;
                if (newCategoryName.isNotEmpty) {
                  // Make an HTTP request to update the category name
                  updateCategory(categoryName, newCategoryName);
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
        );
      },
    );
  }

  void updateCategory(String oldCategoryName, String newCategoryName) async {
    final String url = 'http://${widget.ipAddress}/updatecategories';

    final Map<String, dynamic> data = {
      'category_name': oldCategoryName,
      'new_name': newCategoryName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Event category updated successfully: $newCategoryName');
        _getCategories();
      } else {
        print('Error updating category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateCategoryInList(String oldCategoryName, String newCategoryName) {
    int index = categoryRows.indexWhere((row) {
      final categoryText = row.cells[0].child as Text;
      return categoryText.data == oldCategoryName;
    });

    if (index != -1) {
      final updatedRow = DataRow(
        cells: [
          DataCell(Text(newCategoryName)),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            onPressed: () {
              final categoryName = newCategoryName;
              _handleUpdateAction(categoryName);
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
              deleteCategory(newCategoryName);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Pallete.whiteColor),
            ),
          )),
        ],
      );

      setState(() {
        categoryRows[index] = updatedRow;
      });
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    final String url = 'http://${widget.ipAddress}/deletecategories';
    final Map<String, dynamic> data = {
      'category_name': categoryName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Event category deleted successfully: $categoryName');
        _getCategories(); // Refresh the category list
      } else {
        print('Error deleting event category: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error deleting event category';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addEventCategory(String categoryName) async {
    final String url = 'http://${widget.ipAddress}/addeventcategories';
    final Map<String, dynamic> data = {
      'category_name': categoryName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String cid = responseData['cid'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('cid', cid);

        print('Event category added successfully. Category ID: $cid');
        categoryNameController.clear();
        setState(() {
          _errorMessage = null;
        });
        Fluttertoast.showToast(
          msg: 'Event Category Added',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // updateCategoryInList(categoryName, categoryName);
        _getCategories();
      } else {
        print('Error adding event categories: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error adding event categories';
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
        title: Text('Manage Event Categories'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // alignment: Alignment.center,
          decoration: BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: categoryNameController,
                      decoration: TextInputDecoration.copyWith(
                        labelText: 'Category Name',
                      ),
                    ),
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
                              String categoryName = categoryNameController.text;
                              if (categoryName.isNotEmpty) {
                                addEventCategory(categoryName);
                              }
                            },
                            child: Text(
                              'Add',
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
                    SizedBox(height: 14.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: DataTable(
                          columns: _createColumns(),
                          rows: categoryRows,
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
      DataColumn(label: Text('Category Name')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
    ];
  }
}
