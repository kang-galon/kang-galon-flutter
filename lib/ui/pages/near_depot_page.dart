import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class NearDepotPage extends StatelessWidget {
  void _backAction(BuildContext context) {
    Navigator.pop(context);
  }

  void _detailDepotAction(BuildContext context, LocationBloc locationBloc,
      TransactionBloc transactionBloc, Depot depot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepotPage(depot: depot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: Style.mainPadding,
        child: Column(
          children: [
            HeaderBar(
              onPressed: () => _backAction(context),
              label: 'Depot disekitar anda',
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: Style.containerDecoration,
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
