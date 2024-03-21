import 'package:flutter/material.dart';
import 'package:flutter_project/pages/customer_payment_success.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_project/widgets/widgets.dart';

class PaymentForm extends StatefulWidget {
  final String ipAddress;
  final String packamount;
  PaymentForm({required this.ipAddress, required this.packamount});
  @override
  _PaymentFormState createState() => _PaymentFormState(); 
}

class _PaymentFormState extends State<PaymentForm> {
  String flaskServerUrl;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  TextEditingController NameController = TextEditingController();
  TextEditingController NumberController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String bookingStatus = '';

  _PaymentFormState() : flaskServerUrl = '';

  Future<void> makePaymentRequest(String packageAmount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authT = prefs.getString('bid');
    if (authT != null) {
      final Map<String, dynamic> requestBody = {
        'packageAmount': packageAmount,
      };

      try {
        final response = await http.post(
          Uri.parse('$flaskServerUrl/payment?authT=$authT'),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          print('paid successfully');
        } else {
          print('failed to pay');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.packamount);
    flaskServerUrl = 'http://${widget.ipAddress}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Payment Page",style: TextStyle(fontFamily: 'Cera Pro',),),
          backgroundColor:Colors.purple,  
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                         
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(borderRadius: BorderRadius.circular(28), child: Image(image: AssetImage("assets/image/Payment_page.jpg",))),
                    SizedBox(height: 15,),
                    Text(
                      "Cardholder's Name",
                      style:
                          TextStyle(fontSize: 18, fontFamily: 'Cera Pro'),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      controller: NameController,
                      decoration: TextInputDecoration.copyWith(
                        hintText: 'John Doe',
                        filled: true,
                        fillColor:Colors.purple.withOpacity(0.3),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 247, 235, 249),
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                      style: TextStyle(color: Colors.purple),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Card Number',
                      style:
                          TextStyle(fontSize: 18,fontFamily: 'Cera Pro'),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      controller: NumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      decoration: TextInputDecoration.copyWith(
                        hintText: '1234 5678 1234 4568',
                        filled: true,
                        fillColor: Colors.purple.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 232, 220, 234),
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      ),
                      style: TextStyle(color: Colors.purple),
                    ),
                    
                    Row(
                     
                      children: <Widget>[
                        Expanded(
                          child: Column(
                          
                            children: <Widget>[
                              Text(
                                'Expiry Date',
                                style: TextStyle(
                                  fontSize: 16,
                                fontFamily: 'Cera Pro'
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                controller: DateController,
                                decoration: InputDecoration(
                                  hintText: 'MM/YY',
                                  filled: true,
                                  fillColor: Colors.purple.withOpacity(0.4),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(
                                          255, 228, 220, 220),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 237, 232, 237),
                                    ),
                                  ),
                                  hintStyle:
                                      TextStyle(color: Colors.black.withOpacity(0.5)),
                                ),
                                style:
                                    TextStyle(color: Colors.purple),
                                validator: (value) {
                                  final RegExp regExp =
                                      RegExp(r'^\d{2}/\d{2}$');
                    
                                  if (!regExp.hasMatch(value!)) {
                                    return 'Invalid Date Format';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'CVV',
                                style: TextStyle(
                                    fontSize: 16,fontFamily: 'Cera Pro'),
                              ), 
                              SizedBox(height: 10,),   
                              TextFormField(
                                controller: cvvController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                decoration: InputDecoration(
                                  hintText: '123',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 219, 210, 210),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(
                                          255, 228, 220, 220),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 238, 234, 238),
                                    ),
                                  ),
                                  hintStyle:
                                      TextStyle(color: const Color.fromARGB(255, 235, 232, 236)),
                                ),
                                style:
                                    TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Amount',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Cera Pro'),
                              ),
                              SizedBox(height: 5,),
                              TextFormField(
                                controller: _controller,
                                enabled: false,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.purple.withOpacity(0.4), // Set the background color
                                    border: OutlineInputBorder(
                                      // Set the rectangular border
                                      borderRadius: BorderRadius.circular(
                                          12.0), // Adjust the radius as needed
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255,
                                              228,
                                              220,
                                              220)), // Set the border color
                                    ),
                                    focusedBorder:
                                        UnderlineInputBorder(
                                      // Set the border when focused
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 235, 232, 235)), // Set the border color
                                    ),
                                    hintStyle: TextStyle(
                                        color: const Color.fromARGB(255, 240, 235, 241))),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10,),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                            
                          ),backgroundColor: Colors.purple
                        ),
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            String packageAmount = widget.packamount;
                            makePaymentRequest(packageAmount);
                            NameController.clear();
                            NumberController.clear();
                            DateController.clear();
                            cvvController.clear();
                            _controller.clear();
                            //  await updatePaymentStatus(
                            //            widget.proposalid);

                            Navigator.push(context, MaterialPageRoute(builder: (context) => paymentsuccess(),));
                          }
                        },
                        child: Text('Pay Now',
                            style: TextStyle(color: Pallete.whiteColor)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}