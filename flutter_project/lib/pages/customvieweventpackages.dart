import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(CustomerEventCategories());
// }

class EventPackage {
  final String id;
  final String cid;
  final String categoryname;
  final String foodname;
  final String qty;
  final String servingtype;
  final String packagename;
  final String packagedesc;
  final String packageamt;
  EventPackage(
      {required this.id,
      required this.cid,
      required this.categoryname,
      required this.foodname,
      required this.qty,
      required this.servingtype,
      required this.packagename,
      required this.packagedesc,
      required this.packageamt});
}

// class CustomerEventCategories extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CustomerEventCategoryPage(),
//     );
//   }
// }

class CustomerEventPackagePage extends StatefulWidget {
  final String ipAddress;
  CustomerEventPackagePage({required this.ipAddress});
  @override
  _CustomerEventPackagePageState createState() =>
      _CustomerEventPackagePageState();
}

class _CustomerEventPackagePageState extends State<CustomerEventPackagePage> {
  List<EventPackage> packageList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewPackages();
  }

  Future<void> viewPackages() async {
    final String url = 'http://${widget.ipAddress}/customerviewpackages';
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);

        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final categoriesData = jsonData["result"] as List<dynamic>;
          setState(() {
            packageList = categoriesData.map((data) {
              return EventPackage(
                  id: data['package_id']?.toString() ?? 'N/A',
                  cid: data['category_id']?.toString() ?? 'N/A',
                  categoryname: data['category_name']?.toString() ?? 'N/A',
                  foodname: data['food_name']?.toString() ?? 'N/A',
                  qty: data['quantity']?.toString() ?? 'N/A',
                  servingtype: data['serving_type']?.toString() ?? 'N/A',
                  packagename: data['package_name']?.toString() ?? 'N/A',
                  packagedesc: data['package_description']?.toString() ?? 'N/A',
                  packageamt: data['package_amount']?.toString() ?? 'N/A');
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No package data found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching packages';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, 
        centerTitle: true,
        title: Text('Event Packages'),
      ),
      body: Padding(  
        padding: const EdgeInsets.all(16.0),
        child: _buildPackageList(),
      ),
    );
  }

  Widget _buildPackageList() {
    return ListView.builder(
      itemCount: packageList.length,
      itemBuilder: (context, index) {
        final package = packageList[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
               color: Colors.purple.withOpacity(0.4)
              ),
              child: ListTile(
                title: Text(
                  '${package.categoryname}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera Pro',
                    color: Color.fromARGB(230, 0, 0, 0),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Package: ${package.packagename}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera Pro',)),
                    Text('Description: ${package.packagedesc}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera Pro',)),
                    Text('Food: ${package.foodname}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                    Text('Quantity: ${package.qty}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                    Text('Serving Type: ${package.servingtype}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                    Text('Amount: ${package.packageamt}',
                        style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                  ],
                ),
                onTap: () {
                  // Implement what should happen when a category is tapped by a customer
                  // For example, navigate to events in this category
                },
              ),
            ),
          ),
        );
      },
    );
  }
}