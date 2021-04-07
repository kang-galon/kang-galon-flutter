import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kang_galon/core/services/user_service.dart';
import 'package:kang_galon/ui/pages/login_page.dart';
import 'package:kang_galon/ui/pages/verification_otp_page.dart';
import 'package:kang_galon/ui/widgets/snackbar.dart';

class Registerpage extends StatefulWidget {
  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();
  String _phoneNumber, _name;
  String _errorText = '';
  bool _loading = false;

  void registerAction() async {
    if (this._formKey.currentState.validate()) {
      // set loading
      setState(() {
        _loading = true;
      });

      String phoneNumber = '+62' + this._phoneNumber;

      // Check user is exist
      bool isUserExist = await userService.isUserExist(phoneNumber);
      if (isUserExist) {
        return setState(() {
          this._loading = false;
          this._errorText = 'Nomor sudah terdaftar';
        });
      }

      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationFailed: (FirebaseAuthException error) {
          showSnackbar(context, 'OTP gagal dikirim');

          setState(() {
            _loading = false;
          });
        },
        codeSent: (String verificationId, int forceResendingToken) {
          showSnackbar(context, 'OTP berhasil dikirim');

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return VerificationOtpPage(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                name: this._name,
                isLogin: false,
              );
            },
          ));
        },
      );
    }
  }

  void loginAction() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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

  void nameChange(String str) {
    setState(() {
      _name = str;
    });
  }

  String nameValidator(String value) {
    return (value.isEmpty) ? 'Wajib diisi' : null;
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
                'Daftar dengan nomor ponsel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
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
                                onChanged: this.nameChange,
                                validator: this.nameValidator,
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: 'Nama',
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
                              SizedBox(height: 10.0),
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
                                  counterText: '',
                                  errorText: this._errorText,
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
                              SizedBox(height: 10.0),
                              ElevatedButton(
                                onPressed:
                                    this._loading ? () {} : this.registerAction,
                                child: this._loading
                                    ? SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          strokeWidth: 3.0,
                                        ),
                                      )
                                    : Text('Daftar'),
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
                    Text('Sudah punya akun ? '),
                    TextButton(
                      onPressed: this.loginAction,
                      child: Text('Login'),
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
