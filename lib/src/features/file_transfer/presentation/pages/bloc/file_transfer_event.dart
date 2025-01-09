import '../../../domain/entities/device.dart';

abstract class FileTransferEvent {}

class ScanDevicesEvent extends FileTransferEvent {}

class SendFileEvent extends FileTransferEvent {
  final Device device;
  final String filePath;

  SendFileEvent(this.device, this.filePath);
}
