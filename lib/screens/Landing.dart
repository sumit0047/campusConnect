import 'package:campus_connect/ClubsPanel/addEvent.dart';
import 'package:campus_connect/screens/Register/Registration.dart';
import 'package:campus_connect/screens/Welcome/welcome_screen.dart';
import 'package:campus_connect/screens/drawerItems/Events.dart';
import 'package:campus_connect/screens/drawerItems/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Events", Icons.event),
    new DrawerItem("Clubs", Icons.event_seat),
    new DrawerItem("Settings", Icons.settings),
  ];

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class _LandingScreenState extends State<LandingScreen> {

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  bool hasOrganizerPerms = false;

  @override
  void initState() {
    var uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      if(!value.exists)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return Registration();
        }));
    });
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => setState(() {
      value['orgid']=='null'?hasOrganizerPerms=false:hasOrganizerPerms=true;})
    );
    super.initState();
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new Events();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff36393f),
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: <TextSpan>[
            TextSpan(text: 'CAMPUS', style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w700,color: Colors.white,fontSize: 20),),
            TextSpan(
                text: 'CONNECT', style: TextStyle(fontFamily: 'Montserrat',color: Colors.white,fontSize: 20),),
          ]),
        ),
        backgroundColor: Color(0xff2f3136),
        actions: <Widget>[
        ],
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      drawer : SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Drawer(
          // header
          child: Column(
            children: <Widget>[
              Container(
                height : MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.55,
                color: const Color(0xff2f3136),
                child: Column(
                  children: <Widget>[
                  ],
                ),
              ),


              Container(
                  height : MediaQuery.of(context).size.height * 0.65,
                  color: const Color(0xff2f3136),
                  child:
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.drawerItems.length,
                      itemBuilder: (BuildContext contxt, int Index) {
                        return new
                        Container(
                          decoration: BoxDecoration(
                            color: _selectedDrawerIndex == Index? Color(0xff36393f) : Color(0xff2f3136),
                          ),
                          child: ListTile(
                            title: new Text(widget.drawerItems[Index].title,style: TextStyle(color: Colors.white70),),
                            leading: new Icon(widget.drawerItems[Index].icon,color: Colors.white70,),
                            selected: Index == _selectedDrawerIndex,
                            onTap: () => _onSelectItem(Index),
                          ),
                        );
                      }
                  )


              ),
              // Footer
              Container(
                  height : MediaQuery.of(context).size.height * 0.10,
                  child: Container(
                      color: const Color(0xff2f3136),
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff2f3136),
                            ),
                            child: ListTile(
                              title: new Text('Logout',style: TextStyle(color: Colors.white70),),
                              leading: new Icon(Icons.exit_to_app,color: Colors.white70,),
                              onTap: () async{
                                _signOut();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                  return WelcomeScreen();
                                }));
                              },
                            ),
                          )
                        ],
                      )
                  )

              )
            ],
          ),
        ),
      ),
    floatingActionButton: hasOrganizerPerms?Builder(
    builder: (context) => FabCircularMenu(
    key: fabKey,
    // Cannot be `Alignment.center`
    alignment: Alignment.bottomRight,
    ringColor: Colors.white.withAlpha(25),
    ringDiameter: 500.0,
    ringWidth: 150.0,
    fabSize: 64.0,
    fabElevation: 8.0,
    fabIconBorder: CircleBorder(),
    // Also can use specific color based on wether
    // the menu is open or not:
    // fabOpenColor: Colors.white
    // fabCloseColor: Colors.white
    // These properties take precedence over fabColor
    fabColor: Colors.white,
    fabOpenIcon: Icon(Icons.menu, color: Colors.indigo),
    fabCloseIcon: Icon(Icons.close, color: Colors.indigo),
    fabMargin: const EdgeInsets.all(16.0),
    animationDuration: const Duration(milliseconds: 400),
    animationCurve: Curves.easeInOutCirc,
    onDisplayChange: (isOpen) {

    },
    children: <Widget>[
    RawMaterialButton(
    onPressed: () {

    },
    shape: CircleBorder(),
    padding: const EdgeInsets.all(24.0),
    child: Icon(Icons.settings, color: Colors.white),
    ),
    RawMaterialButton(
    onPressed: () {

    },
    shape: CircleBorder(),
    padding: const EdgeInsets.all(24.0),
    child: Icon(Icons.person_outline, color: Colors.white),
    ),
    RawMaterialButton(
    onPressed: () {
      fabKey.currentState.close();
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return AddEvent();
      }));
    },
    shape: CircleBorder(),
    padding: const EdgeInsets.all(24.0),
    child: Icon(Icons.add, color: Colors.white),
    ),
    RawMaterialButton(
    onPressed: () {

    fabKey.currentState.close();

    },
    shape: CircleBorder(),
    padding: const EdgeInsets.all(24.0),
    child: Icon(Icons.edit, color: Colors.white),
    )
    ],
    ),
    ):null
    );
  }
}
