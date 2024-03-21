import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'staffsendproposal.dart';
import 'stfviewproposal.dart';
import 'package:lottie/lottie.dart';

class stfcustomeventview extends StatefulWidget {
  final String ipAddress;
  final String cuseventid;
  stfcustomeventview({required this.ipAddress, required this.cuseventid});

  @override
  _stfcustomeventviewState createState() => _stfcustomeventviewState();
}

class _stfcustomeventviewState extends State<stfcustomeventview> {
  List<Map<String, dynamic>> customDataList = [];

  @override
  void initState() {
    super.initState();
    _getCustom();
  }

  Future<void> _getCustom() async {
    final String url = 'http://${widget.ipAddress}/admngetcustomevents';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey("custom_event") &&
            responseData["custom_event"] is List) {
          customDataList =
              List<Map<String, dynamic>>.from(responseData["custom_event"]);

          setState(() {});
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.purple.withOpacity(0.5),
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Transform.scale(
                scale: 1.0,
                child: Lottie.asset(
                  'animations/staffviewcustomevents1.json',
                  width: 800,
                  height: 800,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  options: LottieOptions(enableMergePaths: true),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final event = customDataList[index];
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                         color: Colors.purple.withOpacity(0.3)
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                event['event_name'].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Customer: ${event['user']}',style: TextStyle(fontFamily: 'Cera Pro'),),
                                  Text('Food: ${event['food']}'),
                                  Text('Quantity: ${event['qty']}'),
                                  Text('Serving Type: ${event['servetype']}'),
                                  Text('Budget: ${event['budget']}'),
                                  Text('Place: ${event['place']}'),
                                  Text(
                                      'No Of Persons: ${event['no_of_persons']}'),
                                  Text('Event Date: ${event['event_date']}'),
                                  Text('Status: ${event['event_status']}'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: event['event_status'] == 'Accepted'
                                  ? ElevatedButton(
                                      onPressed: () {
                                        final cuseventid =
                                            event['cuseventid'].toString();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  stviewProposalListPage(
                                                    ipAddress: widget.ipAddress,
                                                    cuseventid: cuseventid,
                                                  )),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 128, 133,
                                            128),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: Text('View Proposal'),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        final cuseventid =
                                            event['cuseventid'].toString();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProposalPage(
                                              ipAddress: widget.ipAddress,
                                              cuseventid: cuseventid,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: Text('Send Proposal'),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: customDataList.length,
            ),
          ),
        ],
      ),
    );
  }
}
