import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
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
    TransactionDetailBloc transactionDetailBloc =
        BlocProvider.of<TransactionDetailBloc>(context);

    // get detail transaction
    transactionDetailBloc.add(TransactionFetchDetail(id: id));

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Style.mainPadding,
          child: BlocBuilder<TransactionDetailBloc, TransactionState>(
            builder: (context, event) {
              if (event is TransactionFetchDetailSuccess) {
                return Column(
                  children: [
                    HeaderBar(
                      onPressed: () => _backAction(context),
                      label: 'Transaksi ${event.transaction.depotName}',
                    ),
                    SizedBox(height: 20.0),
                    DepotDescription(
                      depot: event.transaction.depot,
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
                            '${event.transaction.depot.priceDesc} ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('x ${event.transaction.gallon} Gallon'),
                          Expanded(
                            child: Text(
                              event.transaction.totalPriceDescription,
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
                        event.transaction.statusDescription,
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
        ),
      ),
    );
  }
}
