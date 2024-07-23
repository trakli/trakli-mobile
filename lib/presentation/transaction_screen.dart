import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF047844),
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.addTransaction.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: const Center(
        child: Text("TransactionScreen"),
      ),
    );
  }
}
