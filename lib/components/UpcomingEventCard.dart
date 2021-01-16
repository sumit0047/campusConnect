import 'package:campus_connect/constants/text_style.dart';
import 'package:campus_connect/models/Event.dart';
import 'package:campus_connect/utils/DateTimeUtils.dart';
import 'package:flutter/material.dart';

class UpComingEventCard extends StatelessWidget {
  final EventModel event;
  final Function onTap;
  UpComingEventCard(this.event, {this.onTap});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Expanded(child: buildImage()),
          SizedBox(
            height: 24,
          ),
          buildEventInfo(context),
        ],
      ),
    );
  }

  Widget buildImage() {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.grey,
          width: double.infinity,
          child: Hero(
            tag: event.image,
            child: Image.network(
              event.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventInfo(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("${DateTimeUtils.getMonth(DateTime.parse(event.eventDate))}", style: monthStyle),
                Text("${DateTimeUtils.getDayOfMonth(DateTime.parse(event.eventDate))}", style: titleStyle),
              ],
            ),
          ),
          SizedBox(width: 16,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.name, style: titleStyle),
              SizedBox(height: 4,),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
                  SizedBox(width: 4,),
                  Text(event.location.toUpperCase(), style: subtitleStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}