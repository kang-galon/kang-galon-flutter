import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kang_galon/ui/pages/splash_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _textFieldController = TextEditingController();
  String _name;

  @override
  void initState() {
    super.initState();

    var user = FirebaseAuth.instance.currentUser;
    this._name = user.displayName;
    this._textFieldController.text = this._name;
  }

  @override
  void dispose() {
    super.dispose();

    _textFieldController.dispose();
  }

  void saveAction() {
    if (this._formKey.currentState.validate()) {
      print(this._textFieldController.text);
    }
  }

  void logOutAction() {
    FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: 70.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2.0,
                        blurRadius: 2.0,
                        offset: Offset(1, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: this._formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: this._textFieldController,
                            validator: (value) =>
                                value.isEmpty ? 'Tidak boleh kosong' : null,
                            decoration: InputDecoration(
                              hintText: 'nama',
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: this.saveAction,
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child:
                                  Text('Simpan', textAlign: TextAlign.center),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          OutlinedButton(
                            onPressed: this.logOutAction,
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: Colors.red)),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                'Log out',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red.shade400,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
