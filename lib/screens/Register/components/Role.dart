import 'package:campus_connect/constants/text_style.dart';
import 'package:flutter/material.dart';

class Role extends StatefulWidget {

  final Function(int) onDataChange;

  Role(this.onDataChange);

  @override
  _RoleState createState() => _RoleState();
}

class _RoleState extends State<Role> {

  void selectRole(int n)
  {
    setState(() {
      role = n;
    });
    widget.onDataChange(n);
  }

  bool selected = false;
  int role = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Text('Select Your Role',style: titleStyle,),
        SizedBox(
          height: 40,
        ),
        InkWell(
          onTap: ()=>{
            selectRole(0),
          },
          child: Container(
            width: 200,
            decoration: role==0?BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(5.0),
            ):BoxDecoration(
              border: Border.all(color: Colors.white70,),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 10),
              child: Center(child: Text('Participant',style: subtitleStyle)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: ()=>{
            selectRole(1),
          },
          child: Container(
            width: 200,
            decoration: role==1?BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(5.0),
            ):BoxDecoration(
              border: Border.all(color: Colors.white70,),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 10),
              child: Center(child: Text('Organizer',style: subtitleStyle)),
            ),
          ),
        ),
      ],
    );
  }
}
