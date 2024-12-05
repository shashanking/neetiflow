part of 'client_bloc.dart';

@freezed
class ClientEvent with _$ClientEvent {
  const factory ClientEvent.watchAllStarted() = _WatchAllStarted;
}
