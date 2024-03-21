import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MakePage extends StatefulWidget {
  final String ipAddress;

  MakePage({required this.ipAddress});

  @override
  _MakePageState createState() => _MakePageState();
}

class _MakePageState extends State<MakePage> {
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPlaceController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  String? _errorMessage;
  List<DataRow> makeRows = [];
  String? selectedMake;

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updatePlaceController = TextEditingController();
  TextEditingController updateEmailController = TextEditingController();
  TextEditingController updatePhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getmake();
  }

  Future<void> _getmake() async {
    final String url = 'http://${widget.ipAddress}/getmakeups';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("message") &&
            responseData["message"] is List) {
          List<dynamic> makeDataList = responseData["message"];
          List<DataRow> rows = [];

          for (var make in makeDataList) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(make['name'])),
                DataCell(Text(make['place'])),
                DataCell(Text(make['email'])),
                DataCell(Text(make['phone'])),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    _handleUpdateAction(
                      make['name'],
                      make['place'],
                      make['email'],
                      make['phone'],
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
                    deletemake(make['name']);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                )),
              ],
            ));
          }

          // Ensure that rows have the same number of cells as the columns
          for (var i = 0; i < rows.length; i++) {
            while (rows[i].cells.length < _createColumns().length) {
              rows[i].cells.add(DataCell(Text('')));
            }
          }

          setState(() {
            makeRows = rows;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "message" key or not a list');
        }
      } else {
        print('Error fetching makeup artists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handleUpdateAction(
      String name, String place, String phone, String email) {
    updateNameController.text = name;
    updatePlaceController.text = place;
    updatePhoneController.text = phone;
    updateEmailController.text = email;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Edit Makeup Artist'),
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
    final String url = 'http://${widget.ipAddress}/updatemakeup';

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
        print('Makeup artist updated successfully: $newName');
        _getmake(); // Refresh the makeup artist list
      } else {
        print('Error updating makeup artist: ${response.statusCode}');
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
    int index = makeRows.indexWhere((row) {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 250, 250, 251),
            ),
            onPressed: () {
              final name = newName;
              final place = newPlace;
              final email = newEmail;
              final phone = newPhone;
              _handleUpdateAction(name, place, email, phone);
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Color.fromRGBO(7, 7, 7, 1)),
            ),
          )),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 248, 250, 251),
            ),
            onPressed: () {
              deletemake(newName);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Color.fromRGBO(15, 15, 16, 1)),
            ),
          )),
        ],
      );

      setState(() {
        makeRows[index] = updatedRow;
      });
    }
  }

  Future<void> deletemake(String artistName) async {
    final String url = 'http://${widget.ipAddress}/deleteMakeup';
    final Map<String, dynamic> data = {
      'name': artistName,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Artist deleted successfully: $artistName');
        setState(() {
          makeRows.removeWhere(
            (row) => row.cells[0].child.toString() == 'Text("$artistName")',
          );
        });
      } else {
        print('Error deleting artist: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error deleting artist';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addmakeup(
      String artistName, String place, String email, String phone) async {
    final String url = 'http://${widget.ipAddress}/addmakeup';
    final Map<String, dynamic> data = {
      'name': artistName,
      'place': place,
      'email': email,
      'phone': phone,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String aid = responseData['aid'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('aid', aid);

        print('Artist added successfully. Artist ID: $aid');
        newNameController.clear();
        newPlaceController.clear();
        newEmailController.clear();
        newPhoneController.clear();
        setState(() {
          _errorMessage = null;
        });
        Fluttertoast.showToast(
          msg: 'MakeUp Artist Added',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _getmake(); // Refresh the makeup artist list
      } else {
        print('Error adding makeup artist: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Error adding makeup artist';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Manage Makeup Artists'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: newNameController,
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'Artist Name',
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: newPlaceController,
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'Location',
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: newEmailController,
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
                    controller: newPhoneController,
                    decoration: TextInputDecoration.copyWith(
                      labelText: 'Phone',
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                            String artistName = newNameController.text;
                            String place = newPlaceController.text;
                            String email = newEmailController.text;
                            String phone = newPhoneController.text;

                            if (artistName.isNotEmpty) {
                              addmakeup(artistName, place, email, phone);
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
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: DataTable(
                        columns: _createColumns(),
                        rows: makeRows,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Artist Name')),
      DataColumn(label: Text('Location')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('')),
      DataColumn(label: Text('')),
    ];
  }
}
