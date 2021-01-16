import 'package:flutter/material.dart';

class OTPTextField extends StatelessWidget {
  final bool first;
  final bool last;
  final TextEditingController textEditingController;
  const OTPTextField(
      {Key key, @required this.first, @required this.last, @required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length == 0 && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        controller: textEditingController,
        readOnly: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(color: Colors.white54,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 16),
        decoration: InputDecoration(
          counter: Offstage(),
          hintText: "*",
          hintStyle: TextStyle(color: Colors.white24,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 16),
        ),
      ),
    );
  }
}