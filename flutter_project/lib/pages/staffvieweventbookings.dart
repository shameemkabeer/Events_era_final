import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'staffviewdetails.dart';

class Booking {
  final String id;
  final String packid;
  final String packname;
  final String bookingDate;

  Booking({
    required this.id,
    required this.packid,
    required this.packname,
    required this.bookingDate,
  });
}

class BookingListPage extends StatefulWidget {
  final String ipAddress;

  BookingListPage({required this.ipAddress});

  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List<Booking> bookingsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewBookings();
  }

  Future<void> viewBookings() async {
    final String url = 'http://${widget.ipAddress}/staffviewbooking';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("result") &&
            responseData["result"] != null) {
          final bookingsData = responseData["result"] as List<dynamic>;
          setState(() {
            bookingsList = bookingsData.map((data) {
              return Booking(
                id: data['booking_id']?.toString() ?? 'N/A',
                packid: data['package_id']?.toString() ?? 'N/A',
                packname: data['package_name']?.toString() ?? 'N/A',
                bookingDate: data['booking_date'] ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No booking data found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing booked events';
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
        centerTitle: true,
        title: Text('Event Bookings'),
        backgroundColor:Colors.purple,
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildBookingList(),
        ),
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
          shadowColor: Colors.grey,
          color: Pallete.whiteColor,
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
               
              ),
              child: Container(
                height: 88,
                child: ListTile(
                  title: Text(
                    'Package: ${booking.packname}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Cera Pro'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Booking Date: ${booking.bookingDate}',
                          style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro'),
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ViewListPage(
                                ipAddress: widget.ipAddress,
                                pid: booking.packid,
                              )),
                        ),
                      );
                    },
                    child: Text('View More'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)
                      ), backgroundColor: Colors.purple,
                    ),
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
