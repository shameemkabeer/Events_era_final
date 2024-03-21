import 'package:flutter/material.dart';
import 'package:flutter_project/pages/customer_payment_success.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:flutter_project/widgets/widgets.dart';

class cuseventpaymentForm extends StatefulWidget {
  final String ipAddress;
  final String cuseventamount;
  final String cuseventid;
  final String proposalid;

  cuseventpaymentForm(
      {required this.ipAddress,
      required this.cuseventamount,
      required this.cuseventid,
      required this.proposalid});

  @override
  _cuseventpaymentFormState createState() => _cuseventpaymentFormState();
}

class _cuseventpaymentFormState extends State<cuseventpaymentForm> {
  String flaskServerUrl;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  TextEditingController NameController = TextEditingController();
  TextEditingController NumberController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String bookingStatus = '';

  _cuseventpaymentFormState() : flaskServerUrl = '';
  Future<void> makePaymentRequest(String cuseventamount) async {
    String proposalid = widget.proposalid;

    final Map<String, dynamic> requestBody = {
      'cuseventamount': cuseventamount,
      'proposalid': proposalid,
    };

    final response = await http.post(
      Uri.parse('$flaskServerUrl/customeventpayment'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('payid')) {
        String payid = responseData['payid'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('payid', payid);

        print('Paid successfully. Payment ID: $payid');
      } else {
        print('Failed to pay');
      }
    }
  }

// Your "Pay Now" button onPressed handler remains the same

  Future<void> updatePaymentStatus(String proposalid) async {
    String cuseventid = widget.cuseventid;
    try {
      final response = await http.post(
        Uri.parse('$flaskServerUrl/update_status'),
        body: jsonEncode({'proposalid': proposalid, 'cuseventid': cuseventid}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Status updated to "paid"');
      } else {
        print('Failed to update status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.cuseventamount);
    flaskServerUrl = 'http://${widget.ipAddress}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
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
                        onPressed: ()async {
                          if (_formKey.currentState!.validate()) {
                            String packageAmount = widget. cuseventamount;
                            makePaymentRequest(packageAmount);
                            NameController.clear();
                            NumberController.clear();
                            DateController.clear();
                            cvvController.clear();
                            _controller.clear();
                            await updatePaymentStatus(
                                       widget.proposalid);

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
      ),);
    //   resizeToAvoidBottomInset: false,
    //   appBar: AppBar(
    //     backgroundColor:Colors.purple,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Container(
    //       width: MediaQuery.of(context).size.width,
    //       height: MediaQuery.of(context).size.height,
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: [
    //             Color.fromARGB(255, 185, 132, 187), // First shade color
    //             Color.fromARGB(255, 212, 204, 204).withOpacity(0.6)
    //                 .withOpacity(0.0), // Adjust the opacity (0.5 in this case)
    //           ],
    //           stops: [0.15, 1.0], // Adjust the stops as needed
    //         ),
    //       ),
    //       padding: EdgeInsets.all(20.0),
    //       child: Form(
    //         key: _formKey,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             SingleChildScrollView(
    //               child: Container(
    //                 padding: EdgeInsets.all(20),
    //                 child: Text(
    //                   'Payment Page',
    //                   style: TextStyle(
    //                     color: Color.fromARGB(255, 6, 13, 90),
    //                     fontSize: 24,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 20,
    //             ),
    //             Center(
    //               child: Container(
    //                 width: 700,
    //                 child: Card(
    //                   color: Colors.white,
    //                   elevation: 20,
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(30),
    //                   ),
    //                   shadowColor: Color.fromARGB(255, 185, 132, 187),
    //                   child: SingleChildScrollView(
    //                     child: Container(
    //                       padding: EdgeInsets.all(20.0),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: <Widget>[
    //                           SizedBox(height: 16),
    //                           Text(
    //                             "Cardholder's Name",
    //                             style:
    //                                 TextStyle(fontSize: 18, color: Colors.grey),
    //                           ),
    //                           TextFormField(
    //                             controller: NameController,
    //                             decoration: InputDecoration(
    //                               hintText: 'John Doe',
    //                               filled: true,
    //                               fillColor: Color.fromARGB(255, 244, 238, 238),
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(12.0),
    //                                 borderSide: BorderSide(
    //                                   color: Color.fromARGB(255, 228, 220, 220),
    //                                 ),
    //                               ),
    //                               focusedBorder: UnderlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(12.0),
    //                                 borderSide: BorderSide(
    //                                   color: Color.fromARGB(255, 234, 230, 235),
    //                                 ),
    //                               ),
    //                               hintStyle: TextStyle(color: const Color.fromARGB(255, 240, 239, 241)),
    //                             ),
    //                             style: TextStyle(color: Colors.purple),
    //                           ),
    //                           SizedBox(height: 16),
    //                           Text(
    //                             'Card Number',
    //                             style:
    //                                 TextStyle(fontSize: 18, color: Colors.grey),
    //                           ),
    //                           TextFormField(
    //                             controller: NumberController,
    //                             maxLength: 16,
    //                             decoration: InputDecoration(
    //                               hintText: '1234 5678 9012 3456',
    //                               filled: true,
    //                               fillColor: Color.fromARGB(255, 244, 238, 238),
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(12.0),
    //                                 borderSide: BorderSide(
    //                                   color: Color.fromARGB(255, 228, 220, 220),
    //                                 ),
    //                               ),
    //                               focusedBorder: UnderlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(12.0),
    //                                 borderSide: BorderSide(
    //                                   color: const Color.fromARGB(255, 234, 232, 235),
    //                                 ),
    //                               ),
    //                               hintStyle: TextStyle(color: const Color.fromARGB(255, 238, 231, 239)),
    //                             ),
    //                             style: TextStyle(color: Colors.purple),
    //                           ),
    //                           SizedBox(height: 16),
    //                           Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: <Widget>[
    //                               Expanded(
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Expiry Date',
    //                                       style: TextStyle(
    //                                         fontSize: 18,
    //                                         color: Colors.grey,
    //                                       ),
    //                                     ),
    //                                     TextFormField(
    //                                       controller: DateController,
    //                                       decoration: InputDecoration(
    //                                         hintText: 'MM/YY',
    //                                         filled: true,
    //                                         fillColor: Color.fromARGB(
    //                                             255, 244, 238, 238),
    //                                         border: OutlineInputBorder(
    //                                           borderRadius:
    //                                               BorderRadius.circular(12.0),
    //                                           borderSide: BorderSide(
    //                                             color: Color.fromARGB(
    //                                                 255, 228, 220, 220),
    //                                           ),
    //                                         ),
    //                                         focusedBorder: UnderlineInputBorder(
    //                                           borderRadius:
    //                                               BorderRadius.circular(12.0),
    //                                           borderSide: BorderSide(
    //                                             color: const Color.fromARGB(255, 234, 231, 234),
    //                                           ),
    //                                         ),
    //                                         hintStyle:
    //                                             TextStyle(color: const Color.fromARGB(255, 231, 226, 231)),
    //                                       ),
    //                                       style:
    //                                           TextStyle(color: Colors.purple),
    //                                       validator: (value) {
    //                                         final RegExp regExp =
    //                                             RegExp(r'^\d{2}/\d{2}$');

    //                                         if (!regExp.hasMatch(value!)) {
    //                                           return 'Invalid Date Format';
    //                                         }
    //                                         return null;
    //                                       },
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               SizedBox(width: 13),
    //                               Expanded(
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'CVV',
    //                                       style: TextStyle(
    //                                           fontSize: 18, color: Colors.grey),
    //                                     ),
    //                                     TextFormField(
    //                                       controller: cvvController,
    //                                       maxLength: 3,
    //                                       decoration: InputDecoration(
    //                                         hintText: '123',
    //                                         filled: true,
    //                                         fillColor: Color.fromARGB(
    //                                             255, 244, 238, 238),
    //                                         border: OutlineInputBorder(
    //                                           borderRadius:
    //                                               BorderRadius.circular(12.0),
    //                                           borderSide: BorderSide(
    //                                             color: Color.fromARGB(
    //                                                 255, 228, 220, 220),
    //                                           ),
    //                                         ),
    //                                         focusedBorder: UnderlineInputBorder(
    //                                           borderRadius:
    //                                               BorderRadius.circular(12.0),
    //                                           borderSide: BorderSide(
    //                                             color: Color.fromARGB(255, 240, 235, 240),
    //                                           ),
    //                                         ),
    //                                         hintStyle:
    //                                             TextStyle(color: const Color.fromARGB(255, 246, 243, 247)),
    //                                       ),
    //                                       style:
    //                                           TextStyle(color: Colors.purple),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               SizedBox(width: 16),
    //                               Expanded(
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: <Widget>[
    //                                     Text(
    //                                       'Amount',
    //                                       style: TextStyle(
    //                                           fontSize: 18, color: Colors.grey),
    //                                     ),
    //                                     TextFormField(
    //                                       controller: _controller,
    //                                       enabled: false,
    //                                       decoration: InputDecoration(
    //                                           filled: true,
    //                                           fillColor: Color.fromARGB(
    //                                               255,
    //                                               244,
    //                                               238,
    //                                               238), // Set the background color
    //                                           border: OutlineInputBorder(
    //                                             // Set the rectangular border
    //                                             borderRadius: BorderRadius.circular(
    //                                                 12.0), // Adjust the radius as needed
    //                                             borderSide: BorderSide(
    //                                                 color: Color.fromARGB(
    //                                                     255,
    //                                                     228,
    //                                                     220,
    //                                                     220)), // Set the border color
    //                                           ),
    //                                           focusedBorder:
    //                                               UnderlineInputBorder(
    //                                             // Set the border when focused
    //                                             borderRadius:
    //                                                 BorderRadius.circular(12.0),
    //                                             borderSide: BorderSide(
    //                                                 color: const Color.fromARGB(255, 246, 246, 246)), // Set the border color
    //                                           ),
    //                                           hintStyle: TextStyle(
    //                                               color: Color.fromARGB(255, 234, 210, 238))),
    //                                       style: TextStyle(
    //                                           fontSize: 20,
    //                                           fontWeight: FontWeight.bold,
    //                                           color: const Color.fromARGB(
    //                                               255, 213, 20, 6)),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           SizedBox(
    //                             height: 80,
    //                             width: 50,
    //                           ),
    //                           Center(
    //                             child: ElevatedButton(
    //                               style: ButtonStyle(
    //                                 minimumSize: MaterialStateProperty.all(
    //                                     Size(500, 50)),
    //                                 backgroundColor:
    //                                     MaterialStateProperty.all<Color>(
    //                                         Color.fromARGB(255, 249, 250, 251)),
    //                               ),
    //                               onPressed: () async {
    //                                 if (_formKey.currentState!.validate()) {
    //                                   String cusAmount = widget.cuseventamount;
    //                                   makePaymentRequest(cusAmount);
    //                                   NameController.clear();
    //                                   NumberController.clear();
    //                                   DateController.clear();
    //                                   cvvController.clear();
    //                                   _controller.clear();
    //                                   await updatePaymentStatus(
    //                                       widget.proposalid);
    //                                 }
    //                               },
    //                               child: Text('Pay Now',
    //                                   style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
  }
}
