import 'package:firebase_auth/firebase_auth.dart' as Fire;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/user.dart';
import 'package:kang_galon/core/viewmodels/user_bloc.dart';
import 'package:kang_galon/ui/pages/account_page.dart';
import 'package:kang_galon/ui/pages/order_page.dart';
import 'package:kang_galon/ui/widgets/depot_item.dart';
import 'package:kang_galon/ui/widgets/home_button.dart';

class HomePage extends StatelessWidget {
  void allDepotAction(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderPage()));
  }

  void accountAction(BuildContext context, UserBloc userBloc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: userBloc,
            child: AccountPage(),
          ),
        ));
  }

  void chatAction(BuildContext context, UserBloc userBloc) async {
    print(Fire.FirebaseAuth.instance.currentUser.uid);
    print(await Fire.FirebaseAuth.instance.currentUser.getIdToken());
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<UserBloc, User>(
                            builder: (context, user) =>
                                Text('Hai, ${user.name}')),
                        Divider(
                          thickness: 3.0,
                          height: 20.0,
                          color: Colors.grey.shade400,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            HomeButton(
                              label: 'Riwayat',
                              icon: Icons.history,
                              onPressed: () {
                                print('Riwayat');
                              },
                            ),
                            HomeButton(
                              label: 'Akun',
                              icon: Icons.person,
                              onPressed: () =>
                                  this.accountAction(context, userBloc),
                            ),
                            HomeButton(
                              label: 'Chat',
                              icon: Icons.article,
                              onPressed: () =>
                                  this.chatAction(context, userBloc),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
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
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        OutlinedButton(
                          onPressed: () => this.allDepotAction(context),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            elevation: MaterialStateProperty.all<double>(2.0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.local_drink),
                                Text(
                                  'Semua depot',
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.east),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return DepotItem();
                          },
                          itemCount: 5,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
