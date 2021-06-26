import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    // init bloc
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);

    // fetch list transaction
    _transactionBloc.add(TransactionFetchList());

    super.initState();
  }

  void _detailTransactionAction(int id) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => TransactionPage(id: id)));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: Pallette.contentPadding.copyWith(bottom: 0),
              sliver: SliverToBoxAdapter(
                child: HeaderBar(
                  label: 'Riwayat Transaksi',
                ),
              ),
            ),
            SliverPadding(
              padding: Pallette.contentPadding,
              sliver: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (state is TransactionFetchListSuccess) {
                          Transaction transaction = state.transactions[index];

                          return TransactionItem(
                            transaction: transaction,
                            onTap: () =>
                                _detailTransactionAction(transaction.id),
                          );
                        }

                        if (state is TransactionEmpty) {
                          return Text(
                            'Anda belum memiliki transaksi',
                            textAlign: TextAlign.center,
                          );
                        }

                        return TransactionItem.loading();
                      },
                      childCount: (state is TransactionFetchListSuccess)
                          ? state.transactions.length
                          : (state is TransactionLoading)
                              ? 1
                              : 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
