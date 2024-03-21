import 'package:flutter/material.dart';
// import 'package:flutter_app/userhome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

class Reply {
  final String food;

  Reply({required this.food});
}

class foodlist extends StatefulWidget {
  final String ipAddress;
  final int cid;

  foodlist({required this.ipAddress,required this.cid});
  @override
  _foodlistState createState() => _foodlistState();
}

class _foodlistState extends State<foodlist> {
  List<Reply> replyList = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    viewacti();
  }

 Future<void> viewacti() async {
   final String url = 'http://${widget.ipAddress}/admviewfood?cid=${widget.cid}';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<String> foods = List<String>.from(jsonData['foods']);
      setState(() {
        replyList = foods.map((food) => Reply(food: food)).toList();
      });
    } else {
      setState(() {
        errorMessage = 'Error viewing foods';
      });
    }
  } catch (e) {
    print('Error: $e');
    setState(() {
      errorMessage = 'No foods found';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple, 
        title: Text('Food List',style: TextStyle(fontFamily: 'Cera Pro'),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildComplaintList(),
      ),
    );
  }

  Widget _buildComplaintList() {
    if (replyList.isEmpty) {
      return Center(
        child: errorMessage != null
            ? Text(errorMessage!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: replyList.length,
      itemBuilder: (context, index) {
        final Reply = replyList[index];

        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                   Color.fromARGB(255, 186, 113, 212),
                  Color.fromARGB(255, 255, 255, 255)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              title: Text('Food: ${Reply.food}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}
