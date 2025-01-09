part of 'file_receive_bloc.dart';

abstract class FileReceiveEvent {}

class StartReceiving extends FileReceiveEvent {}

class StopReceiving extends FileReceiveEvent {}
