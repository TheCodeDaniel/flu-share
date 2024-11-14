import 'package:flushare/src/config/theme/app_colors.dart';
import 'package:flushare/src/core/network/ble_handler.dart';
import 'package:flushare/src/features/scan/services/ble_permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScanView extends StatefulWidget {
  const BleScanView({super.key});

  @override
  State<BleScanView> createState() => _BleScanViewState();
}

class _BleScanViewState extends State<BleScanView> {
  BlePermissionHelper blePermissionHelper = BlePermissionHelper();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    blePermissionHelper.checkBluetoothAndPermissions(context);
    super.initState();
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Nearby Devices"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text("Make sure bluetooth is On across all devices"),
                ),
                SizedBox(height: 30),
                StreamBuilder(
                  stream: BleHandler().scanResults,
                  builder: (context, snapshot) {
                    //
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        (snapshot.data == null || snapshot.data!.isEmpty)) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    //
                    if (snapshot.hasData) {
                      List<ScanResult>? scanList = snapshot.data;

                      if (scanList == null || scanList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bluetooth_disabled,
                              ),
                              SizedBox(height: 10),
                              Text("No nearby devices found"),
                            ],
                          ),
                        );
                      }

                      return Container(
                        height: MediaQuery.sizeOf(context).height * 0.8,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 10,
                              color: AppColors.kGrey,
                            ),
                          ],
                        ),
                        child: Scrollbar(
                          controller: scrollController,
                          child: ListView.separated(
                            controller: scrollController,
                            itemCount: scanList.length,
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemBuilder: (context, index) {
                              ScanResult result = scanList[index];
                              return ListTile(
                                onTap: () {},
                                title: Text(result.device.advName.isEmpty
                                    ? 'unknown-device'
                                    : result.device.advName),
                                subtitle: Text(
                                  result.rssi.toString(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }

                    //
                    return Center(
                      child: Text(
                        "Could not find nearby devices",
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
