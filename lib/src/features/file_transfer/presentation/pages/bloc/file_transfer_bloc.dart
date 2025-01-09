import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/network_service.dart';
import 'file_transfer_event.dart';
import 'file_transfer_state.dart';

class FileTransferBloc extends Bloc<FileTransferEvent, FileTransferState> {
  final NetworkService networkService;

  FileTransferBloc(this.networkService) : super(FileTransferState()) {
    on<ScanDevicesEvent>((event, emit) async {
      emit(state.copyWith(errorMessage: null));
      try {
        final devices = await networkService.scanDevices();
        emit(state.copyWith(devices: devices));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<SendFileEvent>((event, emit) async {
      emit(state.copyWith(errorMessage: null));
      try {
        await networkService
            .sendRequest(event.device.ipAddress, {'code': '123456'});
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });
  }
}
