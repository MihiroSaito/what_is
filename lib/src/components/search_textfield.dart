import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/squishy_button.dart';

import '../../main.dart';
import '../config/theme.dart';


class SearchTextField extends HookConsumerWidget {
  const SearchTextField({super.key, required this.onSubmit});

  final ValueChanged<String>? onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textController = useTextEditingController();
    final formText = useState<String>("");

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        decoration: BoxDecoration(
            color: AppTheme.isDarkMode()
                ? AppTheme.darkColor2
                : Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 32.0,
                  offset: const Offset(0.0, 4.0)
              )
            ]
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.isDarkMode()
                    ? AppTheme.darkColor1
                    : const Color(0xFFF7F8FB),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                toolbarOptions: const ToolbarOptions(
                  cut: true,
                  copy: true,
                  paste: true,
                  selectAll: false,
                ),
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'どんな言葉や概念を調べますか？',
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4)
                  ),
                ),
                keyboardAppearance: AppTheme.isDarkMode()
                    ? Brightness.dark : Brightness.light,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color
                ),
                textInputAction: TextInputAction.search,
                cursorColor: accentColor,
                onChanged: (text) => formText.value = text,
                onSubmitted: (text) => onSubmit?.call(text),
              ),
            ),

            if (formText.value.isNotEmpty)
              Positioned(
                top: 0,
                right: 8.0,
                bottom: 0,
                child: Center(
                  child: SquishyButton(
                    onTap: () => onSubmit?.call(formText.value),
                    disableWidget: const SizedBox.shrink(),
                    child: Icon(
                      Icons.search,
                      color: AppTheme.isDarkMode()
                          ? Colors.white
                          : accentColor,
                      size: 24,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
