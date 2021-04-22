import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class HistoryPage extends StatelessWidget {
  void _backAction(BuildContext context) {
    Navigator.pop(context);
  }

  void _detailTransactionAction(
      BuildContext context, TransactionBloc transactionBloc, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionPage(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    // fetch list transaction
    transactionBloc.add(TransactionFetchList());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Style.mainPadding,
          child: Column(
            children: [
              HeaderBar(
                onPressed: () => _backAction(context),
                label: 'Riwayat Transaksi',
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                decoration: Style.containerDecoration,
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, event) {
                    if (event is TransactionLoading) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: [CircularProgressIndicator()],
                      );
                    }

                    if (event is TransactionFetchListSuccess) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: event.transactions.length,
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transaction: event.transactions[index],
                            onTap: () => _detailTransactionAction(context,
                                transactionBloc, event.transactions[index].id),
                          );
                        },
                      );
                    }

                    if (event is TransactionEmpty) {
                      return Text(
                        event.toString(),
                        textAlign: TextAlign.center,
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
