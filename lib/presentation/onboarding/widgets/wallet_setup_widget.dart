import 'package:collection/collection.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/onboarding/onboard_settings_screen.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/popovers/wallet_type_popover.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class WalletSetupWidget extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const WalletSetupWidget({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<WalletSetupWidget> createState() => _WalletSetupWidgetState();
}

class _WalletSetupWidgetState extends State<WalletSetupWidget> {
  WalletOption? _selectedWalletOption = WalletOption.createAutomatically;
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final GlobalKey gloKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  Currency? currency;
  late Currency usdCurrency;
  Currency? defaultCurrency;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
    _loadCurrencyFromConfig();
    _optionController.text = _selectedWalletOption?.customName.tr() ?? "";
  }

  void _loadCurrencies() {
    const countryCode = KeyConstants.usdCode;
    final allCurrencies = CurrencyService().getAll();
    usdCurrency = allCurrencies.firstWhere((c) => c.code == countryCode);
    _currencyController.text = "${usdCurrency.code} - ${usdCurrency.name}";
  }

  void _loadCurrencyFromConfig() {
    final currency = getDefaultCurrencyFromConfig(context);
    if (currency != null) {
      setState(() {
        defaultCurrency = currency;
      });
      context.read<CurrencyCubit>().setCurrency(currency);
    }
  }

  @override
  void dispose() {
    _optionController.dispose();
    _nameController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configCubit = context.watch<ConfigCubit>();
    final walletCubit = context.watch<WalletCubit>();
    ConfigEntity? sConfig;
    sConfig = configCubit.state.configs
        .firstWhereOrNull((e) => e.key == ConfigConstants.defaultWallet);
    WalletEntity? wallet = walletCubit.state.wallets
        .firstWhereOrNull((e) => e.clientId == sConfig?.value);
    return BlocListener<WalletCubit, WalletState>(
      listener: (BuildContext context, WalletState state) {
        if (state.isSaving) {
          showLoader();
        } else {
          hideLoader();
        }
        if (state.failure.hasError) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      child: BlocListener<CurrencyCubit, CurrencyState>(
        listener: (BuildContext context, CurrencyState state) {
          state.when(
            initial: () {},
            loading: () {
              showLoader();
            },
            loaded: (currency) {
              hideLoader();
            },
            error: (failure) {
              hideLoader();
              showSnackBar(
                message: failure.customMessage,
                borderRadius: 8.r,
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          margin: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.h),
              CircleAvatar(
                radius: 30.sp,
                backgroundColor: appPrimaryColor.withAlpha(30),
                child: Icon(
                  Icons.wallet,
                  size: 28.sp,
                  color: appPrimaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                LocaleKeys.setupWalletTitle.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                LocaleKeys.setupWalletDesc.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.walletSetup.tr(),
                      style: TextStyle(
                        fontSize: 16.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Builder(builder: (context) {
                      return TextFormField(
                        controller: _optionController,
                        readOnly: true,
                        key: gloKey,
                        onTap: () {
                          showCustomPopOver(
                            context,
                            maxWidth: 0.8.sw,
                            widget: WalletTypePopover(
                              onSelect: (type) {
                                setState(() {
                                  _selectedWalletOption = type;
                                });
                                _optionController.text =
                                    _selectedWalletOption?.customName.tr() ??
                                        "";
                              },
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: SvgPicture.asset(
                              Assets.images.arrowDown,
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    if (_selectedWalletOption ==
                        WalletOption.createManually) ...[
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.w,
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  fillColor:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                          ),
                          GestureDetector(
                            onTap: () async {
                              showCurrencyPicker(
                                context: context,
                                theme: CurrencyPickerThemeData(
                                    bottomSheetHeight: 0.7.sh,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    flagSize: 24.sp,
                                    subtitleTextStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onSelect: (Currency currencyValue) {
                                  setState(() {
                                    currency = currencyValue;
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 60.w,
                              constraints: BoxConstraints(
                                maxHeight: 50.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  currency?.code ?? 'USD',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                    if (_selectedWalletOption ==
                            WalletOption.selectFromWalletList &&
                        wallet != null) ...[
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 4.w,
                        children: [
                          Text(
                            wallet.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            wallet.currencyCode,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 16.h),
                    Text(
                      LocaleKeys.defaultCurrency.tr(),
                      style: TextStyle(
                        fontSize: 16.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _currencyController,
                      readOnly: true,
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          theme: CurrencyPickerThemeData(
                              bottomSheetHeight: 0.7.sh,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              flagSize: 24.sp,
                              subtitleTextStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).primaryColor,
                              )),
                          onSelect: (Currency currency) {
                            setState(() {
                              defaultCurrency = currency;
                              context
                                  .read<CurrencyCubit>()
                                  .setCurrency(currency);
                            });
                            _currencyController.text =
                                "${currency.code} - ${currency.name}";
                          },
                        );
                      },
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            Assets.images.arrowDown,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              child: flagWidget(
                            defaultCurrency ?? usdCurrency,
                            fontSize: 20.sp,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: widget.onPrev,
                    child: Text(LocaleKeys.prev.tr()),
                  ),
                  PrimaryButton(
                    onPress: () async {
                      final hasDefaultWallet = configCubit.state
                          .hasConfig(ConfigConstants.defaultWallet);

                      if (defaultCurrency == null) {
                        context.read<CurrencyCubit>().setCurrency(usdCurrency);
                      }

                      if (!hasDefaultWallet) {
                        final walletCubit = context.read<WalletCubit>();
                        if (_selectedWalletOption ==
                                WalletOption.createManually &&
                            (_formKey.currentState?.validate() ?? false)) {
                          await walletCubit.createAndSaveDefaultWallet(
                            name: _nameController.text,
                            currency: currency?.code ?? usdCurrency.code,
                          );
                          widget.onNext();
                        } else if (_selectedWalletOption ==
                            WalletOption.createAutomatically) {
                          await walletCubit.createAndSaveDefaultWallet(
                            name: LocaleKeys.defaultWalletName.tr(),
                            description:
                                LocaleKeys.defaultWalletDescription.tr(),
                            currency: defaultCurrency?.code ?? usdCurrency.code,
                          );
                          widget.onNext();
                        } else if (_selectedWalletOption ==
                                WalletOption.selectFromWalletList &&
                            wallet != null) {
                          widget.onNext();
                        }
                      } else {
                        widget.onNext();
                      }
                    },
                    buttonText: LocaleKeys.next.tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
