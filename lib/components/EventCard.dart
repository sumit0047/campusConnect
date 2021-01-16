import 'package:campus_connect/constants/text_style.dart';
import 'package:campus_connect/models/Event.dart';
import 'package:campus_connect/utils/DateTimeUtils.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {

  final EventModel event;
  final Function onTap;
  EventCard(this.event, {this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            buildImage(),
            buildEventInfo(context),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.black45,
        width: 80,
        height: 100,
        child: Hero(
          tag: event.image,
          child: Image.network(
            event.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildEventInfo(context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(DateTimeUtils.getFullDate(DateTime.parse(event.eventDate)), style: monthStyle),
          SizedBox(
            height: 4,
          ),
          Text(event.name, style: titleStyle),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
              Text(event.location.toUpperCase(), style: subtitleStyle),
            ],
          ),
        ],
      ),
    );
  }
}
