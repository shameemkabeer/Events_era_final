import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Rating {
  final int fid;
  final String fname;
  final String lname;
  final String feedback;
  final String feedbackDate;
  final int ratingno;
  final String ratedcat;

  Rating(
      {required this.fid,
      required this.fname,
      required this.lname,
      required this.feedback,
      required this.feedbackDate,
      required this.ratingno,
      required this.ratedcat});
}

class RatingListPage extends StatefulWidget {
  final String ipAddress;

  RatingListPage({required this.ipAddress});

  @override
  _RatingListPageState createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  List<Rating> ratingsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewReviews();
    _showToastMessage();
  }

  void _showToastMessage() {
    Fluttertoast.showToast(
      msg: '1st Rating Of Same Customer For App & 2nd For Service!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 237, 4, 4),
      textColor: Color.fromARGB(255, 255, 255, 255),
      fontSize: 16.0,
    );
  }

  Future<void> viewReviews() async {
    final String url = 'http://${widget.ipAddress}/cusviewrev';
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final bookingsData = jsonData["result"] as List<dynamic>;
          setState(() {
            ratingsList = bookingsData.map((data) {
              return Rating(
                  fid: data['feedback_id'] as int,
                  fname: data['first_name']?.toString() ?? 'N/A',
                  lname: data['last_name']?.toString() ?? 'N/A',
                  feedback: data['feedback']?.toString() ?? 'N/A',
                  feedbackDate: data['feedback_date'] ?? 'N/A',
                  ratingno: data['rating_no'] ?? 'N/A',
                  ratedcat: data['type'] ?? 'N/A');
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No Rating and Reviews found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing rating & reviews';
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
        backgroundColor: Colors.purple,
        title: Text('Reviews & Ratings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildRatingList(),
      ),
    );
  }

  Widget _buildRatingList() {
    if (ratingsList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: ratingsList.length,
      itemBuilder: (context, index) {
        final rating = ratingsList[index];
        return Card(
          shadowColor: Colors.grey,
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 155,
              decoration: BoxDecoration(),
              child: ListTile(
                title: Text('Customer Name: ${rating.fname} ${rating.lname}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cera pro')),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FeedBack: ${rating.feedback}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera Pro')),
                    Text('Feedback Date: ${rating.feedbackDate}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera Pro')),
                    Text('Rated Service: ${rating.ratedcat}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera Pro')),
                    Text('Rating: ${rating.ratingno}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera Pro')),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
