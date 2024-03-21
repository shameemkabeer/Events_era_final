// import 'package:flutter/material.dart';
// import 'package:flutter_project/pages/adminhome.dart';
// import 'package:flutter_project/shared/constants.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'staffsendproposal.dart';
// import 'stfviewproposal.dart';
// import 'package:lottie/lottie.dart';

// class Admcustomeventview extends StatefulWidget {
//   final String ipAddress;

//   Admcustomeventview({
//     required this.ipAddress,
//   });

//   @override
//   _AdmcustomeventviewState createState() => _AdmcustomeventviewState();
// }

// class _AdmcustomeventviewState extends State<Admcustomeventview> {
//   List<Map<String, dynamic>> customDataList = [];

//   @override
//   void initState() {
//     super.initState();
//     _getCustom();
//   }

//   Future<void> _getCustom() async {
//     final String url = 'http://${widget.ipAddress}/admngetcustomevents';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);

//         if (responseData.containsKey("custom_event") &&
//             responseData["custom_event"] is List) {
//           customDataList =
//               List<Map<String, dynamic>>.from(responseData["custom_event"]);

//           setState(() {});
//         } else {
//           print(
//               'Error: Invalid server response format - Missing "custom_event" key or not a list');
//         }
//       } else {
//         print('Error fetching custom events: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.9),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             leading: IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder:(context) => admhom(ipAddress: widget.ipAddress),));}, icon: Icon(Icons.arrow_back,color: Colors.black,)),
//             automaticallyImplyLeading: false,
//             backgroundColor: Pallete.whiteColor,
//             expandedHeight: 200.0,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 'Custom Events',

//                 style: TextStyle(
//                   fontFamily: 'Cera Pro',
//                   color: Colors.black54,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               background: Transform.scale(
//     scale: 2.8,
//     child: Lottie.asset(
//       'animations/custom_event.json',
//       width: 800,
//       height: 800,
//       repeat: true,
//       reverse: false,
//       animate: true,
//       options: LottieOptions(enableMergePaths: true),
//     ),
//   ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 final event = customDataList[index];
//                 return Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Container(
//                         decoration: BoxDecoration(
//                          color: Colors.purple.withOpacity(0.4)
//                         ),
//                         child: Column(
//                           children: [
//                             ListTile(
//                               title: Text(
//                                 event['event_name'].toString(),
//                                 style: TextStyle(
//                                   fontFamily: 'Cera Pro',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Customer: ${event['user']}',style: TextStyle(fontFamily: 'Cera Pro'),),
//                                   Text('Food: ${event['food']}',style: TextStyle(fontFamily: 'Cera Pro'),),
//                                   Text('Quantity: ${event['qty']}',style: TextStyle(fontFamily: 'Cera Pro')),
//                                   Text('Serving Type: ${event['servetype']}',style: TextStyle(fontFamily: 'Cera Pro')),
//                                   Text('Budget: ${event['budget']}',style: TextStyle(fontFamily: 'Cera Pro')),
//                                   Text('Place: ${event['place']}',style: TextStyle(fontFamily: 'Cera Pro')),
//                                   Text(
//                                       'No Of Persons: ${event['no_of_persons']}',style: TextStyle(fontFamily: 'Cera Pro')),
//                                   Text('Event Date: ${event['event_date']}',style: TextStyle(fontFamily: 'Cera Pro')),
//                                   Text('Status: ${event['event_status']}',style: TextStyle(fontFamily: 'Cera Pro',
//                                   color: Color.fromARGB(255, 0, 190, 6),
//                                   )),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(16),
//                               child: event['event_status'] == 'Accepted'
//                                   ? ElevatedButton(
//                                       onPressed: () {
//                                         final cuseventid =
//                                             event['cuseventid'].toString();

//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   stviewProposalListPage(
//                                                     ipAddress: widget.ipAddress,
//                                                     cuseventid: cuseventid,
//                                                   )),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: Pallete.whiteColor, backgroundColor: Colors.purple,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(30.0),
//                                         ),
//                                       ),
//                                       child: Text('View Proposal',style: TextStyle(fontFamily: 'Cera Pro'),),
//                                     )
//                                   : ElevatedButton(
//                                       onPressed: () {
//                                         final cuseventid =
//                                             event['cuseventid'].toString();

//                                         // print(cuseventid);

//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ProposalPage(
//                                                     ipAddress: widget.ipAddress,
//                                                     cuseventid: cuseventid,
//                                                   )),
//                                         );
                                      // },
                                      // style: ElevatedButton.styleFrom(
                                      //   foregroundColor: Colors.white, backgroundColor: Colors.purple,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(
                                      //         30.0),
                                      //   ),
                                      // ),
                                    //   child: Text('Send Proposal',style: TextStyle(fontFamily: 'Cera Pro'),),
                                    // ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               childCount: customDataList.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_project/pages/adminhome.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'staffsendproposal.dart';
import 'stfviewproposal.dart';
import 'package:lottie/lottie.dart';
import 'admviewfoodetails.dart';

class cust {
  final int cuseventid;
  final String cusevent;
  final String customer;
  final String place;

  cust(
      {required this.cuseventid,
      required this.cusevent,
      required this.customer,
      required this.place,
});
}

class Admcustomeventview extends StatefulWidget {
  final String ipAddress;

  Admcustomeventview({
    required this.ipAddress,
  });

  @override
  _AdmcustomeventviewState createState() => _AdmcustomeventviewState();
}

class _AdmcustomeventviewState extends State<Admcustomeventview> {
  List<cust> customDataList = [];

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
      print(response.body);
      final jsonData = json.decode(response.body);
      if (jsonData.containsKey("custom_event") &&
          jsonData["custom_event"] != null) {
        final replyData = jsonData["custom_event"] as List<dynamic>;
        setState(() {
          customDataList = replyData.map((data) {
            return cust(
              cuseventid: data['custom_event_id'] ?? 'N/A',
              cusevent: data['event_name']?.toString() ?? 'N/A',
              customer: data['user']?.toString() ?? 'N/A',
              place: data['place']?.toString() ?? 'N/A',
            );
          }).toList();
        });
      } else {
        setState(() {});
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
      backgroundColor: Colors.white.withOpacity(0.9),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => admhom(ipAddress: widget.ipAddress),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Pallete.whiteColor,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Custom Events',
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Transform.scale(
                scale: 2.8,
                child: Lottie.asset(
                  'animations/custom_event.json',
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
                  padding: EdgeInsets.all(12),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.4),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                event.cusevent,
                                style: TextStyle(
                                  fontFamily: 'Cera Pro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Customer: ${event.customer}',
                                    style: TextStyle(fontFamily: 'Cera Pro'),
                                  ),
                                  Text('Place: ${event.place}',
                                      style: TextStyle(fontFamily: 'Cera Pro')),
                                ],
                              ),
                            ),
                           Padding(
  padding: EdgeInsets.all(16),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => foodlist(
                ipAddress: widget.ipAddress,
                cid: event.cuseventid,
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
      ElevatedButton(
  onPressed: () {
        final cuseventid = event.cuseventid.toString(); 

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProposalPage(
                  ipAddress: widget.ipAddress,
                  cuseventid: cuseventid,
                )),
      );
    },
     style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30.0),
        ),
      ),
        child: Text(
          'Send Proposal',
          style: TextStyle(fontFamily: 'Cera Pro'),
        ),
      ),
    ],
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
