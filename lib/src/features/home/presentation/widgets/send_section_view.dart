import 'package:flushare/src/core/constants/bool_modes.dart';
import 'package:flushare/src/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SendSectionView extends StatelessWidget {
  const SendSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: kIsDesktop ? size.height * 0.5 : size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(color: Colors.black),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.sendAFile,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Icon(
                Iconsax.document_upload,
                color: Colors.white,
                size: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
