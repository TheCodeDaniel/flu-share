part of 'file_receive_bloc.dart';

abstract class FileReceiveState {}

class FileReceiveInitial extends FileReceiveState {}

class FileReceiveLoading extends FileReceiveState {}

class FileReceiveDiscoverable extends FileReceiveState {
  final String message;
  FileReceiveDiscoverable(this.message);
}

class FileReceiveError extends FileReceiveState {
  final String error;
  FileReceiveError(this.error);
}
