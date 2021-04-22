import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationOtpPage extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;
  bool isLogin;

  VerificationOtpPage({
    @required this.verificationId,
    @required this.phoneNumber,
    @required this.name,
    this.isLogin = false,
  });

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  void _pinSubmitAction(String pin, UserBloc userBloc) {
    // if login
    if (isLogin) {
      UserLogin userLogin = UserLogin(pin: pin, verificationId: verificationId);

      userBloc.add(userLogin);
    } else {
      UserRegister userRegister = UserRegister(
        phoneNumber: phoneNumber,
        name: name,
        verificationId: verificationId,
        pin: pin,
      );

      userBloc.add(userRegister);
    }
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state is UserSuccess) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
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
              padding: EdgeInsets.only(top: 10.0),
              child: Text('Enter OTP code sent to your number ' + phoneNumber),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Wrap(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: Style.containerDecoration,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 30.0,
                      ),
                      child: BlocConsumer<UserBloc, UserState>(
                        listener: _blocListener,
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return Wrap(
                              alignment: WrapAlignment.center,
                              children: [CircularProgressIndicator()],
                            );
                          } else {
                            return PinPut(
                              fieldsCount: 6,
                              onSubmit: (pin) =>
                                  _pinSubmitAction(pin, userBloc),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              submittedFieldDecoration: _pinPutDecoration,
                              selectedFieldDecoration: _pinPutDecoration,
                              followingFieldDecoration:
                                  _pinPutDecoration.copyWith(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(.5),
                                ),
                              ),
                            );
                          }
                        },
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
