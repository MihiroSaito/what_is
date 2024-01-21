import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:what_is/src/components/squishy_button.dart';

import '../../src/config/theme.dart';


class HistoryListItem extends StatelessWidget {
  const HistoryListItem({
    super.key,
    required this.controller,
    required this.title,
    required this.subText,
    this.padding,
    required this.onTap,
    required this.onDismissed
  });
  final SwipeActionController controller;
  final String title;
  final String subText;
  final EdgeInsets? padding;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: UniqueKey(),
      controller: controller,
      trailingActions: [
        SwipeAction(
            title: "削除",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            performsFirstActionWithFullSwipe: true,
            onTap: (handler) async {
              await handler(true);
              onDismissed();
            }
        ),
      ],
      child: SquishyButton(
        disableWidget: const SizedBox.shrink(),
        onTap: () => onTap(),
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: padding ?? const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subText,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4),
                      fontSize: 14.0
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
