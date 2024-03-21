import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/home.dart';
import 'package:flutter_project/pages/customvieweventcategories.dart';
import 'package:flutter_project/pages/customvieweventpackages.dart';
import 'package:flutter_project/pages/custombookingevent.dart';
import 'package:flutter_project/pages/customermanagecustomevent.dart';
import 'package:flutter_project/pages/customviewmakeup.dart';
import 'package:flutter_project/pages/customviewcostumedesigners.dart';
import 'package:flutter_project/pages/customviewbookingdetails.dart';
import 'package:flutter_project/pages/customsendratingandreviews.dart';
import 'package:flutter_project/pages/customsendcomplaint.dart';
import 'package:flutter_project/pages/customviewreply.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:lottie/lottie.dart';
import 'cusviewsendproposal.dart';
import 'customviewreviews.dart';

class cushome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: custhome(ipAddress: '172.20.10.3:5000'),
    );
  }
}

class custhome extends StatelessWidget {
  
  final String ipAddress;
  

 List imageList = [
  {"id":1 ,"image_path": 'assets/image/customerhomewedding2.jpg'},
  {"id":2 ,"image_path": 'assets/image/customerhomebirthday1.jpg'},
  {"id":3 ,"image_path": 'assets/image/customerhomegroomtobe.jpg'},
  {"id":4 , "image_path":'assets/image/customerhomescroll1.jpg'}
 ]; 
final CarouselController carousalController = CarouselController();
int currentIndex = 0;

  custhome({required this.ipAddress,});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Colors.purple,
        centerTitle: true,
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
        title: Text('Customer Home'),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
           
          ),
          child: ListView(
            padding: EdgeInsets.only(top: 18),
            children: [
              Container(
                child:   Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[800],
                ),
              ),
               SizedBox(
                height: 5,
              ),
              Text(
                'Customer',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Cera Pro'),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text('View Event Categories'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerEventCategoryPage(ipAddress: ipAddress)),
                  ); // Close the drawer
                },
              ),
              ListTile(
                title: Text('View Event Packages'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerEventPackagePage(ipAddress: ipAddress)),
                  ); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Manage A Custom Event'),
                onTap: () {
                  // Handle item tap
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomEventPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Proposals'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProposalListPage(
                            ipAddress: ipAddress, cuseventid:'')),
                  );
                },
              ),
              ListTile(
                title: Text('Book An Event'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BookEventPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                  title: Text('View Booking Details'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BookingListPage(ipAddress: ipAddress)),
                    );
                  }),
              ListTile(
                title: Text('Send Rating & Reviews'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EmojiRatingPage(ipAddress: ipAddress)),
                  );
                },
              ),
              // ListTile(
              //   title: Text('View Contact Details Of MakeUp Artists'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => MakeUpPage(ipAddress: ipAddress)),
              //     );
              //   },
              // ),
              // ListTile(
              //   title: Text('View Contact Details Of Costume Designers'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => CostumePage(ipAddress: ipAddress)),
              //     );
              //   },
              // ),
              ListTile(
                title: Text('Send Complaint'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ComplaintPage(ipAddress: ipAddress)),
                  );
                },
              ),
              ListTile(
                title: Text('View Replies'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReplyListPage(ipAddress: ipAddress)),
                  );
                },
              ),
               ListTile(
                title: Text('View Reviews & Ratings'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => BookEventPage(ipAddress: ipAddress),));
                print(currentIndex);
              },
              child: Padding(padding: EdgeInsets.all(11),
                  child: CarouselSlider(items: imageList.map((item) => ClipRRect(borderRadius: BorderRadius.circular(20),
                    child: Image.asset(item['image_path'],
                    fit: BoxFit.fill,
                    width: double.infinity,
                    ),
                  ),
                   ).toList(),
                   carouselController: carousalController,
                    options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      
                      autoPlay: true,
                      aspectRatio: 2,
                      viewportFraction: 1,
                      onPageChanged: (index,reason) {
                        currentIndex  = index;
                        // setState((){
                        //   currentIndex = index;
                        // });
                      } 
                  ),),
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Padding(padding: EdgeInsets.only(left: 20,top: 30)),
                Text("Popular Events",style: TextStyle(fontFamily: 'Cera Pro',),),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookEventPage(ipAddress: ipAddress),)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customerhomereception2.jpg'),fit: BoxFit.fill,)),
                        height: 100,
                        width: 150, 
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customerhomebirthday1.jpg'),fit: BoxFit.fill,)),
                        height: 100,
                        width: 150,
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customerhomescroll1.jpg'),fit: BoxFit.fill,)),
                        height: 100,
                        width: 150,
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customerhomehaldi.jpg'),fit: BoxFit.fill,)),
                        height: 100,
                        width: 150,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [Padding(padding: EdgeInsets.only(left: 15,top: 28)),
            //     Text('Book Now',style: TextStyle(fontFamily: 'Cera Pro'),),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
              child: Stack(children: [
                 GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookEventPage(ipAddress: ipAddress))),
                   child: Container(
                    height: 200,
                    width: 360,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customer_home_events_img.jpg'),fit: BoxFit.fill,)),
                                 ),
                 ),
                Padding(
                  padding: const EdgeInsets.only(top: 175,left: 13),
                  child: Text("Events",style: TextStyle(color: Pallete.whiteColor,fontFamily: 'Cera Pro',fontWeight: FontWeight.bold),),
                )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
             child: Stack(children: [
                 GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MakeUpPage(ipAddress: ipAddress),)),
                   child: Container(
                    height: 200,
                    width: 360,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customerhome_makeup_img.jpg'),fit: BoxFit.fill)),
                                 ),
                 ),
                Padding(
                  padding: const EdgeInsets.only(top: 175,left: 13,),
                  child: Text("Makeup Artists",style: TextStyle(color: Pallete.whiteColor,fontFamily: 'Cera Pro',fontWeight: FontWeight.bold),),
                )
                ]
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Stack(children: [
                 GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CostumePage(ipAddress: ipAddress),)),
                   child: Container(
                    height: 200,
                    width: 360,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.purple.withOpacity(0.3)),
                    child: ClipRRect (borderRadius: BorderRadius.circular(20), child: Image(image: AssetImage('assets/image/customerhome_costume_designer_img.jpg'),fit: BoxFit.fill)),
                                 ),
                 ),
                Padding(
                  padding: const EdgeInsets.only(top: 175,left: 13),
                  child: Text("Costume Designers",style: TextStyle(color: Pallete.whiteColor,fontFamily: 'Cera Pro',fontWeight: FontWeight.bold),),
                )
                ]
              ),
              ),
          ],
        ),
      ),
      // body: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   decoration: BoxDecoration(
         
      //   ),
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(left: 60),
      //           child: Lottie.asset(
      //             'animations/staff_home.json',
      //             width: 150,
      //             height: 150,
      //             repeat: true,
      //             reverse: false,
      //             animate: true,
      //             options:
      //                 LottieOptions(enableMergePaths: true), // Enable merge paths
      //           ),
      //         ),
      //         SizedBox(height: 8,),
      //         Text('Tap The Menu Button',style: TextStyle(
      //           fontFamily: 'Cera Pro',
      //           fontWeight: FontWeight.w400
      //         ),)
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
  