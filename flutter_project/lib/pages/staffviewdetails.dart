import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'staffviewpayments.dart';

class Booking {
  final String id;
  final String packid;
  final String fname;
  final String lname;
  final String catname;
  final String bookingTime;
  final String bookingVenue;
  final String noOfPersons;
  bool isAccepted;

  Booking({
    required this.id,
    required this.packid,
    required this.fname,
    required this.lname,
    required this.catname,
    required this.bookingTime,
    required this.bookingVenue,
    required this.noOfPersons,
    this.isAccepted = false,
  });
}

class ViewListPage extends StatefulWidget {
  final String ipAddress;
  final String pid;

  ViewListPage({required this.ipAddress, required this.pid});

  @override
  _ViewListPageState createState() => _ViewListPageState();
}

class _ViewListPageState extends State<ViewListPage> {
  List<Booking> bookingsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewDetails(widget.pid); // Pass the 'pid' to viewDetails
  }

  Future<void> viewDetails(String pid) async {
    final String url = 'http://${widget.ipAddress}/staffviewdetails?pid=$pid';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'pid': pid}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final bookingsData = jsonData["result"] as List<dynamic>;
          setState(() {
            bookingsList = bookingsData.map((data) {
              return Booking(
                id: data['booking_id']?.toString() ?? 'N/A',
                packid: data['package_id']?.toString() ?? 'N/A',
                fname: data['first_name']?.toString() ?? 'N/A',
                lname: data['last_name']?.toString() ?? 'N/A',
                catname: data['category_name']?.toString() ?? 'N/A',
                bookingTime: data['booking_time'] ?? 'N/A',
                bookingVenue: data['booking_venue'] ?? 'N/A',
                noOfPersons: data['no_of_persons']?.toString() ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No booking details found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing booking details';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor:Colors.purple,
        centerTitle: true,
        title: Text('Event Booking Details',style: TextStyle(fontFamily: 'Cera pro'),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBookingList(),
      ),
    );
  }

  Widget _buildBookingList() {
    if (bookingsList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: bookingsList.length,
      itemBuilder: (context, index) {
        final booking = bookingsList[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.4)
              ),
              child: ListTile(
                title: Text('Customer Name: ${booking.fname} ${booking.lname}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${booking.catname}',
                          style: TextStyle(fontSize: 16)),
                      Text('Booking Time: ${booking.bookingTime}',
                          style: TextStyle(fontSize: 16)),
                      Text('Booking Venue: ${booking.bookingVenue}',
                          style: TextStyle(fontSize: 16)),
                      Text('No. Of Persons: ${booking.noOfPersons}',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // print('PID: ${booking.packid}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => staffPaymentView(
                              ipAddress: widget.ipAddress,
                              pid: booking.packid,
                            )),
                      ),
                    );
                  },
                  child: Text('Payment Details'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    foregroundColor: Colors.white, backgroundColor: Colors.purple,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
