import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payment {
  final String packid;
  final String packname;
  final String packamount;

  Payment({
    required this.packid,
    required this.packname,
    required this.packamount,
  });
}

class staffPaymentView extends StatefulWidget {
  final String ipAddress;
  final String pid;

  staffPaymentView({required this.ipAddress, required this.pid});

  @override
  _StaffPaymentViewState createState() => _StaffPaymentViewState();
}

class _StaffPaymentViewState extends State<staffPaymentView> {
  List<Payment> paymentList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPayments(widget.pid);
  }

  Future<void> fetchPayments(String pid) async {
    final String url = 'http://${widget.ipAddress}/staffgetpayment?pid=$pid';
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final paymentsData = jsonData["result"] as List<dynamic>;
          setState(() {
            paymentList = paymentsData.map((data) {
              return Payment(
                packid: data['package_id']?.toString() ?? 'N/A',
                packname: data['package_name']?.toString() ?? 'N/A',
                packamount: data['package_amount']?.toString() ?? 'N/A',
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
       backgroundColor:Colors.purple,
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
          elevation: 10,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(4),
              color: Colors.purple.withOpacity(0.4)
              ),
              child: ListTile(
                title: Text(
                  'Package: ${payment.packname}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount:  ${payment.packamount}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
