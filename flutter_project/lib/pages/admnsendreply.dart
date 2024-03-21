import 'package:flutter/material.dart';
import 'package:flutter_project/pages/admnviewcomplaint.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class reply {
  final String id;
  final String cusid;
  final String rep;
  final String date;

  reply(
      {required this.id,
      required this.cusid,
      required this.rep,
      required this.date});
}

class ReplyForm extends StatelessWidget {
  final String ipAddress;

  ReplyForm({required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReplyPage(
        ipAddress: '',
        complaintId: 'complaintId',
      ),
    );
  }
}

class ReplyPage extends StatefulWidget {
  final String ipAddress;

  final String complaintId;

  ReplyPage({required this.complaintId, required this.ipAddress});

  @override
  _ReplyFormState createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyPage> {
  TextEditingController replyController = TextEditingController();
  String? errorMessage;

  Future<void> Replies() async {
    final String url = 'http://${widget.ipAddress}/admreply';

    final Map<String, dynamic> requestBody = {
      'id': widget.complaintId,
      'repl': replyController.text,
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
        replyController.clear();
        print('Replied');
      } else {
        print('Error while replied');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, 
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text('Complaints Replay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Container(
            width: 500,
            height: 500,   
            padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.purple.withOpacity(0.1)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Reply',
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                      fontWeight: FontWeight.bold,
                      color: Pallete.blackColor),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: replyController,
                  maxLines: 5,
                  decoration: TextInputDecoration.copyWith(
                    labelText: "Enter Replay",
                    labelStyle: TextStyle(color: Colors.black45)
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton( 
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(16))),
                      backgroundColor: MaterialStateProperty.all(
                           Colors.purple, )),
                  onPressed: () {
                    Replies();
                  },
                  child: Text('Send Reply',style: TextStyle(color: Colors.white,fontFamily: 'Cera Pro'),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}