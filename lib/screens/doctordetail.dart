import 'dart:convert';
import 'package:flutter/material.dart';
import 'appointmentscreen.dart';
import 'package:http/http.dart' as http;

class DoctorDetail extends StatefulWidget {
  final Map  doc;


  DoctorDetail( this.doc,);

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  List doctors = [];
  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future getdata() async {
    var res = await http.post(Uri.parse(
        "https://loopdevloper.com/SuffaTech/Rehanmuzammal/practics/docterdetail.php"));

    var data = jsonDecode(res.body);

    setState(() {
      doctors = data ?? [];
    });
  }


  @override
  Widget build(BuildContext context) {

    String image = widget.doc['image']?.toString() ?? '';
    String name = widget.doc['name']?.toString() ?? 'No Name';
    String detail = widget.doc['detail']?.toString() ?? 'No Detail';
    String id = widget.doc['id']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Doctor Detail"),
      centerTitle: true,),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image.isNotEmpty
                ? Image.network(image)
                : Icon(Icons.image, size: 100),

            Text(name, style: TextStyle(fontSize: 22)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: List.generate(
                    5,
                        (index) =>
                        Icon(Icons.star, color: Colors.yellow)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Instruction",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),

            Text(detail, style: TextStyle(fontSize: 15)),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentScreen(
                      image: image,
                      name: name,
                      id: id,
                    ),
                  ),
                );
              },
              child: Text("Book Appointment",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
    );
  }
}