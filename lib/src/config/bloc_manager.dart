import 'package:flushare/src/features/file_transfer/presentation/pages/file_transfer_bloc/file_transfer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class BlocManager {
  static List<SingleChildWidget> blocProviders = [
    BlocProvider(
      create: (context) => FileTransferBloc(),
    )
  ];
}
