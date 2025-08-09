import 'dart:async';

import 'package:club_recommend/club_card.dart';
import 'package:club_recommend/club_info.dart';
import 'package:club_recommend/pda_service_session.dart';
import 'package:club_recommend/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:result_dart/result_dart.dart';

class ClubSuggestion extends StatefulWidget {
  const ClubSuggestion({super.key});

  @override
  State<ClubSuggestion> createState() => _ClubSuggestionState();
}

class _ClubSuggestionState extends State<ClubSuggestion> {
  ClubType shownType = ClubType.all;
  late Future<ResultDart<List<ClubInfo>, Exception>> _stream;

  void updateStatus(ClubType type) {
    setState(() {
      shownType = type;
      _stream = getClubList(shownType);
    });
  }

  @override
  void initState() {
    super.initState();
    _stream = getClubList(shownType);
  }

  Widget chooseChip(ClubType e) => Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 4),
    child: TextButton(
      style: TextButton.styleFrom(
        backgroundColor: shownType == e
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      ),
      onPressed: () => updateStatus(e),
      child: Text(
        switch (e) {
          ClubType.tech => "技术",
          ClubType.acg => "晒你系",
          ClubType.union => "官方",
          ClubType.profit => "商业",
          ClubType.sport => "体育",
          ClubType.art => "文化",
          ClubType.game => "游戏",
          ClubType.unknown => "未知",
          ClubType.all => "所有",
        },
        style: TextStyle(
          color: shownType == e
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultDart<List<ClubInfo>, Exception>>(
      future: _stream,
      builder: (context, snapshot) {
        late Widget body;
        PreferredSize? bottom;
        if (snapshot.connectionState != ConnectionState.done) {
          body = Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = Center(
            child: ReloadWidget(
              function: () => setState(() {
                _stream = getClubList(shownType);
              }),
              errorStatus: "获取数据过程中发生错误：${snapshot.error}",
            ),
          );
        } else {
          var clubTypeList = List.from(ClubType.values);
          clubTypeList.removeWhere(
            (e) => e == ClubType.unknown || e == ClubType.all,
          );

          bottom = PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Row(
              children: [
                SizedBox(width: 8),
                chooseChip(ClubType.all),
                const VerticalDivider(),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: kToolbarHeight),
                    child: ListView(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 12),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: clubTypeList.map((e) => chooseChip(e)).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );

          body = snapshot.data!.fold(
            (clubList) => LayoutBuilder(
              builder: (context, constraints) => MasonryGridView.count(
                shrinkWrap: true,
                itemCount: clubList.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisCount: constraints.maxWidth ~/ 280,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => context.pushNamed(
                      "detail",
                      pathParameters: {"code": clubList[index].code},
                    ),
                    child: ClubCard(data: clubList[index]),
                  );
                },
              ),
            ),
            (error) => Center(
              child: ReloadWidget(
                function: () => setState(() {
                  _stream = getClubList(shownType);
                }),
                errorStatus: "获取数据函数执行中发生错误：$error",
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text("西电社团推荐"), bottom: bottom),
          body: body,
          bottomNavigationBar: BottomAppBar(
            height: 46,
            child: Center(child: Text("BenderBlog Rodriguez, 2025")),
          ),
        );
      },
    );
  }
}
