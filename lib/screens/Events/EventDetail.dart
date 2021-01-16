import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:campus_connect/constants/colors.dart';
import 'package:campus_connect/constants/text_style.dart';
import 'package:campus_connect/models/Event.dart';
import 'package:campus_connect/utils/DateTimeUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventDetail extends StatefulWidget {
  final EventModel event;
  EventDetail(this.event);
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> with TickerProviderStateMixin{

  AnimationController controller;
  Animation<double> scale;
  AnimationController bodyScrollAnimationController;
  ScrollController scrollController;
  Animation<double> appBarSlide;
  bool isFavorite = false;
  bool isFollower = false;
  bool registered = false;
  bool loadedUserInfo = false;
  var authInstance = FirebaseAuth.instance;

  registerUser() async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('registered').doc(uid).set({"uid" : uid});
    setState(() {
      registered = true;
    });
  }

  likeEvent()async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('liked').doc(uid).set({"uid" : uid});
    setState(() {
      isFavorite = true;
    });
  }

  followOrganizer()async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('organizers').doc(widget.event.organizerId).collection('followers').doc(uid).set({"uid" : uid});
    setState(() {
      isFollower = true;
    });
  }

  unlikeEvent()async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('liked').doc(uid).delete();
    setState(() {
      isFavorite = false;
    });
  }

  unRegisterUser() async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('registered').doc(uid).delete();
    setState(() {
      registered = false;
    });
  }

  checkUserInfo() async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('registered').doc(uid).get().then((value) => value.exists?registered=true:registered=false);
    await FirebaseFirestore.instance.collection('events').doc(widget.event.id).collection('liked').doc(uid).get().then((value) => value.exists?isFavorite=true:isFavorite=false);
    await FirebaseFirestore.instance.collection('organizers').doc(widget.event.organizerId).collection('followers').doc(uid).get().then((value) => value.exists?isFollower=true:isFollower=false);
    setState(() {
      loadedUserInfo = true;
    });
  }

  unFollowOrganizer()async{
    var uid = authInstance.currentUser.uid;
    await FirebaseFirestore.instance.collection('organizers').doc(widget.event.organizerId).collection('followers').doc(uid).delete();
    setState(() {
      isFollower = false;
    });
  }

  addEventToCalendar(){
    final Event event = Event(
      title: widget.event.name,
      description: widget.event.description,
      location: widget.event.location,
      startDate: DateTime.parse(widget.event.eventDate),
      endDate: DateTime.parse(widget.event.eventDate)
    );
    Add2Calendar.addEvent2Cal(event);
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scale = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: controller,
    ));
    bodyScrollAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= MediaQuery.of(context).size.height * 0.2) {
          if (!bodyScrollAnimationController.isCompleted)
            bodyScrollAnimationController.forward();
        } else {
          if (bodyScrollAnimationController.isCompleted)
            bodyScrollAnimationController.reverse();
        }
      });

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController,
    ));
    checkUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children : [
        SingleChildScrollView(
          child: Column(
            children: [
              buildHeaderImage(),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEventTitle(),
                    SizedBox(
                      height: 12,
                    ),
                    buildEventDate(),
                    SizedBox(
                      height: 12,
                    ),
                    buildAboutEvent(),
                    SizedBox(
                      height: 12,
                    ),
                    buildOrganizeInfo(),
                  ],
                ),
              )
            ],
          ),
        ),
          Align(
            child: buildRegisterInfo(),
            alignment: Alignment.bottomCenter,
          ),
        ]
      ),
      
    );
  }

  Widget buildHeaderImage() {
    double maxHeight = MediaQuery.of(context).size.height;
    double minimumScale = 0.8;
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        controller.value += detail.primaryDelta / maxHeight * 2;
      },
      onVerticalDragEnd: (detail) {
        if (scale.value > minimumScale) {
          controller.reverse();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: maxHeight * 0.4,
            child: Hero(
              tag: widget.event.image,
              child: ClipRRect(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Image.network(
                  widget.event.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          buildHeaderButton(),
        ],
      ),
    );
  }

  Widget buildHeaderButton({bool hasTitle = false}) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              child: InkWell(
                onTap: () {
                  if (bodyScrollAnimationController.isCompleted)
                    bodyScrollAnimationController.reverse();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: hasTitle ? Colors.white : Colors.black,
                  ),
                ),
              ),
              color: hasTitle ? Theme.of(context).primaryColor : Colors.white,
            ),
            if (hasTitle)
              Text(widget.event.name, style: titleStyle.copyWith(color: Colors.white)),
            Card(
              shape: CircleBorder(),
              elevation: 0,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: () {
                  if(loadedUserInfo)
                isFavorite?unlikeEvent():likeEvent();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white),
                ),
              ),
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventTitle() {
    return Container(
      child: Center(
        child: Text(
          widget.event.name,
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),
        ),
      ),
    );
  }

  Widget buildEventDate() {
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
                Text("${DateTimeUtils.getMonth(DateTime.parse(widget.event.eventDate))}",
                    style: monthStyle),
                Text("${DateTimeUtils.getDayOfMonth(DateTime.parse(widget.event.eventDate))}",
                    style: titleStyle),
              ],
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(DateTimeUtils.getDayOfWeek(DateTime.parse(widget.event.eventDate)),
                  style: titleStyle),
              SizedBox(
                height: 4,
              ),
              Text(DateTimeUtils.getTime(DateTime.parse(widget.event.eventDate)), style: subtitleStyle),
            ],
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.all(2),
            decoration:
            ShapeDecoration(shape: StadiumBorder(), color: Colors.indigo),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Text("Add To Calendar",
                    style: subtitleStyle.copyWith(
                        color: Colors.white)),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.indigoAccent,
                  onPressed: () {
                    addEventToCalendar();
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("About", style: headerStyle),
        SizedBox(height: 8,),
        Text(widget.event.description, style: subtitleStyle),
        SizedBox(height: 8,),
      ],
    );
  }

  Widget buildOrganizeInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: Text(widget.event.organizer[0]),
        ),
        SizedBox(width: 16,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.event.organizer, style: titleStyle),
            SizedBox(
              height: 4,
            ),
            Text("Organizer", style: subtitleStyle),
          ],
        ),
        Spacer(),
        isFollower?FlatButton(
          child: Text("Followed",
              style: subtitleStyle),
          onPressed: () {
            unFollowOrganizer();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.indigoAccent)
          ),
        ):FlatButton(
          child: Text("Follow",
              style: subtitleStyle),
          onPressed: () {
            followOrganizer();
          },
          shape: StadiumBorder(),
          color: Colors.indigoAccent,
        )
      ],
    );
  }

  Widget buildRegisterInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      color: bgColor,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Fee", style: subtitleStyle),
              SizedBox(height: 8,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "\₹ ${widget.event.price}",
                        style: titleStyle),
                    TextSpan(
                        text: " / per person",
                        style: subtitleStyle),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          registered?RaisedButton(
            onPressed: (){
              if(loadedUserInfo)
              unRegisterUser();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.indigoAccent)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: bgColor,
            child: Text(
              "Registered",
              style: titleStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.normal),
            ),
          ):RaisedButton(
            onPressed: () {
              if(loadedUserInfo)
              registerUser();
            },
            shape: StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.indigoAccent,
            child: Text(
              "Register",
              style: titleStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}


