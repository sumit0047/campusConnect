import 'package:campus_connect/screens/Login/components/OTPTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPVerification extends StatefulWidget {
  final String _verificationId;
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
  OTPVerification(this._verificationId);
}

class _OTPVerificationState extends State<OTPVerification> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _firstDigitController;
  TextEditingController _secondDigitController;
  TextEditingController _thirdDigitController;
  TextEditingController _fourthDigitController;
  TextEditingController _fifthDigitController;
  TextEditingController _sixthDigitController;

  void signInWithPhoneNumber(String code) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget._verificationId,
        smsCode: code,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      print("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      print("Failed to sign in: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          SizedBox(
            height: size.height * 0.3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Enter the verification code sent to your number",style: TextStyle(color: Colors.white70,fontSize: 18,fontFamily: 'Montserrat'),),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OTPTextField(first: true, last: false,textEditingController: _firstDigitController,),
              OTPTextField(first: false, last: false,textEditingController: _secondDigitController,),
              OTPTextField(first: false, last: false,textEditingController: _thirdDigitController,),
              OTPTextField(first: false, last: false,textEditingController: _fourthDigitController,),
              OTPTextField(first: false, last: false,textEditingController: _fifthDigitController,),
              OTPTextField(first: false, last: true,textEditingController: _sixthDigitController,),
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            constraints: const BoxConstraints(
                maxWidth: 500
            ),
            child: RaisedButton(
              onPressed: () {
                    signInWithPhoneNumber(_firstDigitController.text+_secondDigitController.text+_thirdDigitController.text+_fourthDigitController.text+_fifthDigitController.text+_sixthDigitController.text);
              },
              color: Colors.indigo,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Confirm', style: TextStyle(color: Colors.white),),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: Colors.indigoAccent,
                      ),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}
