part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}


final class RegisterLoading extends AppState{}
final class RegisterSuccessfully extends AppState{
}
final class RegisterError extends AppState{
  final String message;
  RegisterError({required this.message});
}

final class LoginLoading extends AppState{}
final class LoginSuccessfully extends AppState{}
final class LoginError extends AppState{
  final String message;
  LoginError({required this.message});
}

final class GetImageSuccessfully extends AppState{}
final class GetImageError extends AppState{}

final class CroppedSuccessfully extends AppState{}
final class CroppedError extends AppState{}