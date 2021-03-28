import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kang_galon/pages/verification_otp_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'asdasdasd',
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void continueAction() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VerificationOtpPage();
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
                image: AssetImage('assets/images/phone.png'),
              ),
            ),
            Text(
              'Login With Mobile Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                  'Enter you mobile number we will sent you OTP to verify'),
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
                      child: Column(
                        children: [
                          TextFormField(
                            maxLength: 11,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                                child: Text(
                                  '+62',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              onPressed: continueAction,
                              child: Text('Continue'),
                            ),
                          ),
                        ],
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
