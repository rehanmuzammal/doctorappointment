import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Docterreview extends StatefulWidget {
  String doctorid;
   Docterreview({super.key,required this.doctorid});

  @override
  State<Docterreview> createState() => _DocterreviewState();
}

class _DocterreviewState extends State<Docterreview> {
  double rating = 0;
  TextEditingController review = TextEditingController();

  Future insertdata()async{
   var  res = await http.post(Uri.parse("https://loopdevloper.com/SuffaTech/Rehanmuzammal/practics/doctoreview.php"),
   body: {
     "rating": rating.toString(),
     "review": review.text,
      "doctorid" : widget.doctorid,
   }
   );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Product Rating"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
          children: [

            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Container(
              width: 350,
              child: TextField(
                controller: review,
                decoration: InputDecoration(
                  label: Text("Write Review"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                insertdata();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Rating Submitted"),
                  ),
                );

              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}



