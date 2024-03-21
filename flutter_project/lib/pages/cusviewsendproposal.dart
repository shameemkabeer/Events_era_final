import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'customakepaycustomevent.dart';
import 'customviewfoodetails.dart';

class Proposal {
  final String id;
  final String custid;
  final String cuseventId;
  final String cuseventname;
  final String place;
  final String persons;
  final String date;
  final String proposalDate;
  final String proposalAmount;
  String proposalStatus;
  bool isAccepted;

  Proposal(
      {required this.id,
      required this.custid,
      required this.cuseventId,
      required this.cuseventname,
      required this.place,
      required this.persons,
      required this.date,
      required this.proposalDate,
      required this.proposalAmount,
      required this.proposalStatus,
      this.isAccepted = false});
}

class ProposalListPage extends StatefulWidget {
  final String ipAddress;
  final String cuseventid;

  ProposalListPage({
    required this.ipAddress,
    required this.cuseventid,
  });

  @override
  _ProposalListPageState createState() => _ProposalListPageState();
}

class _ProposalListPageState extends State<ProposalListPage> {
  List<Proposal> proposalsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAcceptedStatus();
    viewProposals();
  }

// Function to save cuseventId in SharedPreferences
  _saveCuseventId(String cuseventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cuseventId', cuseventId);
  }

  Future<void> loadAcceptedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var proposal in proposalsList) {
      bool isAccepted = prefs.getBool(
            proposal.id,
          ) ??
          false;
      setState(() {
        proposal.isAccepted = isAccepted;
      });
    }
  }

  Future<void> saveAcceptedStatus(String proposalId, bool isAccepted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(proposalId, isAccepted);
  }

  Future<void> viewProposals() async {
    final String url = 'http://${widget.ipAddress}/viewproposals';
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
          final proposalsData = jsonData["result"] as List<dynamic>;
          setState(() {
            proposalsList = proposalsData.map((data) {
              String cuseventId = data['custom_event_id']?.toString() ?? 'N/A';

              // Store cuseventId in SharedPreferences
              _saveCuseventId(cuseventId);

              return Proposal(
                id: data['proposal_id']?.toString() ?? 'N/A',
                custid: data['customer_id']?.toString() ?? 'N/A',
                cuseventId: cuseventId,
                cuseventname: data['event_name']?.toString() ?? 'N/A',
                place: data['place']?.toString() ?? 'N/A',
                persons: data['no_of_persons']?.toString() ?? 'N/A',
                date: data['event_date'] ?? 'N/A',
                proposalDate: data['proposal_date'] ?? 'N/A',
                proposalAmount: data['proposal_amount'] ?? 'N/A',
                proposalStatus: data['proposal_status'] ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No proposal data found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error viewing proposals';
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
        title: Text('Proposal List',style: TextStyle(fontFamily: 'Cera Pro'),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildProposalList(),
      ),
    );
  }

  Widget _buildProposalList() {
    if (proposalsList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    // Filter out the 'Rejected' proposals
    List<Proposal> filteredProposals = proposalsList
        .where((proposal) => proposal.proposalStatus != 'Rejected')
        .toList();

    return ListView.builder(
      itemCount: filteredProposals.length,
      itemBuilder: (context, index) {
        final proposal = filteredProposals[index];

        return Card(
          elevation: 2,
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Container(
   
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
     color: Colors.purple.withOpacity(0.4)
    ),
          child: ListTile(
            title: Text('Custom Event: ${proposal.cuseventname}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Cera Pro')),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Place:${proposal.place}',
                    style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                Text('Persons: ${proposal.persons}',
                    style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                Text('Custom Event Date: ${proposal.date}',
                    style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                Text('Proposal Date: ${proposal.proposalDate}',
                    style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                Text('Proposal Amount: ${proposal.proposalAmount}',
                    style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                Text('Proposal Status: ${proposal.proposalStatus}',
                    style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
              ],
            ),
            contentPadding: EdgeInsets.all(16),
            trailing: proposal.proposalStatus == 'Paid'
                ? null
                : proposal.proposalStatus == 'Accepted'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Accepted',
                              style: TextStyle(color: const Color.fromARGB(255, 11, 90, 14))),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final cuseventid = proposal.cuseventId;
                              final proposalid = proposal.id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => cuseventpaymentForm(
                                    ipAddress: widget.ipAddress,    
                                    cuseventamount: proposal.proposalAmount,
                                    cuseventid: cuseventid,
                                    proposalid: proposalid,
                                  ),
                                ),
                              );
                            },
                            child: Text('Pay'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final String url =
                                    'http://${widget.ipAddress}/acceptproposal?cuseventid=${proposal.cuseventId}';
                                final response = await http.post(
                                  Uri.parse(url),
                                  body: jsonEncode({
                                    'id': proposal.id,
                                  }),
                                  headers: {'Content-Type': 'application/json'},
                                );
                                if (response.statusCode == 200) {
                                  setState(() {
                                    proposal.proposalStatus = 'Accepted';
                                  });
                                } else {
                                  print(
                                      'Error accepting proposal with ID: ${proposal.id}');
                                }
                              },
                              child: Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.green,
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final String url =
                                    'http://${widget.ipAddress}/rejectproposal?cuseventid=${proposal.cuseventId}';
                                final response = await http.post(
                                  Uri.parse(url),
                                  body: jsonEncode({
                                    'id': proposal.id,
                                  }),
                                  headers: {'Content-Type': 'application/json'},
                                );
                                if (response.statusCode == 200) {
                                  setState(() {
                                    proposal.proposalStatus = 'Rejected';
                                  });
                                } else {
                                  print(
                                      'Error rejecting proposal with ID: ${proposal.id}');
                                }
                      
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Confirm Deletion',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                        'Are you sure you want to reject this proposal?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.red,
                              ),
                            ),
                             SizedBox(width: 8),
                               ElevatedButton(
                              onPressed: () async {                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => foodlist(
                                      ipAddress: widget.ipAddress,
                                      cid: int.parse(proposal.cuseventId),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                'Foods',
                                style: TextStyle(fontFamily: 'Cera Pro'),
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