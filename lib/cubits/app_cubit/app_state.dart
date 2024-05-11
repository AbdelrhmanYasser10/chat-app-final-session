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
final class SetUserOffline extends AppState{}
final class SetUserOnline extends AppState{}


final class GetUserDataLoading extends AppState{}
final class GetUserDataSuccess extends AppState{}
final class GetUserDataError extends AppState{}

final class GetContactsLoading extends AppState{}
final class GetContactsSuccess extends AppState{}
final class GetContactsError extends AppState{}

final class SendMessageSuccess extends AppState{}
final class SendMessageError extends AppState{}

final class GetMessages extends AppState{}
