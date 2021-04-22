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
                child: BlocConsumer<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    if (state is TransactionError) {
                      showSnackbar(context, state.toString());
                    }
                  },
                  builder: (context, state) {
                    if (state is TransactionLoading) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: [CircularProgressIndicator()],
                      );
                    }

                    if (state is TransactionFetchListSuccess) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transaction: state.transactions[index],
                            onTap: () => _detailTransactionAction(context,
                                transactionBloc, state.transactions[index].id),
                          );
                        },
                      );
                    }

                    if (state is TransactionEmpty) {
                      return Text(
                        state.toString(),
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
