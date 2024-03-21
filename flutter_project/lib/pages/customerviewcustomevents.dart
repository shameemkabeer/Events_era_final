import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Customeventview extends StatefulWidget {
  final String ipAddress;

  Customeventview({required this.ipAddress});
  @override
  _CustomeventviewState createState() => _CustomeventviewState();
}

class _CustomeventviewState extends State<Customeventview> {
  List<DataRow> customRows = [];

  TextEditingController updateeventNameController = TextEditingController();
  TextEditingController updatebudgetController = TextEditingController();
  TextEditingController updateplaceController = TextEditingController();
  TextEditingController updatepersonController = TextEditingController();
  TextEditingController updatedateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getcustom();
  }

  Future<void> _getcustom() async {
    final String url = 'http://${widget.ipAddress}/getcustomevents';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');

    final Map<String, dynamic> requestBody = {
      'authToken': authToken!,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("custom_event") &&
            responseData["custom_event"] is List) {
          List<dynamic> eventList = responseData["custom_event"];
          List<DataRow> rows = [];

          for (var package in eventList) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(package['event_name'])),
                DataCell(Text(package['budget'])),
                DataCell(Text(package['place'])),
                DataCell(Text(package['no_of_persons'])),
                DataCell(Text(package['event_date'])),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                      backgroundColor:Colors.purple),
                  onPressed: () {
                    _handleUpdateAction(
                        package['event_name'],
                        package['budget'],
                        package['place'],
                        package['no_of_persons'],
                        package['event_date']);
                  },
                  child: Text('Edit',
                      style:
                          TextStyle(color: Pallete.whiteColor)),
                )),
                DataCell(ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.purple),
                  onPressed: () {
                    _delcustomEvent(package['event_name']);
                  },
                  child: Text('Delete',
                      style:
                          TextStyle(color: Pallete.whiteColor)),
                )),
              ],
            ));
          }
          setState(() {
            customRows = rows;
          });
        } else {
          print(
              'Error: Invalid server response format - Missing "custom_event" key or not a list');
        }
      } else {
        print('Error fetching custom events: ${response.statusCode}');
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
        backgroundColor:Colors.purple,
        title: Text('Custom Event Details',style: TextStyle(fontFamily: 'Cera Pro'),),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Event Name',style: TextStyle(fontFamily: 'Cera Pro'),)),
                    DataColumn(label: Text('Budget',style: TextStyle(fontFamily: 'Cera Pro'))),
                    DataColumn(label: Text('Place',style: TextStyle(fontFamily: 'Cera Pro'))),
                    DataColumn(label: Text('No Of Persons',style: TextStyle(fontFamily: 'Cera Pro'))),
                    DataColumn(label: Text('Event Date',style: TextStyle(fontFamily: 'Cera Pro'))),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: customRows,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleUpdateAction(
    String event_name,
    String budget,
    String place,
    String no_of_persons,
    String event_date,
  ) {
    updateeventNameController.text = event_name;
    updatebudgetController.text = budget;
    updateplaceController.text = place;
    updatepersonController.text = no_of_persons;
    updatedateController.text = event_date;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Edit Custom Events'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: updateeventNameController,
                    decoration: InputDecoration(
                      labelText: 'New Event Name',
                    ),
                  ),
                  TextFormField(
                    controller: updatebudgetController,
                    decoration: InputDecoration(
                      labelText: 'New Budget',
                    ),
                  ),
                  TextFormField(
                    controller: updateplaceController,
                    decoration: InputDecoration(
                      labelText: 'New Place',
                    ),
                  ),
                  TextFormField(
                    controller: updatepersonController,
                    decoration: InputDecoration(
                      labelText: 'No Of Persons',
                    ),
                  ),
                  TextFormField(
                    controller: updatedateController,
                    decoration: InputDecoration(
                      labelText: 'New Date',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    final neweventName = updateeventNameController.text;
                    final newbudget = updatebudgetController.text;
                    final newplace = updateplaceController.text;
                    final newpers = updatepersonController.text;
                    final newdate = updatedateController.text;

                    if (neweventName.isNotEmpty) {
                      _updateMakeupArtist(
                          event_name,
                          budget,
                          place,
                          no_of_persons,
                          event_date,
                          neweventName,
                          newbudget,
                          newplace,
                          newpers,
                          newdate);
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
    String oldname,
    String oldbudget,
    String oldplace,
    String oldno_of_persons,
    String oldevent_date,
    String neweventName,
    String newbudget,
    String newplace,
    String newpers,
    String newdate,
  ) async {
    final String url = 'http://${widget.ipAddress}/updatecustomevents';

    final Map<String, dynamic> data = {
      'event_name': oldname,
      'budget': oldbudget,
      'place': oldplace,
      'no_of_persons': oldno_of_persons,
      'event_date': oldevent_date,
      'new_evname': neweventName,
      'new_bud': newbudget,
      'new_pl': newplace,
      'new_per': newpers,
      'new_date': newdate,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      // print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        print('Custom Event updated successfully: $neweventName');
        _getcustom();
      } else {
        print('Error updating Staff: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateCategoryInList(
    String oldname,
    String oldbudget,
    String oldplace,
    String oldno_of_persons,
    String oldevent_date,
    String neweventName,
    String newbudget,
    String newplace,
    String newpers,
    String newdate,
  ) {
    int index = customRows.indexWhere((row) {
      final categoryText = row.cells[0].child as Text;
      return categoryText.data == oldname;
    });

    if (index != -1) {
      final updatedRow = DataRow(
        cells: [
          DataCell(Text(neweventName)),
          DataCell(Text(newbudget)),
          DataCell(Text(newplace)),
          DataCell(Text(newpers)),
          DataCell(Text(newdate)),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
    final event_name = neweventName;
    final budget = newbudget;
    final place = newplace;
    final no_of_persons = newpers;
    final event_date = newdate;
   _handleUpdateAction(event_name, budget, place, no_of_persons, event_date);
},

            child: Text('Edit',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          )),
          DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              _delcustomEvent(neweventName);
            },
            child: Text('Delete',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          )),
        ],
      );

      setState(() {
        customRows[index] = updatedRow;
      });
    }
  }

  Future<void> _delcustomEvent(String event_name) async {
    final String url = 'http://${widget.ipAddress}/delcustomevents';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"event_name": event_name}),
      );

      if (response.statusCode == 200) {
        print('Custom Event deleted successfully');
        setState(() {
          customRows.removeWhere(
              (row) => row.cells[0].child.toString() == 'Text("$event_name")');
        });
      } else {
        print('Error deleting Custom Event: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
