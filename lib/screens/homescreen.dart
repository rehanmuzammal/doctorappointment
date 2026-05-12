import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'doctordetail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController Searchdr = TextEditingController();
  List doctors = [];
  List doctors1 = [];

  @override
  void initState() {
    super.initState();
    getdata();
    rewiewdata();
  }
  void searchdr(){
    List d =[];
     d = doctors.where((item)=>item['name'].toString().toLowerCase().contains(Searchdr.text)).toList();
     setState(() {
       doctors1 = d;
     });
  }
  Future getdata() async {
    var res = await http.post(Uri.parse(
        "https://loopdevloper.com/SuffaTech/Rehanmuzammal/practics/docterdetail.php"));

    var data = jsonDecode(res.body);

    setState(() {
      doctors = data;
      doctors1 = data;
    });
  }
  List  data = [];
  Future rewiewdata()async{
    var res = await http.post(Uri.parse("https://loopdevloper.com/SuffaTech/Rehanmuzammal/practics/alldoctoreview.php"));
    var result = jsonDecode(res.body);
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  searchdr();
                },
                controller: Searchdr,
              decoration: InputDecoration(
                label: Text("Search"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                )
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildIcon(Icons.favorite,),
                  buildIcon(Icons.medical_services),
                  buildIcon(Icons.remove_red_eye),
                  buildIcon(Icons.psychology),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: doctors1.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: doctors1.length,
                  itemBuilder: (context, index) {
                    var doc = doctors1[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                          NetworkImage(doc['image']),
                        ),
                        title: Text(doc['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Specialist"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(doc['rating']),

                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 15,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ), onRatingUpdate: (double value) {  },

                            ),
                            doc['review']==null?Container():     Text(
                              "Review : ${doc['review']}",
                            ),
                          ],
                        ),
                          ],
                        ),

                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorDetail(doc
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget buildIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Color(0xFF2E86C1),
      radius: 28,
      child: Icon(icon, color: Colors.white),
    );
  }
}