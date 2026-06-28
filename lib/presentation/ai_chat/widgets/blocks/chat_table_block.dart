import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_card.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';

/// Renders a table block: a single-row block degrades to key/value pairs;
/// multi-row renders a proper table with a header row.
class ChatTableBlock extends StatelessWidget {
  final TableBlock block;
  const ChatTableBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final rows = block.rows;
    if (rows.isEmpty) return const SizedBox.shrink();
    final columns =
        block.columns.isNotEmpty ? block.columns : rows.first.keys.toList();

    if (rows.length == 1) {
      final row = rows.first;
      return ChatBlockCard(
        title: block.title,
        child: Column(
          children: row.entries
              .map((e) => kvRow(tones, prettyKey(e.key), fmtNum(e.value)))
              .toList(),
        ),
      );
    }

    bool isNumericCol(String c) => rows.every((r) {
          final v = r[c];
          return v == null || v is num || num.tryParse('$v') != null;
        });

    return ChatBlockCard(
      title: block.title,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Table(
          columnWidths: {
            for (var i = 0; i < columns.length; i++) i: const FlexColumnWidth(),
          },
          border: TableBorder(
            horizontalInside: BorderSide(color: tones.borderLight),
          ),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: tones.brand.deep.withAlpha(28)),
              children: columns
                  .map((c) => _cell(tones, prettyKey(c),
                      bold: true, right: isNumericCol(c)))
                  .toList(),
            ),
            ...rows.map(
              (r) => TableRow(
                children: columns
                    .map((c) =>
                        _cell(tones, fmtNum(r[c]), right: isNumericCol(c)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _cell(AppTones tones, String text,
    {bool bold = false, bool right = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
    child: Text(
      text,
      textAlign: right ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        color: tones.textPrimary,
      ),
    ),
  );
}
