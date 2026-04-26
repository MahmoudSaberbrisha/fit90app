part of 'spa_cubit.dart';

abstract class SpaState {}

class SpaInitial extends SpaState {}

class FetchLoading extends SpaState {
  FetchLoading();
}

class FetchSuccessful extends SpaState {
  final SpaList data;
  FetchSuccessful(this.data);
}

class FetchFailed extends SpaState {
  final String message;
  FetchFailed(this.message);
}

