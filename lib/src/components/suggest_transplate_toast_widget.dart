import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/config/theme.dart';


typedef AlwaysEnabled = void Function(bool value);

class SuggestTranslateToastWidget extends HookConsumerWidget {
  const SuggestTranslateToastWidget({
    super.key,
    required this.onEnabled,
    required this.onKept
  });

  final AlwaysEnabled onEnabled;
  final VoidCallback onKept;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final checkBixValue = useState(false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.isDarkMode()
            ? AppTheme.darkColor3 : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.isDarkMode()
                ? Colors.white.withOpacity(0.15)
                : Colors.black.withOpacity(0.15),
            blurRadius: 24.0,
          )
        ]
      ),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.isDarkMode()
                      ? AppTheme.darkColor2 : const Color(0xFF333333),
                  shape: BoxShape.circle
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.translate,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '日本語に翻訳しますか？',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color!
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      checkBixValue.value = !checkBixValue.value;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: CupertinoCheckbox(
                              value: checkBixValue.value,
                              onChanged: (value) => checkBixValue.value = value ?? false,
                            ),
                          ),
                          const SizedBox(width: 4.0,),
                          Text(
                            '次から自動で有効にする',
                            style: TextStyle(
                              height: 1.0,
                              fontSize: 14.0,
                              color: Theme.of(context).textTheme.bodyMedium!.color!
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0,),
                  Row(
                    children: [
                      _Button(
                          backgroundColor: AppTheme.isDarkMode()
                              ? const Color(0xFF333333).withOpacity(0.5)
                              : const Color(0xFF555555).withOpacity(0.1),
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white.withOpacity(0.5)
                              : const Color(0xFF333333),
                          onTap: () => onKept(),
                          label: 'このまま'
                      ),
                      const SizedBox(width: 8.0,),
                      _Button(
                        backgroundColor: AppTheme.isDarkMode()
                            ? accentColor.withOpacity(0.8) : accentColor.withOpacity(0.1),
                        fontColor: AppTheme.isDarkMode()
                            ? Colors.white : accentColor,
                        onTap: () => onEnabled(checkBixValue.value),
                        label: '有効にする'
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0,),

                ],
              ),
            ],
          ),
          const SizedBox(height: 6.0,),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5.0,
              width: 56.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey.shade500
              ),
            ),
          ),
          const SizedBox(height: 4.0,),
        ],
      ),
    );
  }
}


class _Button extends StatelessWidget {
  const _Button({
    required this.onTap,
    required this.label,
    required this.backgroundColor,
    this.fontColor
  });

  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16.0),
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(
              color: fontColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

