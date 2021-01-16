import 'dart:io';

import 'package:campus_connect/components/TopContainer.dart';
import 'package:campus_connect/constants/colors.dart';
import 'package:campus_connect/models/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  PickedFile eventImg;
  String datetime;
  String userId;
  String orgId;
  String orgName;
  String imageURL;

  var nameController = new TextEditingController();
  var venueController = new TextEditingController();
  var descController = new TextEditingController();

  var autoValidate = false;

  final _formKey = GlobalKey<FormState>();

  String validateInput(String value) {
    if(value.isEmpty)
      return "This Field is Empty";
    else
      return null;
  }

  publishEvent(EventModel event){
    var result = FirebaseFirestore.instance.collection('events').add(event.toJson());
  }

  void _setAutoValidate() {
    setState(() {
      autoValidate = true;
    });
  }

  Future getImage(int type) async {
    PickedFile pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  uploadPic() async {

    var uuid = Uuid();
    String fileName = uuid.v1();
    var reference = FirebaseStorage.instance.ref().child("events/$fileName");
    var uploadTask = reference.putFile(File(eventImg.path));

    bool uploadComplete = false;
    var taskSnapShot = await uploadTask.whenComplete(() => uploadComplete = true);
    if(uploadComplete) {
      imageURL = await reference.getDownloadURL();
    }
  }

  getOrganizerInfo()async{
    userId = FirebaseAuth.instance.currentUser.uid;
    print(userId);
    await FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) => orgId = value['orgid']);
    await FirebaseFirestore.instance.collection('organizers').doc(orgId).get().then((value) => orgName = value['name']);
    print(orgName);
  }

  @override
  void initState() {
    super.initState();
    getOrganizerInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: autoValidate,
            child: Column(
              children: <Widget>[
                TopContainer(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                  width: size.width,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Create new Event',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Montserrat'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                minLines: 1,
                                maxLines: 1,
                                controller: nameController,
                                validator: validateInput,
                                decoration: InputDecoration(
                                    labelText: 'Event Name',
                                    labelStyle: TextStyle(color: Colors.white70),

                                    focusedBorder:
                                    UnderlineInputBorder(borderSide: BorderSide(
                                        color: Colors.white)),
                                    border:
                                    UnderlineInputBorder(borderSide: BorderSide(
                                        color: Colors.white70))),
                              ),
                            ],
                          )),
                      DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        dateMask: 'd MMM, yyyy',
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white70),
                            focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide(
                                color: Colors.white)),
                            border:
                            UnderlineInputBorder(borderSide: BorderSide(
                                color: Colors.white70))),
                        selectableDayPredicate: (date) {
                          return true;
                        },
                        onChanged: (val) {print(val);datetime = val;},
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => datetime = val,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        minLines: 1,
                        maxLines: 1,
                        controller: venueController,
                        validator: validateInput,
                        decoration: InputDecoration(
                            labelText: 'Venue',
                            labelStyle: TextStyle(color: Colors.white70),

                            focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide(
                                color: Colors.white)),
                            border:
                            UnderlineInputBorder(borderSide: BorderSide(
                                color: Colors.white70))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 100,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                    image: eventImg == null
                                        ? NetworkImage('https://via.placeholder.com/150')
                                        : FileImage(File(eventImg.path)),
                                    fit: BoxFit.cover)),
                          ),
                          OutlineButton(
                            splashColor: Colors.white70,
                            onPressed: () async{
                              final tmpFile = await getImage(2);
                              setState(() {
                                eventImg = tmpFile;
                              });
                              uploadPic();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            highlightElevation: 0,
                            borderSide: eventImg==null?BorderSide(color: Colors.white70):BorderSide(color: Colors.green),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Pick Event Cover",style: TextStyle(color: eventImg==null?Colors.white70:Colors.green,fontSize: 18,fontFamily: 'Montserrat')),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        minLines: 4,
                        maxLines: 10,
                        controller: descController,
                        validator: validateInput,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(color: Colors.white70),

                            focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide(
                                color: Colors.white)),
                            border:
                            UnderlineInputBorder(borderSide: BorderSide(
                                color: Colors.white70))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          if(_formKey.currentState.validate()){
            if(eventImg!=null){
              publishEvent(EventModel(name: nameController.text,description: descController.text,eventDate: datetime,location: venueController.text,organizer: orgName,organizerId: orgId,image: imageURL,price: '0'));
              Navigator.pop(context);
            }
          }
        },
        label: Text('Publish'),
        icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}