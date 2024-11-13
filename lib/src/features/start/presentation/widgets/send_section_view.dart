import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SendSectionView extends StatelessWidget {
  const SendSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: Platform.isMacOS ? size.height * 0.5 : size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(color: Colors.black),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Send a file",
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
