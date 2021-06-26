import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late UserBloc _userBloc;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    // init bloc
    _userBloc = BlocProvider.of<UserBloc>(context);

    // init
    _formKey = GlobalKey();
    _textEditingController = TextEditingController();

    // set name
    UserState userState = _userBloc.state;
    if (userState is UserSuccess) {
      String name = userState.name;
      _textEditingController.text = name;
    }

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  String? _formValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }

    return null;
  }

  void _accountListener(BuildContext context, UserState state) {
    if (state is UserSuccess) {
      Navigator.pop(context);

      showSnackbar(context, 'Ubah nama berhasil');
    }
  }

  void _saveAction() {
    if (_formKey.currentState!.validate()) {
      _userBloc.add(UserUpdate(name: _textEditingController.text));
    }
  }

  void _logOutAction() {
    _userBloc.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: Pallette.contentPadding,
            decoration: Pallette.containerDecoration,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _textEditingController,
                      validator: _formValidator,
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
                    const SizedBox(height: 10.0),
                    BlocConsumer<UserBloc, UserState>(
                      listener: _accountListener,
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed:
                              (state is UserLoading) ? () {} : _saveAction,
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
                    const SizedBox(height: 10.0),
                    OutlinedButton(
                      onPressed: _logOutAction,
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
