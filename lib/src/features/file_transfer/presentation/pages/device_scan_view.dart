import 'package:flushare/src/core/constants/strings.dart';
import 'package:flushare/src/features/file_transfer/presentation/pages/bloc/file_transfer_event.dart';
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
      body: BlocConsumer<FileTransferBloc, FileTransferState>(
        listener: (context, state) {
          if (state is DeviceDiscoveryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is DeviceDiscoveryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DeviceDiscoverySuccess) {
            if (state.devices.isEmpty) {
              Center(
                child: Text(Strings.noDevicesFound),
              );
            }
            return ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.devices[index]),
                );
              },
            );
          } else if (state is DeviceDiscoveryFailure) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<FileTransferBloc>().add(DiscoverDevices());
              },
              child: Text("Discover Devices"),
            ),
          );
        },
      ),
    );
  }
}
