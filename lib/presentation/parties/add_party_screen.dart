import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/widgets/add_party_form.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AddPartyScreen extends StatelessWidget {
  final PartyEntity? party;

  const AddPartyScreen({
    super.key,
    this.party,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: party != null
            ? LocaleKeys.partyEditParty.tr()
            : LocaleKeys.partyAddParty.tr(),
      ),
      body: AddPartyForm(party: party),
    );
  }
}
