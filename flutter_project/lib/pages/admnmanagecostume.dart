import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CostumePage extends StatefulWidget {
  final String ipAddress;

  CostumePage({required this.ipAddress});

  @override
  _CostumePageState createState() => _CostumePageState();
}

class _CostumePageState extends State<CostumePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? _errorMessage;
  List<DataRow> costRows = [];
  String? selectedcost;

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updatePlaceController = TextEditingController();
  TextEditingController updateEmailController = TextEditingController();
  TextEditingController updatePhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getcost();
  }

  Future<void> _getcost() async {
    final String url = 'http://${widget.ipAddress}/getcostume';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("message") &&
            responseData["message"] is List) {
          List<dynamic> costDataList = responseData["message"];
          List<DataRow> rows = [];

          for (var cost in costDataList) {
            // Create DataRow and add to the list of rows
            rows.add(DataRow(
              cells: [
                DataCell(Text(cost['name'])),
                DataCell(Text(cost['place'])),
                DataCell(Text(cost['email'])),
                DataCell(Text(cost['phone'])),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    _handleUpdateAction(
                      cost['name'],
                      cost['place'],
                      cost['email'],
                      cost['phone'],
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
                    deletecost(cost['name']);
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
            costRows = rows;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "message" key or not a list');
        }
      } else {
        print('Error fetching designers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleUpdateAction(
      String name, String place, String email, String phone) {
    updateNameController.text = name;
    updatePlaceController.text = place;
    updateEmailController.text = email;
    updatePhoneController.text = phone;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Edit Costume Designer'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: updateNameController,
                      decoration: InputDecoration(
                        labelText: 'New Name',
                      ),
                    ),
                    TextFormField(
                      controller: updatePlaceController,
                      decoration: InputDecoration(
                        labelText: 'New Place',
                      ),
                    ),
                    TextFormField(
                      controller: updateEmailController,
                      decoration: InputDecoration(
                        labelText: 'New Email',
                      ),
                    ),
                    TextFormField(
                      controller: updatePhoneController,
                      decoration: InputDecoration(
                        labelText: 'New Phone',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    final newName = updateNameController.text;
                    final newPlace = updatePlaceController.text;
                    final newEmail = updateEmailController.text;
                    final newPhone = updatePhoneController.text;

                    if (newName.isNotEmpty) {
                      // Make an HTTP request to update the makeup artist
                      _updateMakeupArtist(
                        name,
                        newName,
                        place,
                        newPlace,
                        email,
                        newEmail,
                        phone,
                        newPhone,
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
      String oldPlace,
      String newPlace,
      String oldEmail,
      String newEmail,
      String oldPhone,
      String newPhone) async {
    final String url = 'http://${widget.ipAddress}/updatecost';

    final Map<String, dynamic> data = {
      'name': oldName,
      'new_name': newName,
      'place': oldPlace,
      'new_place': newPlace,
      'email': oldEmail,
      'new_email': newEmail,
      'phone': oldPhone,
      'new_phone': newPhone,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Costume Designer updated successfully: $newName');
        _getcost(); // Refresh the makeup artist list
      } else {
        print('Error updating Costume Designer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateCategoryInList(
      String oldName,
      String newName,
      String oldPlace,
      String newPlace,
      String oldEmail,
      String newEmail,
      String oldPhone,
      String newPhone) {
    int index = costRows.indexWhere((row) {
      final categoryText = row.cells[0].child as Text;
      return categoryText.data == oldName;
    });

    if (index != -1) {
      final updatedRow = DataRow(
        cells: [
          DataCell(Text(newName)),
          DataCell(Text(newPlace)),
          DataCell(Text(newEmail)),
          DataCell(Text(newPhone)),
          DataCell(ElevatedButton(
            onPressed: () {
              final name = newName;
              final place = newPlace;
              final email = newEmail;
              final phone = newPhone;
              _handleUpdateAction(name, place, email, phone);
            },
            child: Text('Edit'),
          )),
          DataCell(ElevatedButton(
            onPressed: () {
              deletecost(newName);
            },
            child: Text('Delete'),
          )),
        ],
      );

      setState(() {
        costRows[index] = updatedRow;
      });
    }
  }

  Future<void> addcostume(String designerName) async {
    final String url = 'http://${widget.ipAddress}/addcostume';
    final Map<String, dynamic> data = {
      'name': designerName,
      'place': placeController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String deid = responseData['deid'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('deid', deid);

        print('Designer added successfully. Designer ID: $deid');
        nameController.clear();
        placeController.clear();
        emailController.clear();
        phoneController.clear();
        setState(() {
          _errorMessage = null;
        });
        Fluttertoast.showToast(
          msg: 'Costume Designer Added',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Refresh the food list after adding a new item
        _getcost();
      } else {
        print('Error adding costume designers: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error adding costume designers';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }

  Future<void> deletecost(String designerName) async {
    final String url = 'http://${widget.ipAddress}/deletecostume';
    final Map<String, dynamic> data = {
      'name': designerName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Designer deleted successfully: $designerName');
        // Remove the food item from the UI
        setState(() {
          costRows.removeWhere((row) =>
              row.cells[0].child.toString() == 'Text("$designerName")');
        });
      } else {
        print('Error deleting designer: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error deleting designer';
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
        title: Text('Manage Costume Designers'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: TextInputDecoration.copyWith(
                    labelText: 'Designer Name',
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: placeController,
                  decoration: TextInputDecoration.copyWith(
                    labelText: 'Location',
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: TextInputDecoration.copyWith(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: TextInputDecoration.copyWith(
                    labelText: 'Phone',
                  ),
                ),
                SizedBox(
                  height: 30,
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
                          String designerName = nameController.text;
                          if (designerName.isNotEmpty) {
                            if (selectedcost == null) {
                              addcostume(designerName);
                            }
                          }
                        },
                        child: Text(
                          selectedcost == null ? 'Add' : 'Update',
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: DataTable(
                      columns: _createColumns(),
                      rows: costRows,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Designer Name')),
      DataColumn(label: Text('Place')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
    ];
  }
}
