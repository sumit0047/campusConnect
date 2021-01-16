import 'package:campus_connect/constants/colors.dart';
import 'package:campus_connect/screens/Landing.dart';
import 'package:campus_connect/screens/Register/components/Name.dart';
import 'package:campus_connect/screens/Register/components/OrganizerInfo.dart';
import 'package:campus_connect/screens/Register/components/Role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Registration extends StatefulWidget{
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  int role = -1;
  var profileImg;
  var orgImg;
  var strictOrg = false;

  var nameController = new TextEditingController();
  var usnController = new TextEditingController();
  var orgTitleController = new TextEditingController();
  var orgSubtitleController = new TextEditingController();
  var currentPageValue =0;

  PageController _registerController = PageController(
    initialPage: 0,
  );

  void gotoNextPage(){
    if(currentPageValue == 0){
      if(role!=-1)
        _registerController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    }
    if(currentPageValue == 2&&role==1){
      if(orgTitleController.text.length>0&&orgSubtitleController.text.length>0&&orgImg!=null)
        submitUserInfo();
    }
    if(currentPageValue==1){
      if(nameController.text.length>0&&usnController.text.length>0&&profileImg!=null){
        if(role ==1)
        _registerController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
        else
          submitUserInfo();
      }
    }
  }

  void submitUserInfo() async{
    print('submitting');
    var uid = FirebaseAuth.instance.currentUser.uid;
    var phone = FirebaseAuth.instance.currentUser.phoneNumber;
    var uuid = Uuid();
    var orgid = uuid.v1();
    await FirebaseFirestore.instance.collection('users').doc(uid)
        .set({"uid" : uid,"name" : strictOrg?'null':nameController.text,"usn" : strictOrg?'null':usnController.text,"phone" : phone,"orgid" : role==0?'null':orgid,"image" : strictOrg?'null':profileImg});
    if(role ==1)
    await FirebaseFirestore.instance.collection('organizers').doc(orgid)
        .set({"name" : orgTitleController.text,"tagline" : orgSubtitleController.text,"image" : orgImg});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return LandingScreen();
    }));
  }

  void onRoleDataChange(int newData) {
    setState(() {
      role = newData;
    });
    print(role);
  }

  void onProfileDataChange(String newData) {
    setState(() {
      profileImg = newData;
    });
    print(profileImg);
  }

  void onOrgDataChange(String newData) {
    setState(() {
      orgImg = newData;
    });
    print(orgImg);
  }

  void onOrgPrefsChange(bool newData) {
    setState(() {
      strictOrg = true;
    });
    print(strictOrg);
    _registerController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  void initState() {
    _registerController.addListener(() {
      setState(() {
        print(_registerController.page);
        currentPageValue = _registerController.page.floor();
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Text(
            'Complete your profile',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Montserrat'),
          ),
          Container(
            child: Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _registerController,
                children: [
                  Role(onRoleDataChange),
                  NameRegister(nameController,usnController,onProfileDataChange,this.onOrgPrefsChange,role),
                  if(role==1)OrganizerInfo(orgTitleController, orgSubtitleController,onOrgDataChange),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){gotoNextPage();},
        label: currentPageValue==2?Text('Finish'):currentPageValue==1&&role==0?Text('Finish'):Text('Next'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}
