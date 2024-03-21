import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:convert';

class Packageview extends StatefulWidget {
  final String ipAddress;

  Packageview({required this.ipAddress});

  @override
  _PackageviewState createState() => _PackageviewState();
}

class _PackageviewState extends State<Packageview> {
  List<DataRow> packageRows = [];

  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateAmountController = TextEditingController();
  TextEditingController updateDesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getpackage();
  }

  Future<void> _getpackage() async {
    final String url = 'http://${widget.ipAddress}/getpackage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("event_package") &&
            responseData["event_package"] is List) {
          List<dynamic> packageList = responseData["event_package"];
          List<DataRow> rows = [];

          for (var package in packageList) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(package['package_name'])),
                DataCell(Text(package['package_description'])),
                DataCell(Text(package['package_amount'])),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 248, 251, 254),
                  ),
                  onPressed: () {
                    _handleUpdateAction(
                        package['package_name'],
                        package['package_description'],
                        package['package_amount']);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Color.fromRGBO(9, 9, 9, 1)),
                  ),
                )),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 240, 243, 246),
                  ),
                  onPressed: () {
                    _delEventPackage(package['package_name']);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Color.fromRGBO(13, 13, 13, 1)),
                  ),
                )),
              ],
            ));
          }

          setState(() {
            packageRows = rows;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "event_package" key or not a list');
        }
      } else {
        print('Error fetching packages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text('Event Packages'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
           
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  height: 645,
                  width: 300,
                 
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(label: Text('Package Name')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                          rows: packageRows,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpdateAction(
    String package_name,
    String package_description,
    String package_amount,
  ) {
    updateNameController.text = package_name;
    updateDesController.text = package_description;
    updateAmountController.text = package_amount;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Package Details'),
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
                controller: updateAmountController,
                decoration: InputDecoration(
                  labelText: 'New Amount',
                ),
              ),
              TextFormField(
                controller: updateDesController,
                decoration: InputDecoration(
                  labelText: 'New Description',
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
                final newAmt = updateAmountController.text;

                if (newName.isNotEmpty) {
                  _updateMakeupArtist(package_name, package_description,
                      package_amount, newName, newDes, newAmt);
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

  void _updateMakeupArtist(
    String package_name,
    String package_description,
    String package_amount,
    String newName,
    String newDes,
    String newAmt,
  ) async {
    final String url = 'http://${widget.ipAddress}/updatepackage';

    final Map<String, dynamic> data = {
      'package_name': package_name,
      'package_description': package_description,
      'package_amount': package_amount,
      'new_package_name': newName,
      'new_package_description': newDes,
      'new_package_amount': newAmt,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Package updated successfully: $newName');
        _getpackage();
      } else {
        print('Error updating Package: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateCategoryInList(
      // String oldcatName,
      // String newcatName,
      String oldName,
      String newName,
      String oldDes,
      String newDes,
      String oldAmt,
      String newAmt) {
    int index = packageRows.indexWhere((row) {
      final categoryText = row.cells[0].child as Text;
      return categoryText.data == oldName;
    });

    if (index != -1) {
      final updatedRow = DataRow(
        cells: [
          DataCell(Text(newName)),
          DataCell(Text(newDes)),
          DataCell(Text(newAmt)),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            onPressed: () {
              final package_name = newName;
              final package_description = newDes;
              final package_amount = newAmt;

              _handleUpdateAction(
                  package_name, package_description, package_amount);
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
          )),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            onPressed: () {
              _delEventPackage(newName);
            },
            child: Text(
              'Delete',
              style: TextStyle(color:Colors.white),
            ),
          )),
        ],
      );

      setState(() {
        packageRows[index] = updatedRow;
      });
    }
  }

  Future<void> _delEventPackage(String packageName) async {
    final String url = 'http://${widget.ipAddress}/deleventpackage';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"package_name": packageName}),
      );

      if (response.statusCode == 200) {
        print('Event package deleted successfully');
        // _getpackage();
        setState(() {
          packageRows.removeWhere(
              (row) => row.cells[0].child.toString() == 'Text("$packageName")');
        });
      } else {
        print('Error deleting event package: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
