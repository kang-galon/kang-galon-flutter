import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kang_galon/pages/splash_page.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationOtpPage extends StatefulWidget {
  @override
  _VerificationOtpPageState createState() => _VerificationOtpPageState();
}

class _VerificationOtpPageState extends State<VerificationOtpPage> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  void pinSubmitAction(String pin) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SplashPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                width: 100.0,
                height: 100.0,
                fit: BoxFit.fill,
                image: AssetImage('assets/images/verification.png'),
              ),
            ),
            Text(
              'Verification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('Enter OTP code sent to your number +628123123'),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 70.0, right: 70.0),
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 1.0,
                            blurRadius: 5.0,
                            offset: Offset(1, 2),
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 30.0,
                      ),
                      child: PinPut(
                        fieldsCount: 4,
                        onSubmit: pinSubmitAction,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        submittedFieldDecoration: _pinPutDecoration,
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.deepPurpleAccent.withOpacity(.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
