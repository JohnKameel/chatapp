import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  AuthRepo authRepo;

  registerUser(String email, String password, String userName, String phoneNum,)async{
    emit(AuthLoading());
    final result = await authRepo.register(email, password, userName, phoneNum,);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(email: user!.email!)),
    );
  }

  loginUser(String email, String password)async{
    emit(AuthLoading());
    final result = await authRepo.login(email, password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(email: user!.email!)),
    );
  }

  void logoutUser() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      emit(AuthLogoutSuccess());
    } catch (e) {
      emit(AuthFailure('Logout failed'));
    }
  }
}
