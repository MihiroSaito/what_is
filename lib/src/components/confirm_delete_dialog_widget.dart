import 'package:flutter/material.dart';
import 'package:what_is/src/config/theme.dart';

class ConfirmDeleteDialogWidget extends StatelessWidget {
  const ConfirmDeleteDialogWidget({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: AppTheme.isDarkMode()
                ? AppTheme.darkColor2 : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16.0,
                offset: const Offset(0.0, 4.0)
              )
            ]
        ),
        padding: const EdgeInsets.all(24.0),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0,),
              Text(
                text,
                style: const TextStyle(

                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16.0,),
              Row(
                children: [
                  Expanded(
                    child: _Button(
                      onTap: () => Navigator.pop(context, false),
                        label: 'キャンセル',
                        backgroundColor: AppTheme.isDarkMode()
                            ? AppTheme.darkColor1 : Colors.grey.shade200,
                      textStyle: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0,),
                  Expanded(
                    child: _Button(
                        onTap: () => Navigator.pop(context, true),
                        label: '削除する',
                        backgroundColor: AppTheme.red,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



class _Button extends StatelessWidget {
  const _Button({
    required this.onTap,
    required this.label,
    required this.backgroundColor,
    this.textStyle
  });

  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Center(
            child: Text(
              label,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
