import 'package:equatable/equatable.dart';

abstract class FileTransferEvent extends Equatable {
  const FileTransferEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverDevices extends FileTransferEvent {}
