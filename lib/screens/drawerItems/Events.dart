import 'package:campus_connect/components/EventCard.dart';
import 'package:campus_connect/constants/colors.dart';
import 'package:campus_connect/models/Event.dart';
import 'package:campus_connect/screens/Events/EventDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with TickerProviderStateMixin{
  List<EventModel> events;

  @override
  void initState() {
    getEventsList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getEventsList()async{
    var result = await FirebaseFirestore.instance.collection('events').get();
    events = result.docs.map((doc) => EventModel.fromMap(doc.data(), doc.id)).cast<EventModel>().toList();
    setState(() {
      events = this.events;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: TextField(
              style: TextStyle(color: Colors.white,fontSize: 24),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                border:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              color: bgColor,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Upcoming Events", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ListView.builder(
                  itemCount: events.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(
                          event,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                            return EventDetail(event);
                          })),
                        );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
