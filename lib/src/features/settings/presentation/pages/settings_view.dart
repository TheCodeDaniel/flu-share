import 'package:flushare/src/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(Strings.settings),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      //
                      ListTile(
                        onTap: () {},
                        leading: Icon(Iconsax.safe_home),
                        title: Text(
                          Strings.storageLocation,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {},
                        leading: Icon(Iconsax.message),
                        title: Text(
                          Strings.sendAFeedback,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //
                    ],
                  ),
                ),
              ),

              // footer text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Strings.flutterCredit),
                  SizedBox(width: 5),
                  FlutterLogo(),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
