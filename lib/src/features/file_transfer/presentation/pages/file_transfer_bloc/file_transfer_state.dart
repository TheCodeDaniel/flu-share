import 'package:equatable/equatable.dart';

abstract class FileTransferState extends Equatable {
  const FileTransferState();

  @override
  List<Object?> get props => [];
}

class FileTransferInitial extends FileTransferState {}

class DeviceDiscoveryLoading extends FileTransferState {}

class DeviceDiscoverySuccess extends FileTransferState {
  final List<String> devices;

  const DeviceDiscoverySuccess(this.devices);

  @override
  List<Object?> get props => [devices];
}

class DeviceDiscoveryFailure extends FileTransferState {
  final String error;

  const DeviceDiscoveryFailure(this.error);

  @override
  List<Object?> get props => [error];
}
