import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payment {
  final String payid;
  final String amount;
  final String date;

  Payment({
    required this.payid,
    required this.amount,
    required this.date,
  });
}

class stffviewproposalamount extends StatefulWidget {
  final String ipAddress;
  final String proposalid;

  stffviewproposalamount({
    required this.ipAddress,
    required this.proposalid,
  });

  @override
  _StaffPaymentViewState createState() => _StaffPaymentViewState();
}

class _StaffPaymentViewState extends State<stffviewproposalamount> {
  List<Payment> paymentList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    final String url = 'http://${widget.ipAddress}/staffgetproposalpayment';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'proposalid': widget.proposalid}),
      );

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final paymentsData = jsonData["result"] as List<dynamic>;
          setState(() {
            paymentList = paymentsData.map((data) {
              return Payment(
                payid: data['payment_id']?.toString() ?? 'N/A',
                amount: data['amount']?.toString() ?? 'N/A',
                date: data['date']?.toString() ?? 'N/A',
              );
            }).toList();
          });
        } else {
          errorMessage = 'No payment data found';
        }
      } else {
        errorMessage = 'Error viewing payments: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Payment Details',style: TextStyle(fontFamily: 'Cera Pro'),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildPaymentList(),
      ),
    );
  }

  Widget _buildPaymentList() {
    if (paymentList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: paymentList.length,
      itemBuilder: (context, index) {
        final payment = paymentList[index];
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
          child: Container(
            decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.4)
            ),
            child: ListTile(
              title: Text(
                'Amount: ${payment.amount}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date:  ${payment.date}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        );
      },
    );
  }
}