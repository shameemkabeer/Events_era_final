import 'package:flutter/material.dart';
import 'package:flutter_project/pages/customerhome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(ReplyListApp());
// }

class Reply {
  String replyy;
  final String complaint;
  final String complaintDate;

  Reply(
      {required this.replyy,
      required this.complaint,
      required this.complaintDate});
}

// class ReplyListApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ReplyListPage(),
//     );
//   }
// }

class ReplyListPage extends StatefulWidget {
  final String ipAddress;

  ReplyListPage({required this.ipAddress});
  @override
  _ReplyListPageState createState() => _ReplyListPageState();
}

class _ReplyListPageState extends State<ReplyListPage> {
  List<Reply> replyList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewReplies();
  }

  Future<void> viewReplies() async {
    final String url = 'http://${widget.ipAddress}/viewreplies';
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
          final replyData = jsonData["result"] as List<dynamic>;
          setState(() {
            replyList = replyData.map((data) {
              return Reply(
                complaint: data['complaint']?.toString() ?? 'N/A',
                complaintDate: data['complaint_date'] ?? 'N/A',
                replyy: data['reply']?.toString() ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No Replies found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing replies';
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
        backgroundColor: Colors.purple, 
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => custhome(
                            ipAddress: widget.ipAddress,
                          )));
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text('Replies',style: TextStyle(fontFamily: 'Cera Pro')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: _buildComplaintList(),
      ),
    );
  }

  Widget _buildComplaintList() {
    if (replyList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: replyList.length,
      itemBuilder: (context, index) {
        final Reply = replyList[index];

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
             decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
     color: Colors.purple.withOpacity(0.4)
    ),
          child: ListTile(
            title: Text('Complaint: ${Reply.complaint}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: 'Cera Pro')),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${Reply.complaintDate}',
                    style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro')),
                Text('Reply: ${Reply.replyy}', style: TextStyle(fontSize: 16,fontFamily: 'Cera Pro'))
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}