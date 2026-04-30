import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_target_entity.freezed.dart';

enum BudgetTargetType {
  category,
  group,
  wallet;

  String get serverKey {
    return switch (this) {
      BudgetTargetType.category => 'category',
      BudgetTargetType.group => 'group',
      BudgetTargetType.wallet => 'wallet',
    };
  }

  static BudgetTargetType fromServerKey(String key) {
    return switch (key) {
      'category' => BudgetTargetType.category,
      'group' => BudgetTargetType.group,
      'wallet' => BudgetTargetType.wallet,
      _ => throw ArgumentError('Unknown BudgetTargetType server key: $key'),
    };
  }
}

@freezed
class BudgetTargetEntity with _$BudgetTargetEntity {
  const factory BudgetTargetEntity({
    required BudgetTargetType type,
    required String targetClientId,
    int? targetId,
    String? name,
  }) = _BudgetTargetEntity;
}
