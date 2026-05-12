import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../docterreview.dart';

class Showdocterui extends StatefulWidget {
  const Showdocterui({super.key});

  @override
  State<Showdocterui> createState() => _ShowdocteruiState();
}

class _ShowdocteruiState extends State<Showdocterui> {
  List doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future getdata() async {
    try {
      var res = await http.post(Uri.parse(
          "https://loopdevloper.com/SuffaTech/Rehanmuzammal/practics/showdoctor.php"));

      var data = jsonDecode(res.body);

      setState(() {
        doctors = data ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctors List"),
      centerTitle: true,),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctors.isEmpty
          ? const Center(child: Text("No Data Found"))
          : ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          var doc = doctors[index];

          String name = doc['name']?.toString() ?? 'No Name';
          String image = doc['image']?.toString() ?? '';
          String date = doc['bookdate']?.toString() ?? '';
          String time = doc['booktime']?.toString() ?? '';

           return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: image.isNotEmpty
                  ? Image.network(image, width: 60, fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 50),

              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: $date"),
                  Text("Time: $time"),
                ],
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.rate_review,
                  color: Colors.blue,
                ),

                onPressed: () {


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Docterreview(
                        doctorid: doc['id'].toString(),
                      ),
                    ),
                  );

                },
              ),
            ),
          );
        },
      ),
    );
  }
}