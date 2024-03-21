import 'package:flutter/material.dart';
import 'package:flutter_project/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:flutter_project/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController? inputController;
  String? ipAddress;
  double rotationAngle = 0.0;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    loadIpAddress(); // Load the saved IP address from shared preferences
    _confettiController = ConfettiController();
  }

  // Function to load the IP address from shared preferences
  Future<void> loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = prefs.getString('ipAddress');
      if (ipAddress == null) {
        // If no IP address is saved, you can set a default value or leave it empty.
        ipAddress = '';
      }
      inputController!.text = ipAddress!;
    });
  }

  // Function to save the IP address to shared preferences
  Future<void> saveIpAddress(String ipAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
        ),
        backgroundColor: Pallete.whiteColor,
        // Color.fromARGB(223, 239, 229, 229),
        body: Stack(
          children: [
            // Image.asset(
            //   'assets/image/home_pic5.jpg',
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   fit: BoxFit.cover,
            // ),

            Container(
              color: Colors.grey.withOpacity(0.1),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Container(
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    maxBlastForce: 10,
                    minBlastForce: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Pallete.whiteColor,
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.only(top: 12),
                      height: 205,
                      width: 330,
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enter Your IP Address",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            SizedBox(
                              width: 310,
                              child: TextFormField(
                                controller: inputController,
                                decoration: TextInputDecoration.copyWith(
                                  filled: true,
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  hintText: 'Enter Your IP Address',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Pallete.blackColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Builder(
                              builder: (context) => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                onPressed: () {
                                  // ### DATA BASE ###//
                                  // saveIpAddress(
                                  //     inputController!.text); // Save the IP address
                                  // _confettiController
                                  //     .play(); // Trigger confetti animation
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Splash(),
                                  //   ),
                                  // );

                                  String ip = inputController!.text.trim();
                                  if (ip.isNotEmpty) {
                                    saveIpAddress(ip); // Save the IP address
                                    _confettiController.play();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Splash(),
                                      ),
                                    );
                                  } else {
                                    // showToast("Please enter a valid IP address");
                                    Fluttertoast.showToast(
                                        msg: "Sorry! Please Enter Your IP Address",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER);
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Pallete.whiteColor,
                                    fontFamily: 'Cera Pro',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
