import 'package:doctorappointment/screens/showdocterui.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:easy_date_timeline/easy_date_timeline.dart';
class AppointmentScreen extends StatefulWidget {
  final String image;
  final String name;
  final String id;

  const AppointmentScreen({
    super.key,
    required this.image,
    required this.name,
    required this.id,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime today = DateTime.now();

  List<String> timeSlots = [
    "9 - 12 AM",
    "12 - 01 PM",
    "01 - 02 PM",
    "03 - 04 PM",
  ];

  String selectedTime = '';
  int selectedIndex = -1;
  bool isLoading = false;

  Future makeBooking() async {
    if (selectedTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select time")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var res = await http.post(
        Uri.parse("https://loopdevloper.com/SuffaTech/Rehanmuzammal/practics/bookdetail.php"),
        body: {
          "doctorid": widget.id,
          "booktime": selectedTime,
          "bookdate": today.toString(),
        },
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment Booked Successfully")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Showdocterui()));
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointment")),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            widget.image.isNotEmpty
                ? Image.network(widget.image, height: 120)
                : const Icon(Icons.person, size: 100),

            const SizedBox(height: 10),

            Text(
              widget.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),


          EasyDateTimeLinePicker(
            focusedDate: today,
            firstDate: DateTime(2024, 3, 18),
            lastDate: DateTime(2030, 3, 18),
            onDateChange: (date) {
              today = date;
            },
          ),

            const SizedBox(height: 20),

            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = timeSlots[index];
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        timeSlots[index],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),


            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: makeBooking,
              child:  Text("Confirm Appointment",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}