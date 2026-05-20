import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/forms/add_groups_form.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AddGroupScreen extends StatelessWidget {
  final GroupEntity? group;
  const AddGroupScreen({super.key, this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: LocaleKeys.groupAddGroup.tr(),
      ),
      body: AddGroupsForm(
        group: group,
      ),
    );
  }
}
