import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Booking {
  final String id;
  final String fname;
  final String catname;
  final String bookingDate;
  final String bookingTime;
  final String bookingVenue;
  final String noOfPersons;
  String bookingStatus;
  bool isAccepted = false;

  Booking({
    required this.id,
    required this.fname,
    required this.catname,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingVenue,
    required this.noOfPersons,
    required this.bookingStatus,
  });
}

class BookingListPage extends StatefulWidget {
  final String ipAddress;

  BookingListPage({required this.ipAddress});

  @override
  _BookingsListScreenState createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingListPage> {
  List<Booking> bookingsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewBookings();
  }

  Future<void> viewBookings() async {
    final String url = 'http://${widget.ipAddress}/viewbooking';
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final bookingsData = jsonData["result"] as List<dynamic>;
          setState(() {
            bookingsList = bookingsData.map((data) {
              return Booking(
                id: data['booking_id']?.toString() ?? 'N/A',
                fname: data['first_name']?.toString() ?? 'N/A',
                catname: data['category_name']?.toString() ?? 'N/A',
                bookingDate: data['booking_date'] ?? 'N/A',
                bookingTime: data['booking_time'] ?? 'N/A',
                bookingVenue: data['booking_venue'] ?? 'N/A',
                noOfPersons: data['no_of_persons']?.toString() ?? 'N/A',
                bookingStatus: data['booking_status'] ?? 'N/A',
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

  Future<void> _acceptBooking(String bookingId) async {
    final String url = 'http://${widget.ipAddress}/acceptbooking';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'id': bookingId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        final booking =
            bookingsList.firstWhere((element) => element.id == bookingId);
        booking.bookingStatus = 'Accepted';
        booking.isAccepted = true;
      });
    } else {
      print('Error accepting booking with ID: $bookingId');
    }
  }

  Future<void> _rejectBooking(String bookingId) async {
    final String url = 'http://${widget.ipAddress}/rejectbooking';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'id': bookingId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        final booking =
            bookingsList.firstWhere((element) => element.id == bookingId);
        booking.bookingStatus = 'Rejected';
      });
    } else {
      print('Error rejecting booking with ID: $bookingId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
            backgroundColor:Colors.purple,
        title: Text('Bookings List',style: TextStyle(fontFamily: 'Cera Pro'),),
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
        final isPending = booking.bookingStatus == 'Pending';
        final isAccepted = booking.bookingStatus == 'Accepted';
        final isRejected = booking.bookingStatus == 'Rejected';    

        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
                 decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    color: Colors.purple.withOpacity(0.4)
    ),
            child: ListTile(
              title: Text('Customer Name: ${booking.fname}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Cera Pro')),
              subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category Name: ${booking.catname}',
                      style: TextStyle(fontSize: 15,fontFamily: 'Cera Pro')),
                  Text('Booking Date: ${booking.bookingDate}',
                      style: TextStyle(fontSize: 15,fontFamily: 'Cera Pro')),
                  Text('Booking Time: ${booking.bookingTime}',
                      style: TextStyle(fontSize: 15,fontFamily: 'Cera Pro')),
                  Text('Booking Venue: ${booking.bookingVenue}',
                      style: TextStyle(fontSize: 15,fontFamily: 'Cera Pro')),
                  Text('No. Of Persons: ${booking.noOfPersons}',
                      style: TextStyle(fontSize: 15,fontFamily: 'Cera Pro')),
                  Text('Booking Status: ${booking.bookingStatus}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Cera Pro',
                        color: isAccepted
                            ? Colors.green
                            : isRejected
                                ? Colors.red
                                : Colors.black,
                      )),
                ],
              ),
              contentPadding: EdgeInsets.all(16),
              trailing: isPending
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _acceptBooking(booking.id);
                          },
                          child: Text('Accept',style: TextStyle(fontFamily: 'Cera Pro'),),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Confirm Rejection',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Cera Pro'),
                                ),
                                content: Text(
                                    'Are you sure you want to reject this booking?',style: TextStyle(fontFamily: 'Cera Pro'),),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel',style: TextStyle(fontFamily: 'Cera Pro'),),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await _rejectBooking(booking.id);
                                    },
                                    child: Text('Reject',style: TextStyle(fontFamily: 'Cera Pro'),),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text('Reject',style: TextStyle(fontFamily: 'Cera Pro'),),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    )
                  : isAccepted
                      ? Text('Accepted', style: TextStyle(color: Colors.green))
                      : isRejected
                          ? Text('Rejected', style: TextStyle(color: Colors.red))
                          : null,
            ),
          ),
        );


      },
    );
  }
}