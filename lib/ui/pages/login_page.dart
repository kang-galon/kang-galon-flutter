import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kang_galon/core/services/user_service.dart';
import 'package:kang_galon/ui/pages/register_page.dart';
import 'package:kang_galon/ui/pages/verification_otp_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();
  bool _loading = false;
  String _errorText = '';
  String _phoneNumber;

  void loginAction() async {
    if (this._formKey.currentState.validate()) {
      setState(() {
        this._loading = true;
      });
      String phoneNumber = '+62' + this._phoneNumber;

      // Check user is doesn't exist
      bool isUserExist = await userService.isUserExist(phoneNumber);
      if (!isUserExist) {
        return setState(() {
          this._loading = false;
          this._errorText = 'Nomor belum terdaftar';
        });
      }

      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationFailed: (FirebaseAuthException error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP gagal dikirim')),
          );

          setState(() {
            _loading = false;
          });
        },
        codeSent: (String verificationId, int forceResendingToken) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP berhasil dikirim')),
          );

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
  }

  void registerAction() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Registerpage()),
    );
  }

  void phoneNumberChange(String str) {
    setState(() {
      _phoneNumber = str;
    });
  }

  String phoneNumberValidator(String value) {
    if (value.isEmpty) {
      return 'Fill this field';
    }

    if (value.length < 11) {
      return 'Min 11 number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Form(
                          key: this._formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                maxLength: 11,
                                keyboardType: TextInputType.number,
                                onChanged: this.phoneNumberChange,
                                validator: this.phoneNumberValidator,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  errorText: this._errorText,
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
                                  onPressed:
                                      this._loading ? () {} : this.loginAction,
                                  child: this._loading
                                      ? SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 3.0,
                                          ),
                                        )
                                      : Text('Masuk'),
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
                    TextButton(
                      onPressed: this._loading ? () {} : this.registerAction,
                      child: Text('Daftar'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(0.0)),
                        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                      ),
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
