import 'package:flutter/material.dart';
import 'package:flutter_project/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(CustomerEventCategories());
// }

class EventCategory {
  final String id;
  final String categoryname;

  EventCategory({required this.id, required this.categoryname});
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

class CustomerEventCategoryPage extends StatefulWidget {
  final String ipAddress;
  CustomerEventCategoryPage({required this.ipAddress});
  @override
  _CustomerEventCategoryPageState createState() =>
      _CustomerEventCategoryPageState();
}

class _CustomerEventCategoryPageState extends State<CustomerEventCategoryPage> {
  List<EventCategory> categoryList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewCategories();
  }

  Future<void> viewCategories() async {
    final String url = 'http://${widget.ipAddress}/viewcategories';
    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        errorMessage = null;
        final jsonData = json.decode(response.body);

        if (jsonData.containsKey("result") && jsonData["result"] != null) {
          final categoriesData = jsonData["result"] as List<dynamic>;
          setState(() {
            categoryList = categoriesData.map((data) {
              return EventCategory(
                id: data['category_id']?.toString() ?? 'N/A',
                categoryname: data['category_name']?.toString() ?? 'N/A',
              );
            }).toList();
          });
        } else {
          setState(() {
            errorMessage = 'No category data found';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching categories';
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
        title: Text('Event Categories',style: TextStyle(fontFamily: 'Cera Pro'),),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildCategoryList(),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final category = categoryList[index];
        return SizedBox(height: 110,
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                 color: Colors.purple.withOpacity(0.5)
                ),
                child: ListTile(
                  title: Text(
                    '${category.categoryname}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                      fontFamily: 'Cera Pro'
                    ),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  onTap: () {
                    // Implement what should happen when a category is tapped by a customer
                    // For example, navigate to events in this category
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}