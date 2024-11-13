import 'package:flushare/src/config/theme/app_colors.dart';
import 'package:flushare/src/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ReceiveSectionView extends StatelessWidget {
  const ReceiveSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * 0.5,
      width: size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.document_download,
                color: AppColors.primaryColor,
                size: 100,
              ),
              SizedBox(height: 10),
              Text(
                Strings.receiveAFile,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
