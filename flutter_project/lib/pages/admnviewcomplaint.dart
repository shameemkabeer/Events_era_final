import 'package:flutter/material.dart';
import 'package:flutter_project/pages/adminhome.dart';
import 'package:flutter_project/pages/admnsendreply.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Complaint {
  final String id;
  final String fname;
  final String lname;
  final String cusid;
  String replyy;
  final String complaint;
  final String complaintDate;

  Complaint({
    required this.id,
    required this.fname,
    required this.lname,
    required this.cusid,
    required this.replyy,
    required this.complaint,
    required this.complaintDate,
  });
}

class ComplaintListPage extends StatefulWidget {
  final String ipAddress;

  ComplaintListPage({required this.ipAddress});

  @override
  _ComplaintListPageState createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  List<Complaint> complaintsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewComplaints();
  }

  Future<void> viewComplaints() async {
    final String url = 'http://${widget.ipAddress}/viewcomplaints';
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
          final complaintsData = jsonData["result"] as List<dynamic>;
          setState(() {
            complaintsList = complaintsData.map((data) {
              return Complaint(
                id: data['complaint_id']?.toString() ?? 'N/A',
                fname: data['first_name']?.toString() ?? 'N/A',
                lname: data['last_name']?.toString() ?? 'N/A',
                cusid: data['customer_id']?.toString() ?? 'N/A',
                complaint: data['complaint']?.toString() ?? 'N/A',
                replyy: data['reply']?.toString() ?? 'N/A',
                complaintDate: data['complaint_date'] ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No complaint data found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing complaints';
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
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => admhome()));
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text('Complaints'),
       backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildComplaintList(),
      ),
    );
  }

  Widget _buildComplaintList() {
    if (complaintsList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: complaintsList.length,
      itemBuilder: (context, index) {
        final complaint = complaintsList[index];

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
               
              ),
              child: ListTile(
                title: Text(
                    'Customer Name: ${complaint.fname} ${complaint.lname}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Cera Pro')),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${complaint.complaintDate}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                    Text('Complaint: ${complaint.complaint}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                    Text('Reply: ${complaint.replyy}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro'))
                  ],  
                ),
                contentPadding: EdgeInsets.all(16),
                trailing: complaint.replyy != 'Pending'
                    ? Text('Replied', style: TextStyle(color: Colors.green))
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(                            
                              onPressed: () async {
                              String com_id = complaint.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReplyPage(
                                    complaintId: com_id,
                                    ipAddress: widget.ipAddress,
                                  ),
                                ),
                              );
                            },
                            child: Text('Reply',style: TextStyle(fontFamily: 'Cera Pro'),),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green.withOpacity(0.9),
                            ),
                          ),
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