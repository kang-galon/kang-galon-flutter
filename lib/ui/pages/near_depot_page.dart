import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class NearDepotPage extends StatefulWidget {
  @override
  _NearDepotPageState createState() => _NearDepotPageState();
}

class _NearDepotPageState extends State<NearDepotPage> {
  void _detailDepotAction(Depot depot) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => DepotPage(depot: depot)));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: Pallette.contentPadding.copyWith(bottom: 0),
              sliver: SliverToBoxAdapter(
                child: HeaderBar(label: 'Depot disekitar anda'),
              ),
            ),
            SliverPadding(
              padding: Pallette.contentPadding,
              sliver: BlocBuilder<DepotBloc, DepotState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (state is DepotFetchListSuccess) {
                          return DepotItem(
                            depot: state.depots[index],
                            onTap: () =>
                                _detailDepotAction(state.depots[index]),
                            isContainer: true,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      childCount: (state is DepotFetchListSuccess)
                          ? state.depots.length
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
