import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/models.dart' as model;
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _textFieldController = TextEditingController();
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    this._userBloc = BlocProvider.of<UserBloc>(context);

    var name = this._userBloc.state.name;
    this._textFieldController.text = name;
  }

  @override
  void dispose() {
    super.dispose();

    _textFieldController.dispose();
  }

  void saveAction() async {
    if (this._formKey.currentState.validate()) {
      this._userBloc.add(model.User(name: this._textFieldController.text));
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
                top: 70.0, bottom: 30.0, left: 30.0, right: 30.0),
            decoration: Style.containerDecoration,
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
                    BlocListener<UserBloc, model.User>(
                      listener: (context, user) {
                        if (user is model.UserError) {
                          showSnackbar(context, 'Ups, ada yang salah');
                        } else if (user is model.UserSuccess) {
                          Navigator.pop(context);

                          showSnackbar(context, 'Ubah nama berhasil');
                        }
                      },
                      child: BlocBuilder<UserBloc, model.User>(
                        builder: (context, user) {
                          return ElevatedButton(
                            onPressed: user is model.UserLoading
                                ? () {}
                                : this.saveAction,
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: user is model.UserLoading
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text('Simpan',
                                        textAlign: TextAlign.center),
                                  ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    OutlinedButton(
                      onPressed: this.logOutAction,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
        ),
      ),
    );
  }
}
