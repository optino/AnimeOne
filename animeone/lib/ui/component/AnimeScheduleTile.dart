import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'AnimeButton.dart';

class AnimeScheduleTile extends StatelessWidget {
  
  final AnimeSchedule schedule;
  final GlobalData global = new GlobalData();

  AnimeScheduleTile({Key key, @required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: new AnimeButton(basic: schedule),
        ),
        IconButton(
          tooltip: '使用維基百科搜索 動畫' + schedule.name,
          icon: Icon(Icons.info_outline),
          onPressed: () => global.getWikipediaLink(schedule.name),
        )
      ],
    );
  }
  
}
