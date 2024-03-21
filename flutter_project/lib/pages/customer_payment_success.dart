import 'package:flutter/material.dart';
import 'package:flutter_project/pages/admnvieweventbooking.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_project/pages/customviewbookingdetails.dart';

class paymentsuccess extends StatefulWidget {
  const paymentsuccess({super.key});

  @override
  State<paymentsuccess> createState() => _paymentsuccessState();
}

class _paymentsuccessState extends State<paymentsuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'animations/payment_success.json',
              width: 220,
              height: 220,
              repeat: true, // Set to true for looping
              reverse: false, // Set to true to play the animation in reverse
              animate: true, // Set to false to freeze the animation
              options:
                  LottieOptions(enableMergePaths: true),
               // Enable merge paths
            ),
            Text("Successful !!",style: TextStyle(fontFamily: 'Cera Pro'),)
            ,
            SizedBox(height: 10,),
            Text("Your payment was done successfully",style: TextStyle(fontFamily: 'Cera Pro'),),
            SizedBox(height: 15,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)
                )
              ),
              onPressed: (){
                Navigator.pop(context);
              }, child: Text("ok"))
          ],
        ),
      ),
    );
  }
}