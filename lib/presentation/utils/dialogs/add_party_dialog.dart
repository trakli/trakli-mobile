import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/forms/add_party_form.dart';

class AddPartyDialog extends StatelessWidget {
  const AddPartyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r)
      ),
      child: const AddPartyForm(
        showClose: true,
      ),
    );
  }
}
