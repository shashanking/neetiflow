part of 'client_bloc.dart';

@freezed
class ClientState with _$ClientState {
  const factory ClientState.initial() = _Initial;
  const factory ClientState.loadInProgress() = _LoadInProgress;
  const factory ClientState.loadSuccess(List<Client> clients) = _LoadSuccess;
  const factory ClientState.loadFailure() = _LoadFailure;
}
