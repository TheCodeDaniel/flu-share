import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/file_transfer_bloc.dart';
import 'bloc/file_transfer_state.dart';

class DeviceScanView extends StatefulWidget {
  const DeviceScanView({super.key});

  @override
  State<DeviceScanView> createState() => _DeviceScanViewState();
}

class _DeviceScanViewState extends State<DeviceScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Nearby Devices"),
      ),
      body: BlocBuilder<FileTransferBloc, FileTransferState>(
        builder: (context, state) {
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }

          return ListView.builder(
            itemCount: state.devices.length,
            itemBuilder: (context, index) {
              final device = state.devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.ipAddress),
                onTap: () {
                  // Add sending logic here
                },
              );
            },
          );
        },
      ),
    );
  }
}
