import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/client.dart';

import '../../../domain/repositories/clients_repository.dart';

part 'client_bloc.freezed.dart';
part 'client_event.dart';
part 'client_state.dart';

@injectable
class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientsRepository _clientRepository;

  ClientBloc(this._clientRepository) : super(const ClientState.initial()) {
    on<ClientEvent>((event, emit) async {
      await event.map(
        watchAllStarted: (e) async {
          emit(const ClientState.loadInProgress());
          await emit.forEach(
            _clientRepository.watchClients('current-org-id'), // TODO: Get actual org ID
            onData: (List<Client> clients) => ClientState.loadSuccess(clients),
            onError: (error, stackTrace) => const ClientState.loadFailure(),
          );
        },
      );
    });
  }
}
