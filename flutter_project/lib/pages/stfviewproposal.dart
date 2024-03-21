import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
import 'stffviewproposalamount.dart';

class Proposal {
  final String id;
  // final String cuseventId;
  final String cuseventname;
  final String proposalDate;
  final int proposalAmount;
  String proposalStatus;

  Proposal({
    required this.id,
    // required this.cuseventId,
    required this.cuseventname,
    required this.proposalDate,
    required this.proposalAmount,
    required this.proposalStatus,
  });
}

class stviewProposalListPage extends StatefulWidget {
  final String ipAddress;
  final String cuseventid;

  stviewProposalListPage({
    required this.ipAddress,
    required this.cuseventid,
  });

  @override
  _stviewProposalListPageState createState() => _stviewProposalListPageState();
}

class _stviewProposalListPageState extends State<stviewProposalListPage> {
  List<Proposal> proposalsList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    stffviewProposals();
  }

  Future<void> stffviewProposals() async {
    if (widget.cuseventid != null) {
      final String url = 'http://${widget.ipAddress}/staviewproposals';

      final Map<String, dynamic> requestBody = {
        'cuseventid': widget.cuseventid,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          errorMessage = null;
          final jsonData = json.decode(response.body);
          if (jsonData.containsKey("result")) {
            final proposalsData = jsonData["result"] as List<dynamic>;
            setState(() {
              proposalsList = proposalsData.map((data) {
                return Proposal(
                  id: data['proposal_id']?.toString() ?? 'N/A',
                  // cuseventId: cuseventId,
                  cuseventname: data['event_name']?.toString() ?? 'N/A',
                  proposalDate: data['proposal_date'] ?? 'N/A',
                  proposalAmount: int.parse(data['proposal_amount']),
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
    } else {
      print('custeventid is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

    return ListView.builder(
      itemCount: proposalsList.length,
      itemBuilder: (context, index) {
        final proposal = proposalsList[index];

        return Card(
          elevation: 5,
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
                title: Text('Custom Event: ${proposal.cuseventname}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proposal Date: ${proposal.proposalDate}',
                        style: TextStyle(fontSize: 16)),
                    Text('Proposal Amount: ${proposal.proposalAmount}',
                        style: TextStyle(fontSize: 16)),
                    Text('Proposal Status: ${proposal.proposalStatus}',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                trailing: proposal.proposalStatus == 'Paid'
                    ? ElevatedButton(
                        onPressed: () {
                          final proposalid = proposal.id.toString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => stffviewproposalamount(
                                  ipAddress: widget.ipAddress,
                                  proposalid: proposalid),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('View Payments'),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
