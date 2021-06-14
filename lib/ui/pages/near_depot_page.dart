import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/arguments/arguments.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class NearDepotPage extends StatelessWidget {
  static const String routeName = '/near_depot';

  void _detailDepotAction(BuildContext context, LocationBloc locationBloc,
      TransactionBloc transactionBloc, Depot depot) {
    DepotArguments args = DepotArguments(depot);

    Navigator.pushNamed(context, DepotPage.routeName, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: Pallette.contentPadding,
        child: Column(
          children: [
            HeaderBar(
              label: 'Depot disekitar anda',
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: Pallette.containerDecoration,
              child: BlocConsumer<DepotBloc, DepotState>(
                listener: (context, state) {
                  if (state is DepotError) {
                    showSnackbar(context, state.toString());
                  }
                },
                builder: (context, state) {
                  if (state is DepotFetchListSuccess) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return DepotItem(
                          depot: state.depots[index],
                          onTap: () => _detailDepotAction(context, locationBloc,
                              transactionBloc, state.depots[index]),
                        );
                      },
                      itemCount: state.depots.length,
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
