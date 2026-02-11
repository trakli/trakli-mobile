import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class AddWalletForm extends StatefulWidget {
  final WalletEntity? wallet;

  const AddWalletForm({
    super.key,
    this.wallet,
  });

  @override
  State<AddWalletForm> createState() => _AddWalletFormState();
}

class _AddWalletFormState extends State<AddWalletForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  late WalletType _selectedType;
  Currency? currency;
  MediaEntity? mediaEntity;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.wallet?.type ?? WalletType.cash;
    currency = context.read<CurrencyCubit>().state.currency;

    if (widget.wallet != null) {
      _nameController.text = widget.wallet!.name;
      _descriptionController.text = widget.wallet!.description ?? '';
      currency = widget.wallet!.currency ?? currency;
      mediaEntity = widget.wallet?.icon;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final walletCubit = context.read<WalletCubit>();

      // Parse balance with default value of 0.0 if empty
      final balanceText = _balanceController.text.trim();
      final balance =
          balanceText.isEmpty ? 0.0 : (double.tryParse(balanceText) ?? 0.0);

      if (widget.wallet != null) {
        // Update existing wallet
        walletCubit.updateWallet(
          clientId: widget.wallet!.clientId,
          name: _nameController.text,
          type: _selectedType,
          balance: balance,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          icon: mediaEntity,
        );
      } else {
        if (currency == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.pleaseSelectCurrency.tr()),
            ),
          );
          return;
        }
        // Create new wallet
        walletCubit.addWallet(
          name: _nameController.text,
          type: _selectedType,
          balance: balance,
          currency: currency!.code,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          icon: mediaEntity,
        );
      }
      AppNavigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.w,
              children: [
                GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(
                      context,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      widget: SelectIconBottomSheet(
                        onSelect: (mediaType, image) {
                          setState(() {
                            mediaEntity = MediaEntity(
                                content: image, mediaType: mediaType);
                          });
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 56.r,
                    width: 56.r,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: ImageWidget(
                      mediaEntity: mediaEntity,
                      accentColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.enterName.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.nameIsRequired.tr();
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            ...[
              SizedBox(height: 20.h),
              Text(
                LocaleKeys.balance.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.wallet != null
                            ? widget.wallet!.balance.toString()
                            : LocaleKeys.balanceWillBeSetToZero.tr(),
                        style: TextStyle(
                          fontSize: widget.wallet != null ? 18.sp : 14.sp,
                          fontWeight: widget.wallet != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: widget.wallet == null
                        ? () async {
                            showCurrencyPicker(
                              context: context,
                              theme: CurrencyPickerThemeData(
                                bottomSheetHeight: 0.7.sh,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                flagSize: 24.sp,
                                subtitleTextStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onSelect: (Currency currencyValue) {
                                setState(() {
                                  currency = currencyValue;
                                });
                              },
                            );
                          }
                        : null,
                    child: Container(
                      width: 60.w,
                      constraints: BoxConstraints(
                        maxHeight: 50.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          currency?.code ??
                              widget.wallet?.currencyCode ??
                              'XAF',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
            SizedBox(height: 20.h),
            Text(
              LocaleKeys.type.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<WalletType>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                hintText: LocaleKeys.selectWalletType.tr(),
              ),
              items: WalletType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.customName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            SizedBox(height: 20.h),
            Text(
              LocaleKeys.description.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: LocaleKeys.typeHere.tr(),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 54.h,
              width: double.infinity,
              child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: state.isSaving
                      ? null
                      : () {
                          hideKeyBoard();
                          if (_formKey.currentState?.validate() ?? false) {
                            _submitForm();
                          }
                        },
                  child: Row(
                    spacing: 8.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.wallet != null
                          ? LocaleKeys.updateWallet.tr()
                          : LocaleKeys.createWallet.tr()),
                      SvgPicture.asset(
                        widget.wallet != null
                            ? Assets.images.edit2
                            : Assets.images.add,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
