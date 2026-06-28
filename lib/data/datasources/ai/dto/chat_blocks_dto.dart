// Typed models for the AI agent's result "blocks" and the legacy SmartQL
// result. Parsed in the data layer so the presentation layer switches on real
// types instead of poking at `Map<String, dynamic>`.
//
// Row-level payloads (`rows`, `data`, `series`, `items` of tables/charts/lists)
// are intentionally `List<Map<String, dynamic>>`: their columns are arbitrary
// and defined by the query, so they can't be statically typed.

// ---- small parse helpers ----------------------------------------------------

String _s(dynamic v) => v?.toString() ?? '';
String? _sn(dynamic v) => v?.toString();
num? _numOrNull(dynamic v) => v is num ? v : num.tryParse(v?.toString() ?? '');
int? _intOrNull(dynamic v) =>
    v is num ? v.toInt() : int.tryParse(v?.toString() ?? '');

List<String> _stringList(dynamic v) =>
    v is List ? v.map((e) => e.toString()).toList() : const [];

List<int> _intList(dynamic v) =>
    v is List ? v.map(_intOrNull).whereType<int>().toList() : const <int>[];

List<Map<String, dynamic>> _rowList(dynamic v) => v is List
    ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : const [];

List<T> _objList<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) =>
    v is List
        ? v
            .whereType<Map>()
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : const [];

// ---- sealed block union -----------------------------------------------------

sealed class ChatBlock {
  const ChatBlock();

  /// Dispatches on the block's `type`; unknown types degrade to [UnknownBlock].
  factory ChatBlock.fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString() ?? '';
    return switch (type) {
      'markdown' => MarkdownBlock.fromJson(json),
      'table' => TableBlock.fromJson(json),
      'kpi' => KpiBlock.fromJson(json),
      'chart' => ChartBlock.fromJson(json),
      'comparison' => ComparisonBlock.fromJson(json),
      'list' => ListBlock.fromJson(json),
      'callout' => CalloutBlock.fromJson(json),
      'timeline' => TimelineBlock.fromJson(json),
      'progress' => ProgressBlock.fromJson(json),
      'question' => QuestionBlock.fromJson(json),
      'quick_actions' => QuickActionsBlock.fromJson(json),
      'import_review' => ImportReviewBlock.fromJson(json),
      'canvas' => CanvasBlock.fromJson(json),
      'proposed_action' => ProposedActionBlock.fromJson(json),
      _ => UnknownBlock.fromJson(json, type),
    };
  }
}

final class MarkdownBlock extends ChatBlock {
  final String text;
  const MarkdownBlock(this.text);
  factory MarkdownBlock.fromJson(Map<String, dynamic> j) =>
      MarkdownBlock(_s(j['text']));
}

final class TableBlock extends ChatBlock {
  final String? title;
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  const TableBlock({this.title, required this.columns, required this.rows});
  factory TableBlock.fromJson(Map<String, dynamic> j) => TableBlock(
        title: _sn(j['title']),
        columns: _stringList(j['columns']),
        rows: _rowList(j['rows']),
      );
}

final class KpiItem {
  final String label;
  final dynamic value;
  final String? currency;
  final String? unit;
  final num? deltaPercent;
  const KpiItem({
    required this.label,
    this.value,
    this.currency,
    this.unit,
    this.deltaPercent,
  });
  factory KpiItem.fromJson(Map<String, dynamic> j) => KpiItem(
        label: _s(j['label']),
        value: j['value'],
        currency: _sn(j['currency']),
        unit: _sn(j['unit']),
        deltaPercent: _numOrNull(j['delta_percent']),
      );
}

final class KpiBlock extends ChatBlock {
  final String? title;
  final List<KpiItem> items;
  const KpiBlock({this.title, required this.items});
  factory KpiBlock.fromJson(Map<String, dynamic> j) => KpiBlock(
        title: _sn(j['title']),
        items: _objList(j['items'], KpiItem.fromJson),
      );
}

final class ChartBlock extends ChatBlock {
  final String? title;
  final String chartHint;
  final List<Map<String, dynamic>> data;
  const ChartBlock({this.title, required this.chartHint, required this.data});
  factory ChartBlock.fromJson(Map<String, dynamic> j) => ChartBlock(
        title: _sn(j['title']),
        chartHint: _s(j['chart_hint']),
        data: _rowList(j['data']),
      );
}

final class ComparisonBlock extends ChatBlock {
  final String? title;
  final List<Map<String, dynamic>> series;
  const ComparisonBlock({this.title, required this.series});
  factory ComparisonBlock.fromJson(Map<String, dynamic> j) => ComparisonBlock(
        title: _sn(j['title']),
        series: _rowList(j['series']),
      );
}

final class ListBlock extends ChatBlock {
  final String? title;
  final List<Map<String, dynamic>> items;
  const ListBlock({this.title, required this.items});
  factory ListBlock.fromJson(Map<String, dynamic> j) => ListBlock(
        title: _sn(j['title']),
        items: _rowList(j['items']),
      );
}

final class CalloutBlock extends ChatBlock {
  final String? title;
  final String text;
  final String variant;
  const CalloutBlock({this.title, required this.text, required this.variant});
  factory CalloutBlock.fromJson(Map<String, dynamic> j) {
    final v = _s(j['variant']);
    return CalloutBlock(
      title: _sn(j['title']),
      text: _s(j['text']),
      variant: v.isEmpty ? 'info' : v,
    );
  }
}

final class TimelineItem {
  final String? title;
  final String? date;
  final String? description;
  final dynamic amount;
  final String? currency;
  const TimelineItem({
    this.title,
    this.date,
    this.description,
    this.amount,
    this.currency,
  });
  factory TimelineItem.fromJson(Map<String, dynamic> j) => TimelineItem(
        title: _sn(j['title']),
        date: _sn(j['date']),
        description: _sn(j['description']),
        amount: j['amount'],
        currency: _sn(j['currency']),
      );
}

final class TimelineBlock extends ChatBlock {
  final String? title;
  final List<TimelineItem> items;
  const TimelineBlock({this.title, required this.items});
  factory TimelineBlock.fromJson(Map<String, dynamic> j) => TimelineBlock(
        title: _sn(j['title']),
        items: _objList(j['items'], TimelineItem.fromJson),
      );
}

final class ProgressItem {
  final String? label;
  final num? current;
  final num? target;
  final String? currency;
  const ProgressItem({this.label, this.current, this.target, this.currency});
  factory ProgressItem.fromJson(Map<String, dynamic> j) => ProgressItem(
        label: _sn(j['label']),
        current: _numOrNull(j['current']),
        target: _numOrNull(j['target']),
        currency: _sn(j['currency']),
      );
}

final class ProgressBlock extends ChatBlock {
  final String? title;
  final List<ProgressItem> items;
  const ProgressBlock({this.title, required this.items});
  factory ProgressBlock.fromJson(Map<String, dynamic> j) => ProgressBlock(
        title: _sn(j['title']),
        items: _objList(j['items'], ProgressItem.fromJson),
      );
}

final class QuestionOption {
  final String label;
  final String message;
  const QuestionOption({required this.label, required this.message});
  factory QuestionOption.fromJson(Map<String, dynamic> j) {
    final label = _s(j['label']);
    final msg = _s(j['message']);
    return QuestionOption(label: label, message: msg.isEmpty ? label : msg);
  }
}

final class QuestionBlock extends ChatBlock {
  final String? prompt;
  final List<QuestionOption> options;
  const QuestionBlock({this.prompt, required this.options});
  factory QuestionBlock.fromJson(Map<String, dynamic> j) => QuestionBlock(
        prompt: _sn(j['prompt']),
        options: _objList(j['options'], QuestionOption.fromJson),
      );
}

final class QuickAction {
  final String label;
  const QuickAction(this.label);
  factory QuickAction.fromJson(Map<String, dynamic> j) =>
      QuickAction(_s(j['label']));
}

final class QuickActionsBlock extends ChatBlock {
  final List<QuickAction> actions;
  const QuickActionsBlock({required this.actions});
  factory QuickActionsBlock.fromJson(Map<String, dynamic> j) =>
      QuickActionsBlock(actions: _objList(j['actions'], QuickAction.fromJson));
}

final class ImportReviewBlock extends ChatBlock {
  final int? importSessionId;
  final String status;
  final String? fileName;
  const ImportReviewBlock(
      {this.importSessionId, required this.status, this.fileName});
  factory ImportReviewBlock.fromJson(Map<String, dynamic> j) =>
      ImportReviewBlock(
        importSessionId: _intOrNull(j['import_session_id']),
        status: _s(j['status']),
        fileName: _sn(j['file_name']),
      );
}

final class CanvasBlock extends ChatBlock {
  final String? title;
  final List<ChatBlock> blocks;
  const CanvasBlock({this.title, required this.blocks});
  factory CanvasBlock.fromJson(Map<String, dynamic> j) => CanvasBlock(
        title: _sn(j['title']),
        blocks: (j['blocks'] is List)
            ? (j['blocks'] as List)
                .whereType<Map>()
                .map((e) => ChatBlock.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : const [],
      );
}

/// A single editable field inside a [ProposedActionBlock], parsed into a typed
/// variant so the renderer can switch over it exhaustively. [value] is the
/// server-proposed value (used as the edit default and read-only display); it
/// stays dynamic because it serializes back to JSON as an override.
sealed class ActionField {
  final String key;
  final String label;
  final dynamic value;
  final String? display;
  const ActionField({
    required this.key,
    required this.label,
    required this.value,
    this.display,
  });

  /// Maps the server `type` (with key/action heuristics for currency and
  /// wallet-type) to a typed variant; anything unknown becomes a [TextActionField].
  factory ActionField.fromJson(Map<String, dynamic> j, {String actionType = ''}) {
    final key = _s(j['key']);
    final label = _s(j['label']);
    final value = j['value'];
    final display = _sn(j['display']);

    switch (_s(j['type'])) {
      case 'currency':
        return CurrencyActionField(
            key: key, label: label, value: value, display: display);
      case 'wallet_type':
        return WalletTypeActionField(
            key: key, label: label, value: value, display: display);
      case 'enum':
        return EnumActionField(
            key: key,
            label: label,
            value: value,
            display: display,
            options: _stringList(j['options']));
      case 'wallet':
        return WalletRefActionField(
            key: key, label: label, value: value, display: display);
      case 'party':
        return PartyRefActionField(
            key: key, label: label, value: value, display: display);
      case 'number':
        return NumberActionField(
            key: key, label: label, value: value, display: display);
      case 'datetime':
        return DateTimeActionField(
            key: key, label: label, value: value, display: display);
      case 'categories':
        return CategoriesActionField(
            key: key,
            label: label,
            value: value,
            display: display,
            initialIds: _intList(value));
    }

    final k = key.toLowerCase();
    if (k.contains('currency')) {
      return CurrencyActionField(
          key: key, label: label, value: value, display: display);
    }
    if (k == 'type' && actionType.toLowerCase().contains('wallet')) {
      return WalletTypeActionField(
          key: key, label: label, value: value, display: display);
    }
    return TextActionField(
        key: key, label: label, value: value, display: display);
  }
}

/// Currency code, edited via the currency picker.
final class CurrencyActionField extends ActionField {
  const CurrencyActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// Wallet kind (bank / cash / credit_card / mobile), edited via a dropdown.
final class WalletTypeActionField extends ActionField {
  const WalletTypeActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// A fixed set of string [options], edited via a dropdown.
final class EnumActionField extends ActionField {
  final List<String> options;
  const EnumActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display,
      this.options = const []});
}

/// A reference to one of the user's wallets (by id).
final class WalletRefActionField extends ActionField {
  const WalletRefActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// A reference to one of the user's parties (by id, nullable).
final class PartyRefActionField extends ActionField {
  const PartyRefActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// A numeric value.
final class NumberActionField extends ActionField {
  const NumberActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// A date-time value (ISO string), edited via date/time pickers.
final class DateTimeActionField extends ActionField {
  const DateTimeActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// A set of category ids, edited via selectable chips.
final class CategoriesActionField extends ActionField {
  final List<int> initialIds;
  const CategoriesActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display,
      this.initialIds = const []});
}

/// Free-text — also the fallback for any unrecognized server type.
final class TextActionField extends ActionField {
  const TextActionField(
      {required super.key,
      required super.label,
      required super.value,
      super.display});
}

/// An action (e.g. `transaction.create`) the user must confirm/edit/dismiss.
final class ProposedActionBlock extends ChatBlock {
  final int id;
  final String actionType;
  final String summary;

  /// low | medium | high
  final String risk;

  /// pending | executed | rejected
  final String status;
  final List<ActionField> fields;

  const ProposedActionBlock({
    required this.id,
    required this.actionType,
    required this.summary,
    required this.risk,
    required this.status,
    required this.fields,
  });

  bool get isPending => status != 'executed' && status != 'rejected';
  bool get isExecuted => status == 'executed';

  factory ProposedActionBlock.fromJson(Map<String, dynamic> j) {
    final actionType = _s(j['action_type']);
    return ProposedActionBlock(
      id: _intOrNull(j['id']) ?? 0,
      actionType: actionType,
      summary: _s(j['summary']),
      risk: _s(j['risk']).isEmpty ? 'low' : _s(j['risk']),
      status: _s(j['status']).isEmpty ? 'pending' : _s(j['status']),
      fields: (j['fields'] is List)
          ? (j['fields'] as List)
              .whereType<Map>()
              .map((e) => ActionField.fromJson(Map<String, dynamic>.from(e),
                  actionType: actionType))
              .toList()
          : const [],
    );
  }
}

/// Any block type the client doesn't know yet — degrades to its text/summary.
final class UnknownBlock extends ChatBlock {
  final String type;
  final String text;
  const UnknownBlock({required this.type, required this.text});
  factory UnknownBlock.fromJson(Map<String, dynamic> j, String type) {
    final t = _s(j['text']);
    return UnknownBlock(type: type, text: t.isEmpty ? _s(j['summary']) : t);
  }
}

// ---- legacy SmartQL result --------------------------------------------------

/// A legacy SmartQL result: a `format_type` plus tabular `rows` (used when a
/// response has no agent blocks).
final class LegacyResult {
  /// scalar | pair | record | list | pair_list | table | raw
  final String formatType;
  final List<Map<String, dynamic>> rows;
  const LegacyResult({required this.formatType, required this.rows});

  factory LegacyResult.fromJson(Map<String, dynamic> j) => LegacyResult(
        formatType: _s(j['format_type']),
        rows: _rowList(j['rows']),
      );
}
