import 'package:flutter/material.dart';
import 'package:flutter_project/pages/home.dart';
import 'package:flutter_project/pages/staffviewprofile.dart';
import 'package:flutter_project/pages/staffvieweventbookings.dart';
import 'package:flutter_project/pages/staffviewcustomevents.dart';
import 'package:flutter_project/pages/staffviewratingandreviews.dart';
import 'package:lottie/lottie.dart';

class staffhome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: staffhom(ipAddress: '172.20.10.3:5000'),
    );
  }
}

class staffhom extends StatelessWidget {
  final String ipAddress;

  staffhom({required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Home'),
        backgroundColor: Colors.purple,
        centerTitle: true,
        // Add a drawer button to the app bar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Open the drawer
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
               showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout",style: TextStyle(fontFamily: 'Cera Pro'),),
                      content: const Text("Are you sure want to logout?",style: TextStyle(fontFamily: 'Cera Pro'),),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(ipAddress: ipAddress),
                                  ));
                            },
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))
                      ],
                    );
                  },
                );
             
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
          ),
          child: ListView(
            padding: EdgeInsets.only(top: 18),
            children: [
              Container(
                child: Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[800],
                ),
              ),
               SizedBox(
                height: 5,
              ),
              Text(
                'Staff',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Cera Pro'),
              ),
              SizedBox(height: 5,),
              ListTile(
                title: Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Event Bookings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookingListPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Custom Events'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => stfcustomeventview(
                              ipAddress: ipAddress,
                              cuseventid: '',
                            )),
                  );
                },
              ),
              ListTile(
                title: Text('View Reviews'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RatingListPage(ipAddress: ipAddress)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
         
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Lottie.asset(
                  'animations/staff_home.json',
                  width: 150,
                  height: 150,
                  repeat: true,
                  reverse: false,
                  animate: true,
                  options:
                      LottieOptions(enableMergePaths: true), // Enable merge paths
                ),
              ),
              SizedBox(height: 8,),
              Text('Tap The Menu Button',style: TextStyle(
                fontFamily: 'Cera Pro',
                fontWeight: FontWeight.w400
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
