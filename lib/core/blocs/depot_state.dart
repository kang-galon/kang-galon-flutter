import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class DepotState extends Equatable {
  DepotState();
}

class DepotUninitialized extends DepotState {
  @override
  List<Object> get props => [];
}

class DepotEmpty extends DepotState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Tidak ada depot di sekitar anda';
  }
}

class DepotLoading extends DepotState {
  @override
  List<Object> get props => [];
}

class DepotError extends DepotState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Ups.. ada yang salah nih';
  }
}

class DepotFetchListSuccess extends DepotState {
  final List<Depot> depots;

  DepotFetchListSuccess({this.depots});

  @override
  List<Object> get props => [depots];
}
