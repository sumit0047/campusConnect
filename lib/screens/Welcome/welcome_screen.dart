import 'package:campus_connect/components/round_button.dart';
import 'package:campus_connect/screens/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff292931),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("CAMPUS",style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w700,color: Colors.white,fontSize: 28),),
            Text("CONNECT",style: TextStyle(fontFamily: 'Montserrat',color: Colors.white,fontSize: 28),)
          ],
        ),
        SizedBox(
          height: size.height * 0.05,
        ),
        Container(
          height: size.height * 0.35,
          child: Lottie.asset('assets/lottie/air.json'),
        ),
        SizedBox(
          height: size.height * 0.15,
        ),
        Center(
          child: RoundButton(
            color: Colors.indigo,
            text: "GET STARTED",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Login();
              }));
            }
          )
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    )
    );
  }
}
