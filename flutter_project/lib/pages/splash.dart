import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the lottie package
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}
   
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navToMain(); // Load the saved IP address from shared preferences
  }

  _navToMain() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage( ipAddress:'172.20.10.3:5000',)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Color.fromARGB(255, 185, 132, 187),
      body: Center(    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'animations/splash2.json',
              height: 200,
              width: 220,
              fit: BoxFit.cover,
            ),   
//             SizedBox(height: 20),
//             Text(
//   "Events Of Era",
//   style: TextStyle(
//     fontSize: 35,
//     fontWeight: FontWeight.bold,
//     fontStyle: FontStyle.italic,
//     color: Color.fromARGB(255, 125, 183, 255), // Set the text color
//     letterSpacing: 1.5, // Set the letter spacing
//     shadows: [
//       Shadow(
//         blurRadius: 3.0,
//         color: Colors.black,
//         offset: Offset(2.0, 2.0),
//       ),
//     ],
//   ),
// ),

          ],
        ),
      ),
    );
  }
}