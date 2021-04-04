import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(top: 70.0, left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2.0,
                      blurRadius: 2.0,
                      offset: Offset(1, 2),
                    )
                  ],
                ),
                child: Text(
                  'Depot near you',
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2.0,
                      blurRadius: 2.0,
                      offset: Offset(1, 2),
                    )
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('asds'),
                    );
                  },
                  itemCount: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
