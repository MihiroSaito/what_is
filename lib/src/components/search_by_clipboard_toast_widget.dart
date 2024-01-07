import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_is/src/components/squishy_button.dart';

import '../../main.dart';
import '../config/theme.dart';


class SearchByClipboardTextToastWidget extends StatelessWidget {
  const SearchByClipboardTextToastWidget({
    super.key,
    required this.word,
    required this.onTap
  });

  final String word;
  final VoidCallback onTap;

  @override
  Widget build(_) {

    final textColor = AppTheme.isDarkMode()
        ? AppTheme.darkColor1 : Colors.white;

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



class SearchByClipboardUrlToastWidget extends StatelessWidget {
  const SearchByClipboardUrlToastWidget({
    super.key,
    required this.word,
    required this.onTap
  });

  final String word;
  final VoidCallback onTap;

  @override
  Widget build(context) {
    return Center(
      child: SquishyButton(
        onTap: () => onTap(),
        disableWidget: const SizedBox.shrink(),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                width: 1.0, color: AppTheme.isDarkMode()
                  ? Colors.white : accentColor.withOpacity(0.5)
              ),
              color: AppTheme.isDarkMode()
                  ? AppTheme.darkColor2 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 16.0,
                )
              ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                  ),
                  color: AppTheme.isDarkMode()
                      ? AppTheme.darkColor1
                      : AppTheme.lightColor1,
                ),
                child: const Center(
                  child: Icon(Icons.public, color: Color(0xFF7D858B),),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  word,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.bodyMedium!.color!
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
