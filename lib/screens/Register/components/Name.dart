import 'dart:io';

import 'package:campus_connect/constants/text_style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NameRegister extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController usnController;
  final Function(String) onDataChange;
  final Function(bool) onPrefsChange;
  final int role;

  NameRegister(this.nameController,this.usnController,this.onDataChange,this.onPrefsChange,this.role);
  @override
  _NameRegisterState createState() => _NameRegisterState();
}

class _NameRegisterState extends State<NameRegister> {
  PickedFile profileImg;

  Future getImage(int type) async {
    PickedFile pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  var imageUrl;

  uploadPic() async {

    var uuid = Uuid();
    String fileName = uuid.v1();
    //Create a reference to the location you want to upload to in firebase
    var reference = FirebaseStorage.instance.ref().child("users/$fileName");

    //Upload the file to firebase
    var uploadTask = reference.putFile(File(profileImg.path));

    bool uploadComplete = false;
    // Waits till the file is uploaded then stores the download url
    var taskSnapShot = await uploadTask.whenComplete(() => uploadComplete = true);
    if(uploadComplete) {
      imageUrl = await reference.getDownloadURL();
    }
    widget.onDataChange(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Text('About You...',style: titleStyle,),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: ()async{
              final tmpFile = await getImage(2);
              setState(() {
                profileImg = tmpFile;
              });
              uploadPic();
            },
            child: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 45.0,
                backgroundImage: profileImg==null?AssetImage(
                  'assets/images/avatar.png',
                ):FileImage(File(profileImg.path)),
              ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width *0.85,
              color: Colors.white10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: widget.nameController,
                  keyboardType: TextInputType.text,

                  style: TextStyle(color: Colors.white54,fontFamily: 'Montserrat',letterSpacing: 4,fontWeight: FontWeight.bold,fontSize: 16),
                  decoration: new InputDecoration(
                    fillColor: Colors.white54,
                    border: InputBorder.none,
                    hintText: 'Your Name',
                    hintStyle: TextStyle(color: Colors.white24,fontFamily: 'Montserrat',letterSpacing: 4,fontWeight: FontWeight.bold,fontSize: 16),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width *0.85,
              color: Colors.white10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: widget.usnController,
                  keyboardType: TextInputType.text,

                  style: TextStyle(color: Colors.white54,fontFamily: 'Montserrat',letterSpacing: 4,fontWeight: FontWeight.bold,fontSize: 16),
                  decoration: new InputDecoration(
                    fillColor: Colors.white54,
                    border: InputBorder.none,
                    hintText: 'Your USN',
                    hintStyle: TextStyle(color: Colors.white24,fontFamily: 'Montserrat',letterSpacing: 4,fontWeight: FontWeight.bold,fontSize: 16),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          if(widget.role==1)_buildStrictlyOrganizerText(),
        ],
      ),
    );
  }
  Widget _buildStrictlyOrganizerText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        GestureDetector(
          onTap: (){
            widget.onPrefsChange(true);
          },
          child: Text(
            'Create Strictly an Organizer Account?',
            style: subtitleStyle,
          ),
        ),
      ],
    );
  }
}
