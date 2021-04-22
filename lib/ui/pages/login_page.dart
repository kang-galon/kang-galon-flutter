import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  void _loginAction(UserBloc userBloc) {
    if (_formKey.currentState.validate()) {
      String phoneNumber = '+62' + _textEditingController.text;

      // Check user is exist
      UserIsExist userIsExist = UserIsExist(phoneNumber: phoneNumber);
      userBloc.add(userIsExist);
    }
  }

  void _registerAction(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _sendOtp(BuildContext context, UserBloc userBloc) async {
    String phoneNumber = '+62' + _textEditingController.text;

    // send otp
    await userBloc.sendOtp(
      phoneNumber,
      (error) {
        showSnackbar(context, 'OTP gagal dikirim');
      },
      (verificationId, forceResendingToken) {
        showSnackbar(context, 'OTP berhasil dikirim');

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return VerificationOtpPage(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              name: '',
              isLogin: true,
            );
          },
        ));
      },
    );
  }

  String _phoneNumberValidator(String value) {
    if (value.isEmpty) {
      return 'Wajib diisi';
    }

    if (value.length < 11) {
      return 'Min 11 number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                'Masuk dengan nomor ponsel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Masukkan nomor ponsel Anda\nkami akan mengirimkan OTP untuk memverifikasi',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              BlocConsumer<UserBloc, UserState>(
                                listener: (context, state) {
                                  if (state is UserExist) {
                                    _sendOtp(context, userBloc);
                                  }
                                },
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: _textEditingController,
                                    maxLength: 11,
                                    keyboardType: TextInputType.number,
                                    validator: _phoneNumberValidator,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    decoration: InputDecoration(
                                      errorText: (state is UserDoesntExist)
                                          ? 'Nomor belum terdaftar'
                                          : '',
                                      counterText: '',
                                      prefixIcon: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 5, 15),
                                        child: Text(
                                          '+62',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      filled: true,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: BlocBuilder<UserBloc, UserState>(
                                  builder: (context, state) {
                                    if (state is UserLoading) {
                                      return ElevatedButton(
                                          onPressed: () {},
                                          child: SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                              strokeWidth: 3.0,
                                            ),
                                          ));
                                    } else {
                                      return ElevatedButton(
                                        onPressed: () => _loginAction(userBloc),
                                        child: Text('Masuk'),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun ? '),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return TextButton(
                          onPressed: (state is UserLoading)
                              ? () {}
                              : () => _registerAction(context),
                          child: Text('Daftar'),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0.0)),
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size.zero),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
