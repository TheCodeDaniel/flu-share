import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/file_receive_repository.dart';

part 'file_receive_event.dart';
part 'file_receive_state.dart';

class FileReceiveBloc extends Bloc<FileReceiveEvent, FileReceiveState> {
  final FileReceiveRepository _repository;

  FileReceiveBloc(this._repository) : super(FileReceiveInitial()) {
    on<StartReceiving>(_onStartReceiving);
    on<StopReceiving>(_onStopReceiving);
  }

  Future<void> _onStartReceiving(
    StartReceiving event,
    Emitter<FileReceiveState> emit,
  ) async {
    emit(FileReceiveLoading());
    try {
      await _repository.makeDeviceDiscoverable();
      emit(FileReceiveDiscoverable("Device is now discoverable with token."));
    } catch (e) {
      emit(FileReceiveError("Error: $e"));
    }
  }

  Future<void> _onStopReceiving(
    StopReceiving event,
    Emitter<FileReceiveState> emit,
  ) async {
    _repository.stopDiscovery();
    emit(FileReceiveInitial());
  }
}
