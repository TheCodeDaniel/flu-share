import 'file_transfer_bloc/file_transfer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'file_transfer_bloc/file_transfer_bloc.dart';
import 'file_transfer_bloc/file_transfer_state.dart';

class DeviceScanView extends StatefulWidget {
  const DeviceScanView({super.key});

  @override
  State<DeviceScanView> createState() => _DeviceScanViewState();
}

class _DeviceScanViewState extends State<DeviceScanView> {
  @override
  void initState() {
    super.initState();
    // Automatically trigger the discovery of devices when the page is opened
    context.read<FileTransferBloc>().add(DiscoverDevices());
  }

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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 50, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No devices found",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
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
          return Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
