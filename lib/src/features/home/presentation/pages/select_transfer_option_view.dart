import 'package:flushare/src/core/utils/navigation_extension.dart';
import 'package:flushare/src/features/home/presentation/widgets/receive_section_view.dart';
import 'package:flushare/src/features/home/presentation/widgets/send_section_view.dart';
import 'package:flushare/src/features/settings/presentation/pages/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SelectTransferOptionView extends StatelessWidget {
  const SelectTransferOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Iconsax.menu),
        onPressed: () {
          context.push(SettingsView());
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Send section
            SendSectionView(),

            // Receive section
            ReceiveSectionView(),
          ],
        ),
      ),
    );
  }
}
