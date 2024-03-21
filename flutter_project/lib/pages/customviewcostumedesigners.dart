import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(CostumeDesigners());
// }

class CostumeDesigner {
  final String name;
  final String place;
  final String email;
  final String phone;

  CostumeDesigner(
      {required this.name,
      required this.place,
      required this.email,
      required this.phone});
}

// class CostumeDesigners extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CostumePage(),
//     );
//   }
// }

class CostumePage extends StatefulWidget {
  final String ipAddress;
  CostumePage({required this.ipAddress});

  @override
  _CostumePageState createState() => _CostumePageState();
}

class _CostumePageState extends State<CostumePage> {
  List<CostumeDesigner> costumeList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewCostume();
  }

  Future<void> viewCostume() async {
    final String url = 'http://${widget.ipAddress}/viewcostume';
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);

        if (jsonData.containsKey("res") && jsonData["res"] != null) {
          final CostumeData = jsonData["res"] as List<dynamic>;
          setState(() {
            costumeList = CostumeData.map((data) {
              return CostumeDesigner(
                name: data['name']?.toString() ?? 'N/A',
                place: data['place']?.toString() ?? 'N/A',
                email: data['email']?.toString() ?? 'N/A',
                phone: data['phone']?.toString() ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No Costume Designers found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching Costume Designers';
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
        title: Text('Costume Designers',style: TextStyle(fontFamily: 'Cera Pro'),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: costumeLis(),
      ),
    );
  }

  Widget costumeLis() {
    return ListView.builder(
      itemCount: costumeList.length,
      itemBuilder: (context, index) {
        final costume = costumeList[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
                    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
     color: Colors.purple.withOpacity(0.4)
    ),
            child: ListTile(
              title: Text('Designer Name: ${costume.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Cera Pro')),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Place: ${costume.place}', style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                  Text('Email: ${costume.email}', style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                  Text('Phone: ${costume.phone}', style: TextStyle(fontSize: 14,fontFamily: 'Cera Pro')),
                ],
              ),
              contentPadding: EdgeInsets.all(16),
              onTap: () {
                // Implement what should happen when a category is tapped by a customer
                // For example, navigate to events in this category
              },
            ),
          ),
        );
      },
    );
  }
}