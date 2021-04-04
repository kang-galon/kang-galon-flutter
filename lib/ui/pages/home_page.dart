import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kang_galon/ui/pages/account_page.dart';
import 'package:kang_galon/ui/pages/order_page.dart';
import 'package:kang_galon/ui/widgets/depot_item.dart';
import 'package:kang_galon/ui/widgets/home_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name;

  @override
  void initState() {
    super.initState();

    var user = FirebaseAuth.instance.currentUser;
    this.name = user.displayName;
  }

  void allDepotAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderPage()));
  }

  void accountAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountPage()));
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hai, ' + this.name),
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
                              onPressed: this.accountAction,
                            ),
                            HomeButton(
                              label: 'Chat',
                              icon: Icons.article,
                              onPressed: () {},
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
                          onPressed: this.allDepotAction,
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
