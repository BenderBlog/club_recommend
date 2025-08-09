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
  late Future<ResultDart<List<ClubInfo>, Exception>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = getClubList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("西电社团推荐")),
      body: FutureBuilder<ResultDart<List<ClubInfo>, Exception>>(
        future: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: ReloadWidget(
                function: () => setState(() {
                  _stream = getClubList();
                }),
                errorStatus: "获取数据过程中发生错误：${snapshot.error}",
              ),
            );
          } else {
            return snapshot.data!.fold(
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
                    _stream = getClubList();
                  }),
                  errorStatus: "获取数据函数执行中发生错误：$error",
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 46,
        child: Center(child: Text("BenderBlog Rodriguez, 2025")),
      ),
    );
  }
}
