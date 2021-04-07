import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/services/user_service.dart';
import 'package:kang_galon/core/viewmodels/user_bloc.dart';
import 'package:kang_galon/ui/pages/home_page.dart';
import 'package:kang_galon/ui/widgets/snackbar.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationOtpPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;
  bool isLogin = false;

  VerificationOtpPage({
    @required this.verificationId,
    @required this.phoneNumber,
    @required this.name,
    @required this.isLogin,
  });

  @override
  _VerificationOtpPageState createState() => _VerificationOtpPageState();
}

class _VerificationOtpPageState extends State<VerificationOtpPage> {
  final userService = UserService();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  Future<void> pinSubmitAction(String pin) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: pin,
    );

    try {
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
      var user = FirebaseAuth.instance.currentUser;
      String jwtToken = await user.getIdToken();
      String uid = user.uid;

      // Jika bukan register maka pass data to server
      if (!widget.isLogin) {
        // send data to server
        await userService.register(
            widget.phoneNumber, widget.name, uid, jwtToken);
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => UserBloc(),
          child: HomePage(),
        ),
      ));
    } on FirebaseException {
      showSnackbar(context, 'OTP tidak valid');
    } catch (e) {
      showSnackbar(context, e.toString());
    }
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
              child: Text(
                  'Enter OTP code sent to your number ' + widget.phoneNumber),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
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
                        fieldsCount: 6,
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
