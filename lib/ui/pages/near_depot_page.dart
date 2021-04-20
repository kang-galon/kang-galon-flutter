import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<LocationBloc>.value(value: locationBloc),
            BlocProvider<TransactionBloc>.value(value: transactionBloc),
          ],
          child: DepotPage(depot: depot),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DepotBloc depotBloc = BlocProvider.of<DepotBloc>(context);
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
              child: BlocBuilder<DepotBloc, Depot>(
                bloc: depotBloc,
                builder: (context, depot) {
                  if (depot is DepotListSuccess) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return DepotItem(
                          depot: depot.depots[index],
                          onTap: () => _detailDepotAction(context, locationBloc,
                              transactionBloc, depot.depots[index]),
                        );
                      },
                      itemCount: depot.depots.length,
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
