import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TransactionBloc _transactionBloc;

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

  void _transactionListener(BuildContext context, TransactionState state) {
    if (state is TransactionError) {
      showSnackbar(context, state.toString());
    }
  }

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
              sliver: BlocConsumer<TransactionBloc, TransactionState>(
                listener: _transactionListener,
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (state is TransactionLoading) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            children: [CircularProgressIndicator()],
                          );
                        }

                        if (state is TransactionFetchListSuccess) {
                          return TransactionItem(
                            transaction: state.transactions[index],
                            onTap: () => _detailTransactionAction(
                                state.transactions[index].id),
                          );
                        }

                        if (state is TransactionEmpty) {
                          return Text(
                            state.toString(),
                            textAlign: TextAlign.center,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                      childCount: (state is TransactionFetchListSuccess)
                          ? state.transactions.length
                          : 1,
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
