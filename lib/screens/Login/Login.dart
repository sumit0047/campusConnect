import 'package:campus_connect/screens/Landing.dart';
import 'package:campus_connect/screens/Login/components/OTPTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _verificationId;
  bool _otpValidate = false;

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  verifyPhoneNumber() async{

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return LandingScreen();
      }));
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
      setState(() {
        _otpValidate = true;
      });
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91'+phoneController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
    }
  }

  TextEditingController _firstDigitController = new TextEditingController();
  TextEditingController _secondDigitController = new TextEditingController();
  TextEditingController _thirdDigitController = new TextEditingController();
  TextEditingController _fourthDigitController = new TextEditingController();
  TextEditingController _fifthDigitController = new TextEditingController();
  TextEditingController _sixthDigitController = new TextEditingController();

  void signInWithPhoneNumber(String code) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      showSnackbar("Successfully signed in UID: ${user.uid}");
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return LandingScreen();
      }));
    } catch (e) {
      showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff292931),
      body: _otpValidate==false?Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text("Welcome!",style: TextStyle(color: Colors.white,fontSize: 24,fontFamily: 'Montserrat'),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40,top: 20),
            child: Text("Sign in to continue",style: TextStyle(color: Colors.white54,fontSize: 18,fontFamily: 'Montserrat'),),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width *0.85,
              color: Colors.white10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("+91 ",style: TextStyle(color: Colors.white54,fontFamily: 'Montserrat',letterSpacing: 4,fontWeight: FontWeight.bold,fontSize: 16)),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white54,fontFamily: 'Montserrat',letterSpacing: 4,fontWeight: FontWeight.bold,fontSize: 16),
                        decoration: new InputDecoration(
                          fillColor: Colors.white54,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
              constraints: const BoxConstraints(
                  maxWidth: 500
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(text: 'We will send you an ', style: TextStyle(color: Colors.white54)),
                  TextSpan(
                      text: 'One Time Password ', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'on this mobile number', style: TextStyle(color: Colors.white54)),
                ]),
              )),
    SizedBox(
      height: size.height * 0.02,
    ),
    Container(
    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    constraints: const BoxConstraints(
    maxWidth: 500
    ),
    child: RaisedButton(
    onPressed: ()async {
    if (phoneController.text.isNotEmpty) {
        verifyPhoneNumber();
    } else {

    }
    },
    color: Colors.indigo,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
    child: Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
    Text(
    'Next',
    style: TextStyle(color: Colors.white),
    ),
    Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    color: Colors.indigoAccent,
    ),
    child: Icon(
    Icons.arrow_forward_ios,
    color: Colors.white,
    size: 16,
    ),
    )
    ],
    ),
    ),
    ),
    ),
          SizedBox(
            height: size.height * 0.03,
          ),
          /*Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(text: "Don't have an account? ", style: TextStyle(color: Colors.white54)),
                TextSpan(text: 'Sign Up', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              ]),
            ),
          )*/
    ],
      ):Column(
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
      ),
    );
  }
}
