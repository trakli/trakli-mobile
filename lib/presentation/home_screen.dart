import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/info_interfaces/empty_home_widget.dart';
import 'package:trakli/presentation/notifications/notifications_screen.dart';
import 'package:trakli/presentation/profile_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/all_wallets_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/pick_group_bottom_sheet.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/icon_background_decor.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/transaction_expansion_tile.dart';
import 'package:trakli/presentation/utils/wallet_tile.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int? _previousWalletsLength;
  int _previousTransactionCount = 0;
  bool _wasSaving = false;
  bool _carouselBuilt = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToWallet(String walletId, List<WalletEntity> wallets) {
    final walletIndex = wallets.indexWhere(
      (wallet) => wallet.clientId == walletId,
    );

    if (walletIndex != -1 && mounted && _carouselBuilt) {
      context.read<WalletCubit>().setCurrentSelectedWalletIndex(walletIndex);
      try {
        // Carousel index is walletIndex + 1 because index 0 is "All Wallets"
        _carouselController.animateToPage(walletIndex + 1);
      } catch (e) {
        // Carousel controller not ready yet, ignore
      }
    }
  }

  List<TransactionCompleteEntity> filterTransactions({
    required List<TransactionCompleteEntity> transactions,
    required List<WalletEntity> wallets,
    required int currentWalletIndex,
    required GroupEntity? selectedGroup,
    required GroupEntity? defaultGroup,
  }) {
    final bool isAllWallets = currentWalletIndex == allWalletsIndex;
    final bool hasWallets = wallets.isNotEmpty;

    if (!hasWallets) return <TransactionCompleteEntity>[];

    final String? currentWalletId = isAllWallets
        ? null
        : (currentWalletIndex < wallets.length
            ? wallets[currentWalletIndex].clientId
            : null);

    if (!isAllWallets && currentWalletId == null) {
      return <TransactionCompleteEntity>[];
    }

    final String? selectedGroupId = selectedGroup?.clientId;
    final String? defaultGroupId = defaultGroup?.clientId;

    final filterdTransactions = transactions.where((transaction) {
      // Filter by wallet (skip if "All Wallets" is selected)
      if (!isAllWallets && transaction.wallet.clientId != currentWalletId) {
        return false;
      }

      // Transfers are global and should ignore group filters
      if (transaction.transaction.isTransferLeg) {
        return true;
      }

      final String? transactionGroupId = transaction.group?.clientId;

      // Include transaction if:
      final bool groupMatches = transactionGroupId == selectedGroupId;
      final bool shouldUseDefaultGroup = transactionGroupId == null &&
          selectedGroupId == defaultGroupId &&
          defaultGroupId != null;

      return groupMatches || shouldUseDefaultGroup;
    }).toList();

    return filterdTransactions;
  }

  Map<String, List<TransactionCompleteEntity>> groupTransactionsByMonth(
    List<TransactionCompleteEntity> transactions,
  ) {
    final Map<String, List<TransactionCompleteEntity>> grouped = {};

    final transactionsToSort = transactions;

    transactionsToSort.sort(
      (a, b) => b.transaction.datetime.compareTo(a.transaction.datetime),
    );

    for (var transaction in transactionsToSort) {
      final monthKey =
          DateFormat('MMMM yyyy').format(transaction.transaction.datetime);

      grouped.putIfAbsent(monthKey, () => []).add(transaction);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final walletState = context.watch<WalletCubit>().state;
    final wallets = walletState.wallets;
    final currentWalletIndex = walletState.currentSelectedWalletIndex;

    final groups = context.watch<GroupCubit>().state.groups;
    // Default group is tracked via configuration
    final configState = context.watch<ConfigCubit>().state;
    final defaultGroupConfig =
        configState.getConfigByKey(ConfigConstants.defaultGroup);
    final defaultGroupId = defaultGroupConfig?.value as String?;
    final defaultGroup =
        groups.firstWhereOrNull((entity) => entity.clientId == defaultGroupId);

    // Ensure "All Wallets" is selected by default
    // Reset to "All Wallets" when wallets are first loaded or when app restarts
    if (wallets.isNotEmpty && _previousWalletsLength != wallets.length) {
      _carouselBuilt = false; // Reset flag when wallets change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _carouselBuilt) {
          // Always default to "All Wallets" when wallets are first loaded
          context
              .read<WalletCubit>()
              .setCurrentSelectedWalletIndex(allWalletsIndex);
          try {
            // Carousel index 0 is "All Wallets"
            _carouselController.animateToPage(0);
          } catch (e) {
            // Carousel controller not ready yet, ignore
          }
        }
      });
      _previousWalletsLength = wallets.length;
    }

    // Always start with "All Wallets" (index 0) on initial load
    // Only use current index if it's already set and valid (for navigation within session)
    final int carouselInitialPage = currentWalletIndex == allWalletsIndex
        ? 0
        : (currentWalletIndex >= 0 && currentWalletIndex < wallets.length
            ? currentWalletIndex + 1
            : 0);

    final currentSelectedGroup =
        context.watch<TransactionCubit>().state.selectedGroup;

    var selectedGroup = currentSelectedGroup ?? defaultGroup;

    context.read<TransactionCubit>().setCurrentGroup(selectedGroup);

    selectedGroup = selectedGroup ?? groups.firstOrNull;

    return Scaffold(
      backgroundColor: tones.bgPage,
      appBar: PageAppBar(
        title: '',
        titleWidget: Theme.of(context).brightness == Brightness.dark
            ? Image.asset(
                'assets/images/trakli-logo-white.png',
                height: 28.h,
                fit: BoxFit.contain,
              )
            : SvgPicture.asset(
                Assets.images.logoGreen,
                height: 30.h,
              ),
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: InkWell(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            borderRadius: BorderRadius.circular(AppRadii.md),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.md),
                color: Theme.of(context).primaryColor.withAlpha(50),
              ),
              padding: EdgeInsets.all(9.r),
              child: SvgPicture.asset(
                Assets.images.category,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        actions: [
          PageAppBarAction(
            icon: Icons.notifications_none_rounded,
            onTap: () => AppNavigator.push(
              context,
              const NotificationsScreen(),
            ),
          ),
          const _HomeProfileAvatar(),
        ],
      ),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listenWhen: (previous, current) {
          // Listen for transaction saves and failures
          return previous.failure != current.failure ||
              previous.isSaving != current.isSaving ||
              previous.transactions.length != current.transactions.length;
        },
        listener: (BuildContext context, TransactionState state) {
          if (state.failure.hasError) {
            showSnackBar(
              message: state.failure.customMessage,
            );
          }

          // Detect when a transaction is saved (isSaving goes from true to false)
          if (_wasSaving && !state.isSaving && state.transactions.isNotEmpty) {
            // Check if a new transaction was added
            if (state.transactions.length > _previousTransactionCount) {
              // Get the most recent transaction by datetime
              final mostRecentTransaction = state.transactions.reduce((a, b) =>
                  a.transaction.datetime.isAfter(b.transaction.datetime)
                      ? a
                      : b);
              final transactionWalletId = mostRecentTransaction.wallet.clientId;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && wallets.isNotEmpty) {
                  _navigateToWallet(transactionWalletId, wallets);
                }
              });
            }
            _previousTransactionCount = state.transactions.length;
          }

          _wasSaving = state.isSaving;
        },
        builder: (context, state) {
          // Initialize transaction count if not set
          if (_previousTransactionCount == 0 && state.transactions.isNotEmpty) {
            _previousTransactionCount = state.transactions.length;
          }
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(appPrimaryColor),
              ),
            );
          }
          final transactions = filterTransactions(
            transactions: state.transactions,
            wallets: wallets,
            currentWalletIndex: currentWalletIndex,
            selectedGroup: selectedGroup,
            defaultGroup: defaultGroup,
          );

          final grouped = groupTransactionsByMonth(transactions);
          final months = grouped.keys.toList();

          if (state.transactions.isEmpty) {
            return const EmptyHomeWidget();
          }

          return Stack(
            children: [
              IconBackgroundDecor(iconPath: Assets.images.home),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 15.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (wallets.isNotEmpty) ...[
                      Builder(
                        builder: (context) {
                          // Mark carousel as built when widget is in tree
                          if (!_carouselBuilt) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _carouselBuilt = true;
                                });
                              }
                            });
                          }
                          // carouselInitialPage is already calculated correctly (0 for All Wallets, or walletIndex + 1)
                          final int adjustedInitialPage = carouselInitialPage;

                          return CarouselSlider.builder(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: 190.h,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.2,
                              initialPage: adjustedInitialPage,
                              onPageChanged: (index, reason) {
                                // Convert carousel index back to wallet index
                                final walletIndex =
                                    index == 0 ? allWalletsIndex : index - 1;
                                context
                                    .read<WalletCubit>()
                                    .setCurrentSelectedWalletIndex(walletIndex);
                              },
                            ),
                            itemCount: wallets.length + 1,
                            itemBuilder: (context, index, pageViewIndex) {
                              if (index == 0) {
                                return AllWalletsTile(wallets: wallets);
                              }
                              return WalletTile(
                                wallet: wallets[index - 1],
                                canDelete: false,
                                showDefaultWallet: true,
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        child: AnimatedSmoothIndicator(
                          activeIndex: currentWalletIndex == allWalletsIndex
                              ? 0
                              : currentWalletIndex + 1,
                          count: wallets.length + 1,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Theme.of(context).primaryColor,
                            dotWidth: 8.r,
                            dotHeight: 8.r,
                          ),
                        ),
                      ),
                    ],
                    Text(
                      LocaleKeys.transactions.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            final groupEntity =
                                await showCustomBottomSheet<GroupEntity>(
                              context,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              widget: PickGroupBottomSheet(
                                group: selectedGroup,
                              ),
                            );

                            if (mounted && groupEntity != null) {
                              setState(() {
                                context
                                    .read<TransactionCubit>()
                                    .setCurrentGroup(groupEntity);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appOrange.withAlpha(40),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              spacing: 8.w,
                              children: [
                                ImageWidget(
                                  mediaEntity: selectedGroup?.icon,
                                  accentColor: appOrange,
                                  iconSize: 16.sp,
                                  emojiSize: 16.sp,
                                  placeholderIcon: Icons.folder_outlined,
                                ),
                                Text(
                                  selectedGroup?.name ?? LocaleKeys.group.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SvgPicture.asset(
                                  width: 16.w,
                                  height: 16.h,
                                  Assets.images.arrowRight,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            AppNavigator.push(context, const HistoryScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: seeAllBoxColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Text(
                                  LocaleKeys.seeAll.tr(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SvgPicture.asset(
                                  width: 16.w,
                                  height: 16.h,
                                  Assets.images.arrowRight,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    transactions.isEmpty
                        ? SizedBox(
                            height: 0.25.sh,
                            child: Center(
                              child: Text(
                                LocaleKeys.noTransactionsFound.tr(),
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: months.length,
                            itemBuilder: (context, index) {
                              final month = months[index];
                              final monthTransactions = grouped[month]!;
                              return TransactionExpansionTile(
                                title: month,
                                transactions: monthTransactions,
                                isExpanded: index == 0,
                              );
                            },
                          ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeProfileAvatar extends StatelessWidget {
  const _HomeProfileAvatar();

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final user = context.watch<AuthCubit>().state.user;
    final initials = _profileInitials(
      first: user?.firstName,
      last: user?.lastName,
      email: user?.email,
    );

    final gradient = LinearGradient(
      colors: [tones.brand.accent, tones.brand.deep],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => AppNavigator.push(context, const ProfileScreen()),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(60), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

String _profileInitials({String? first, String? last, String? email}) {
  String pick(String? s) =>
      (s != null && s.trim().isNotEmpty) ? s.trim()[0].toUpperCase() : '';
  final a = pick(first);
  final b = pick(last);
  if (a.isNotEmpty || b.isNotEmpty) return '$a$b';
  final e = pick(email);
  return e.isNotEmpty ? e : '·';
}
