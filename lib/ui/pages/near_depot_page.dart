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
                          locationBloc: locationBloc,
                          transactionBloc: transactionBloc,
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
