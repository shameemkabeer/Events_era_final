import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/pages/customakepayment.dart';

class Booking {
  final String id;
  final String cusid;
  final String packname;
  final String catname;
  final String packamount;
  final String bookingDate;
  final String bookingTime;
  final String bookingVenue;
  final String noOfPersons;
  String bookingStatus;
  final String type;
  bool isAccepted;

  Booking(
      {required this.id,
      required this.cusid,
      required this.packname,
      required this.catname,
      required this.packamount,
      required this.bookingDate,
      required this.bookingTime,
      required this.bookingVenue,
      required this.noOfPersons,
      required this.bookingStatus,
      required this.type,
      this.isAccepted = false});
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
    final String url = 'http://${widget.ipAddress}/customviewbooking';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('lid');

    final Map<String, String> requestBody = {
      'authToken': authToken!,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
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
                cusid: data['customer_id']?.toString() ?? 'N/A',
                packname: data['package_name']?.toString() ?? 'N/A',
                catname: data['category_name']?.toString() ?? 'N/A',
                packamount: data['package_amount']?.toString() ?? 'N/A',
                bookingDate: data['booking_date'] ?? 'N/A',
                bookingTime: data['booking_time'] ?? 'N/A',
                bookingVenue: data['booking_venue'] ?? 'N/A',
                noOfPersons: data['no_of_persons']?.toString() ?? 'N/A',
                bookingStatus: data['booking_status'] ?? 'N/A',
                type: data['booking_type'] ?? 'N/A',
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
        backgroundColor:Colors.purple, 
        centerTitle: true,
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

        // Check the booking status and set the content accordingly
        Widget content = SizedBox();

        if (booking.bookingStatus == 'Accepted') {
          // Display booking details
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking Date: ${booking.bookingDate}',
                  style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')),
                  SizedBox(height: 2,),
              Text('Booking Time: ${booking.bookingTime}',
                  style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')), SizedBox(height: 2,),
              Text('Booking Venue: ${booking.bookingVenue}',
                  style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')), SizedBox(height: 2,),
              Text('No. Of Persons: ${booking.noOfPersons}',
                  style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')), SizedBox(height: 2,),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {  
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => PaymentForm(
                                    ipAddress: widget.ipAddress,
                                    packamount: booking.packamount,
                                  ))));
                    },
                    child: Text(
                      "Pay Now",
                      style: TextStyle(fontFamily: 'Cera Pro',
                          color: Pallete.whiteColor)),
              ),),
            ],
          );
        } else if (booking.bookingStatus == 'Pending') {
          content = Text(
            'Please Wait.. You are in the Pending List',
            style:
                TextStyle(fontSize: 16, color: Color.fromARGB(255, 228, 73, 7)),
          );
        } else if (booking.bookingStatus == 'Rejected') {
          content = Text(
            'Sorry, please Try For Next Time',
            style: TextStyle(
                fontSize: 16, color: const Color.fromARGB(255, 237, 20, 5)),
          );
        }

  final Widget buttonWidget = booking.bookingStatus == 'Paid'
        ? Text(
            'Paid',
            style: TextStyle(fontFamily: 'Cera Pro', color: Pallete.whiteColor),
          )
        : ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: () {
              if (booking.bookingStatus != 'Paid') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => PaymentForm(
                      ipAddress: widget.ipAddress,
                      packamount: booking.packamount,
                    )),
                  ),
                );
              }
            },
            child: Text(
              "Pay Now",
              style: TextStyle(fontFamily: 'Cera Pro', color: Pallete.whiteColor),
            ),
          );

       return Card(
  elevation: 5,
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      
    ),
    child: ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Package Name: ${booking.packname}',
              style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')), SizedBox(height: 2,),
          Text('Category Name: ${booking.catname}',
              style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')), SizedBox(height: 2,),
          Text('Booking Status: ${booking.bookingStatus}',
              style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')), SizedBox(height: 2,),
          content, // Show the content based on the booking status
        ],
      ),
      tileColor: Colors.transparent,
      contentPadding: EdgeInsets.all(16),
    ),
  ),
);
      },
    );
  }
}