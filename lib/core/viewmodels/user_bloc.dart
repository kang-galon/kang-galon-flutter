import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/user.dart' as My;
import 'package:kang_galon/core/services/user_service.dart';

class UserBloc extends Bloc<My.User, My.User> {
  final _userService = UserService();
  static String name = FirebaseAuth.instance.currentUser.displayName;

  UserBloc() : super(My.User(name: name));

  @override
  Stream<My.User> mapEventToState(My.User event) async* {
    yield My.UserLoading();

    try {
      // update name on server
      await this._userService.updateProfile(event.name);

      yield My.UserSuccess(name: event.name);
    } catch (e) {
      yield My.UserError();
    }
  }
}
