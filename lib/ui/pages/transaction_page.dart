import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class TransactionPage extends StatefulWidget {
  final int id;
  TransactionPage({@required this.id});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  TransactionDetailBloc _transactionDetailBloc;

  @override
  void initState() {
    // init bloc
    _transactionDetailBloc = BlocProvider.of<TransactionDetailBloc>(context);

    // get detail transaction
    _transactionDetailBloc.add(TransactionFetchDetail(id: widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: Pallette.contentPadding,
            child: BlocConsumer<TransactionDetailBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionError) {
                  showSnackbar(context, state.toString());
                }
              },
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is TransactionFetchDetailSuccess) {
                  return Column(
                    children: [
                      HeaderBar(
                        label: 'Transaksi ${state.transaction.depotName}',
                      ),
                      const SizedBox(height: 20.0),
                      DepotDescription(
                        depot: state.transaction.depot,
                        isDistance: false,
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20.0),
                        decoration: Pallette.containerDecoration,
                        child: Row(
                          children: [
                            Text(
                              '${state.transaction.depot.priceDesc} ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('x ${state.transaction.gallon} Gallon'),
                            Expanded(
                              child: Text(
                                state.transaction.totalPriceDescription,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20.0),
                        decoration: Pallette.containerDecoration,
                        child: Text(
                          state.transaction.statusDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
