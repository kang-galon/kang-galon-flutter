import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  UserState();
}

class UserUninitialized extends UserState {
  @override
  List<Object> get props => [];
}

class UserSuccess extends UserState {
  final String name;

  UserSuccess({this.name});

  @override
  List<Object> get props => [];
}

class UserExist extends UserState {
  @override
  List<Object> get props => [];
}

class UserDoesntExist extends UserState {
  @override
  List<Object> get props => [];
}

class UserError extends UserState {
  final String message;

  UserError({this.message});

  @override
  List<Object> get props => [message];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}
