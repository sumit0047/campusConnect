import 'package:campus_connect/components/UpcomingEventCard.dart';
import 'package:campus_connect/constants/text_style.dart';
import 'package:campus_connect/models/Event.dart';
import 'package:campus_connect/screens/Events/EventDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<EventModel> events;
  getEventsList()async{
    var result = await FirebaseFirestore.instance.collection('events').get();
    events = result.docs.map((doc) => EventModel.fromMap(doc.data(), doc.id)).cast<EventModel>().toList();
    setState(() {
      events = this.events;
    });
  }

  @override
  void initState() {
    getEventsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        buildUpComingEventList(),
      ],
    );
  }

  Widget buildUpComingEventList() {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Popular",
              style: headerStyle.copyWith(color: Colors.white)),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 250,
            child: ListView.builder(
              itemCount: events.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final event = events[index];
                return UpComingEventCard(event,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                      return EventDetail(event);
                    })));
              },
            ),
          ),
        ],
      ),
    );
  }
}
