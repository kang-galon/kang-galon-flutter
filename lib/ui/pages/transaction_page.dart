import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class TransactionPage extends StatelessWidget {
  final int id;

  TransactionPage({@required this.id});

  void _backAction(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    // get detail transaction
    transactionBloc.add(TransactionFetchDetail(id: id));

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Style.mainPadding,
          child: BlocBuilder<TransactionBloc, Transaction>(
            builder: (context, transaction) {
              if (transaction is TransactionFetchDetailSuccess) {
                return Column(
                  children: [
                    HeaderBar(
                      onPressed: () => _backAction(context),
                      label: 'Transaksi ${transaction.transaction.depotName}',
                    ),
                    SizedBox(height: 20.0),
                    DepotDescription(
                      depot: transaction.depot,
                      isDistance: false,
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20.0),
                      decoration: Style.containerDecoration,
                      child: Row(
                        children: [
                          Text(
                            '${transaction.depot.priceDesc} ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('x ${transaction.transaction.gallon} Gallon'),
                          Expanded(
                            child: Text(
                              transaction.transaction.totalPriceDescription,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20.0),
                      decoration: Style.containerDecoration,
                      child: Text(
                        transaction.transaction.statusDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }

              return SizedBox.shrink();
            },
          ),
          // DepotDescription(depot: ),
        ),
      ),
    );
  }
}
