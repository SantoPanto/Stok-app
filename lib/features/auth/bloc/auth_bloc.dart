import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  // AuthRepository'i constructor üzerinden alıyoruz (Dependency Injection)
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        if (user.isApproved) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthPendingApproval());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signIn(email: event.email, password: event.password);
      if (user.isApproved) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthPendingApproval());
      }
    } catch (e) {
      emit(AuthError(message: "Giriş başarısız. Lütfen bilgilerinizi kontrol edin."));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
      // Kayıt başarılı olduğunda kullanıcı direkt "Onay Bekliyor" durumuna düşer
      emit(AuthPendingApproval());
    } catch (e) {
      emit(AuthError(message: "Kayıt işlemi başarısız oldu."));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}