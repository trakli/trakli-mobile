import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_widget.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a legacy SmartQL result (`format_type` + `rows`) used when a message
/// has no agent blocks. Tabular formats fall through to the table renderer.
class ChatLegacyResult extends StatelessWidget {
  final LegacyResult result;
  const ChatLegacyResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final rows = result.rows;
    if (rows.isEmpty) return const SizedBox.shrink();
    final format = result.formatType;

    if (format == 'table' ||
        !const ['scalar', 'pair', 'record', 'list', 'pair_list']
            .contains(format)) {
      return ChatBlockWidget(
        block: TableBlock(title: null, columns: const [], rows: rows),
      );
    }

    final Widget body;
    switch (format) {
      case 'scalar':
        final first = rows.first.values;
        body = Text(
          first.isEmpty ? '-' : fmtNum(first.first),
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: tones.brand.deep,
          ),
        );
        break;
      case 'pair':
        final entries = rows.first.entries.toList();
        final label =
            entries.isNotEmpty ? prettyKey(entries.first.key) : '';
        final value = entries.length > 1
            ? entries[1].value
            : (entries.isNotEmpty ? entries.first.value : null);
        body = _record(tones, label, fmtNum(value));
        break;
      case 'list':
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.map((r) {
            final v = r.values.isNotEmpty ? r.values.first : null;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ',
                      style:
                          TextStyle(fontSize: 13.sp, color: tones.textMuted)),
                  Expanded(
                    child: Text(fmtNum(v),
                        style: TextStyle(
                            fontSize: 13.sp, color: tones.textPrimary)),
                  ),
                ],
              ),
            );
          }).toList(),
        );
        break;
      case 'pair_list':
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.map((r) {
            final vals = r.values.toList();
            final label = vals.isNotEmpty ? '${vals.first}' : '';
            final value = vals.length > 1 ? vals[1] : null;
            return _record(tones, label, fmtNum(value));
          }).toList(),
        );
        break;
      case 'record':
      default:
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.first.entries
              .map((e) => _record(tones, prettyKey(e.key), fmtNum(e.value)))
              .toList(),
        );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: tones.bgCard,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: tones.borderLight),
      ),
      child: body,
    );
  }

  /// A bold "Label:" followed by its value.
  Widget _record(AppTones tones, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label:  ',
              style: TextStyle(
                color: tones.textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: tones.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
