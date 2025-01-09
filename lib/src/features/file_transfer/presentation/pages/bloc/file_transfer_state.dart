import '../../../domain/entities/device.dart';

class FileTransferState {
  final List<Device> devices;
  final String? errorMessage;

  FileTransferState({
    this.devices = const [],
    this.errorMessage,
  });

  FileTransferState copyWith({
    List<Device>? devices,
    String? errorMessage,
  }) {
    return FileTransferState(
      devices: devices ?? this.devices,
      errorMessage: errorMessage,
    );
  }
}
