import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class AccountPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _textFieldController = TextEditingController();

  void _setName(UserBloc userBloc) {
    UserState userState = userBloc.state;
    if (userState is UserSuccess) {
      var name = userState.name;
      _textFieldController.text = name;
    }
  }

  void _saveAction(UserBloc userBloc) async {
    if (_formKey.currentState.validate()) {
      userBloc.add(UserUpdate(name: _textFieldController.text));
    }
  }

  void _logOutAction(BuildContext context, UserBloc userBloc) {
    userBloc.logOUt();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    _setName(userBloc);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: Style.mainPadding,
            decoration: Style.containerDecoration,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _textFieldController,
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
                    BlocListener<UserBloc, UserState>(
                      listener: (context, user) {
                        if (user is UserError) {
                          showSnackbar(context, 'Ups, ada yang salah');
                        } else if (user is UserSuccess) {
                          Navigator.pop(context);

                          showSnackbar(context, 'Ubah nama berhasil');
                        }
                      },
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: (state is UserLoading)
                                ? () {}
                                : () => _saveAction(userBloc),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: (state is UserLoading)
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
                      onPressed: () => _logOutAction(context, userBloc),
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
