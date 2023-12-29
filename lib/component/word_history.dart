import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/squishy_button.dart';
import 'package:what_is/logic/notifier.dart';


class WordHistoryScreen extends HookConsumerWidget {
  const WordHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final wordHistory = ref.watch(wordHistoryProvider);
    final safeAreaPadding = MediaQuery.of(context).padding;


    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: safeAreaPadding.top),
              ),

            ],
          ),
          Positioned(
            top: safeAreaPadding.top + 8.0,
            right: 8.0,
            child: const _BackButton(),
          )
        ],
      ),
    );
  }
}



class _BackButton extends StatelessWidget {
  const _BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SquishyButton(
      onTap: () => Navigator.pop(context),
      disableWidget: const SizedBox.shrink(),
      child: Material(
        borderRadius: BorderRadius.circular(80.0),
        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.1),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.xmark,
            size: 28,
            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

