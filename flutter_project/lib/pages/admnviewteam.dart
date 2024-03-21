import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:convert';

class Eventeamview extends StatefulWidget {
  final String ipAddress;

  Eventeamview({required this.ipAddress});

  @override
  _EventeamviewState createState() => _EventeamviewState();
}

class _EventeamviewState extends State<Eventeamview> {
  List<DataRow> staffRows = [];

  TextEditingController updatefirstNameController = TextEditingController();
  TextEditingController updatelastNameController = TextEditingController();
  TextEditingController updategenderController = TextEditingController();
  TextEditingController updatehouseNameController = TextEditingController();
  TextEditingController updateplaceController = TextEditingController();
  TextEditingController updatepincodeController = TextEditingController();
  TextEditingController updateemailController = TextEditingController();
  TextEditingController updatephoneNumberController = TextEditingController();
  TextEditingController updatepasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getevent();
  }

  Future<void> _getevent() async {
    final String url = 'http://${widget.ipAddress}/geteventteam';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("event_team") &&
            responseData["event_team"] is List) {
          List<dynamic> staffList = responseData["event_team"];
          List<DataRow> rows = [];
     
          for (var package in staffList) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(package['first_name'])),
                DataCell(Text(package['last_name'])),
                DataCell(Text(package['gender'])),
                DataCell(Text(package['house_name'])),
                DataCell(Text(package['place'])),
                DataCell(Text(package['pincode'])),
                DataCell(Text(package['email'])),
                DataCell(Text(package['phone'])),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    _handleUpdateAction(
                        package['first_name'],
                        package['last_name'],
                        package['gender'],
                        package['house_name'],
                        package['place'],
                        package['pincode'],
                        package['email'],
                        package['phone']);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                )),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 250, 252, 254),
                  ),
                  onPressed: () {
                    _delEventTeamMember(package['first_name']);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Color.fromRGBO(10, 10, 10, 1)),
                  ),
                )),
              ],
            ));
          }
          setState(() {
            staffRows = rows;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "event_team" key or not a list');
        }
      } else {
        print('Error fetching staffs: ${response.statusCode}');
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
        title: Text('Event Team Details',style: TextStyle(fontFamily: 'Cera Pro'),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
             
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  height: 645,
                  width: 320,
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          DataTable(
                            columns: [
                              DataColumn(label: Text('First Name')),
                              DataColumn(label: Text('Last Name')),
                              DataColumn(label: Text('Gender')),
                              DataColumn(label: Text('House Name')),
                              DataColumn(label: Text('Place')),
                              DataColumn(label: Text('Pincode')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                            ],
                            rows: staffRows,
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
      ),
    );
  }

  void _handleUpdateAction(
      String first_name,
      String last_name,
      String gender,
      String house_name,
      String place,
      String pincode,
      String email,
      String phone) {
    updatefirstNameController.text = first_name;
    updatelastNameController.text = last_name;
    updategenderController.text = gender;
    updatehouseNameController.text = house_name;
    updateplaceController.text = place;
    updatepincodeController.text = pincode;
    updateemailController.text = email;
    updatephoneNumberController.text = phone;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Edit Staff Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: updatefirstNameController,
                    decoration: InputDecoration(
                      labelText: 'New First Name',
                    ),
                  ),
                  TextFormField(
                    controller: updatelastNameController,
                    decoration: InputDecoration(
                      labelText: 'New Last Name',
                    ),
                  ),
                  TextFormField(
                    controller: updategenderController,
                    decoration: InputDecoration(
                      labelText: 'New gender',
                    ),
                  ),
                  TextFormField(
                    controller: updatehouseNameController,
                    decoration: InputDecoration(
                      labelText: 'New House Name',
                    ),
                  ),
                  TextFormField(
                    controller: updateplaceController,
                    decoration: InputDecoration(
                      labelText: 'New Place',
                    ),
                  ),
                  TextFormField(
                    controller: updatepincodeController,
                    decoration: InputDecoration(
                      labelText: 'New Pincode',
                    ),
                  ),
                  TextFormField(
                    controller: updateemailController,
                    decoration: InputDecoration(
                      labelText: 'New Email',
                    ),
                  ),
                  TextFormField(
                    controller: updatephoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'New Phone No',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    final newfName = updatefirstNameController.text;
                    final newlName = updatelastNameController.text;
                    final newgen = updategenderController.text;
                    final newhouse = updatehouseNameController.text;
                    final newplace = updateplaceController.text;
                    final newpincode = updatepincodeController.text;
                    final newemail = updateemailController.text;
                    final newphone = updatephoneNumberController.text;

                    if (newfName.isNotEmpty) {
                      _updateMakeupArtist(
                          first_name,
                          last_name,
                          gender,
                          house_name,
                          place,
                          pincode,
                          email,
                          phone,
                          newfName,
                          newlName,
                          newgen,
                          newhouse,
                          newplace,
                          newpincode,
                          newemail,
                          newphone);
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
    String first_name,
    String last_name,
    String gender,
    String house_name,
    String place,
    String pincode,
    String email,
    String phone,
    String newfName,
    String newlName,
    String newgen,
    String newhouse,
    String newplace,
    String newpincode,
    String newemail,
    String newphone,
  ) async {
    final String url = 'http://${widget.ipAddress}/updateteam';

    final Map<String, dynamic> data = {
      'first_name': first_name,
      'last_name': last_name,
      'gen': gender,
      'house_name': house_name,
      'place': place,
      'pin': pincode,
      'em': email,
      'ph': phone,
      'new_fname': newfName,
      'new_lname': newlName,
      'new_gen': newgen,
      'new_house': newhouse,
      'new_place': newplace,
      'new_pin': newpincode,
      'new_ema': newemail,
      'new_ph': newphone
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Staff updated successfully: $newfName');
        _getevent();
      } else {
        print('Error updating Staff: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateCategoryInList(
    String oldfName,
    String newfName,
    String oldlName,
    String newlName,
    String oldg,
    String newg,
    String oldhName,
    String newhName,
    String oldp,
    String newp,
    String oldpin,
    String newpin,
    String oldema,
    String newema,
    String oldph,
    String newph,
  ) {
    int index = staffRows.indexWhere((row) {
      final categoryText = row.cells[0].child as Text;
      return categoryText.data == oldfName;
    });

    if (index != -1) {
      final updatedRow = DataRow(
        cells: [
          DataCell(Text(newfName)),
          DataCell(Text(newlName)),
          DataCell(Text(newg)),
          DataCell(Text(newhName)),
          DataCell(Text(newp)),
          DataCell(Text(newpin)),
          DataCell(Text(newema)),
          DataCell(Text(newph)),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              final first_name = newfName;
              final last_name = newlName;
              final gender = newg;
              final house_name = newhName;
              final place = newp;
              final pincode = newpin;
              final email = newema;
              final phone = newph;
              _handleUpdateAction(first_name, last_name, gender, house_name,
                  place, pincode, email, phone);
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          )),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 253, 254, 255),
            ),
            onPressed: () {
              _delEventTeamMember(newfName);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
            ),
          )),
        ],
      );

      setState(() {
        staffRows[index] = updatedRow;
      });
    }
  }

  Future<void> _delEventTeamMember(String fname) async {
    final String url = 'http://${widget.ipAddress}/deleteeventteam';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"first_name": fname}),
      );

      if (response.statusCode == 200) {
        print('Event team member deleted successfully');
        setState(() {
          staffRows.removeWhere(
              (row) => row.cells[0].child.toString() == 'Text("$fname")');
        });
      } else {
        print('Error deleting event team member: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
