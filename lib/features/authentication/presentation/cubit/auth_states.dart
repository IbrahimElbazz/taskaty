import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/user_model.dart';

part 'auth_states.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  
  const factory AuthState.loading() = _Loading;
  
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  
  const factory AuthState.unauthenticated() = _Unauthenticated;
  
  const factory AuthState.error(String message) = _Error;
}
