import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_is/component/squishy_button.dart';

import '../main.dart';
import '../theme.dart';

class SearchAgainToastWidget extends StatelessWidget {
  const SearchAgainToastWidget({
    super.key,
    required this.word,
    required this.safeAreaPadding,
    required this.onTap
  });

  final String word;
  final EdgeInsets safeAreaPadding;
  final VoidCallback onTap;

  @override
  Widget build(_) {

    final textColor = AppTheme.isDarkMode()
        ? const Color(0xFF333333) : Colors.white;

    return Center(
      child: SquishyButton(
        onTap: () => onTap(),
        disableWidget: const SizedBox.shrink(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: AppTheme.isDarkMode()
                ? Colors.white : accentColor,
            boxShadow: AppTheme.isDarkMode()? [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.05),
                blurRadius: 8.0,
              )
            ] : null
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.search, size: 24.0, color: textColor,),
              const SizedBox(width: 8.0),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        word,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' を検索',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
