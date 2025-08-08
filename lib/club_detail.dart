import 'package:club_recommend/club_info.dart';
import 'package:club_recommend/image_view.dart';
import 'package:club_recommend/pda_service_session.dart';
import 'package:club_recommend/reload_widget.dart';
import 'package:club_recommend/tagbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ClubDetail extends StatefulWidget {
  final ClubInfo info;

  const ClubDetail({super.key, required this.info});

  @override
  State<ClubDetail> createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> {
  late ScrollController _scrollController;
  late Future<String> _content;
  final List<ImageProvider> _image = [];

  static const _expandedHeight = 310.0;
  static const _maxWidth = 800.0;

  double _opacity = 0.0;

  void _scrollListener() {
    _opacity = (_scrollController.offset / (_expandedHeight - kToolbarHeight));
    if (_opacity < 0.0) _opacity = 0.0;
    if (_opacity >= 1.0) _opacity = 1.0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _content = getClubArticle(widget.info.code);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    if (widget.info.pic > 0) {
      for (var index in Iterable.generate(widget.info.pic)) {
        _image.add(NetworkImage(getClubImage(widget.info.code, index)));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: widget.info.color,
          brightness: Theme.of(context).brightness,
        ),
      ),
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: _expandedHeight,
              centerTitle: false,
              pinned: true,
              title: Opacity(opacity: _opacity, child: Text(widget.info.title)),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(
                    0,
                    kToolbarHeight,
                    0,
                    46,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image(
                          image: widget.info.icon,
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.info.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.info.intro),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...widget.info.type.map<Widget>(
                            (type) => Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 2,
                              ),
                              child: TagBox(
                                text: switch (type) {
                                  ClubType.tech => "技术",
                                  ClubType.acg => "晒你系",
                                  ClubType.union => "官方",
                                  ClubType.profit => "商业",
                                  ClubType.sport => "体育",
                                  ClubType.art => "文化",
                                  ClubType.game => "游戏",
                                  ClubType.unknown => "未知",
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(46.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _maxWidth),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: widget.info.qq),
                            );
                            if (context.mounted) {
                              toastification.show(
                                context: context,
                                title: Text("QQ 号已经复制到剪贴板"),
                                autoCloseDuration: const Duration(seconds: 5),
                              );
                            }
                          },
                          child: Ink(
                            height: 46.0,
                            child: Center(
                              child: Text(
                                "QQ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (widget.info.qqlink.isEmpty) {
                              toastification.show(
                                context: context,
                                title: Text("未提供入群链接"),
                                autoCloseDuration: const Duration(seconds: 5),
                              );
                            }
                            launchUrlString(widget.info.qqlink);
                          },
                          child: Ink(
                            height: 46.0,
                            child: Center(
                              child: Text(
                                "邀请链接",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    FutureBuilder<String>(
                      future: _content,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Padding(
                            padding: EdgeInsetsGeometry.only(bottom: 2),
                            child: LinearProgressIndicator(),
                          );
                        } else {
                          return SizedBox(height: 6);
                        }
                      },
                    ),

                    if (widget.info.pic > 0) ...[
                      Container(
                        height: 300,
                        constraints: BoxConstraints(maxWidth: 600),
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(12),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: widget.info.pic,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 4,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(12),
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ImageView(
                                          images: _image,
                                          initalPage: index,
                                        );
                                      },
                                    ),
                                  ),
                                  child: Image(
                                    image: _image[index],
                                    height: 300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Colors.transparent),
                    ],
                    FutureBuilder<String>(
                      future: _content,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          try {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: _maxWidth),
                              child: Padding(
                                padding: EdgeInsetsGeometry.only(
                                  left: 8,
                                  right: 8,
                                  bottom: 2,
                                ),
                                child: Html(
                                  data: snapshot.data ?? '''<p>加载遇到问题</p>''',
                                ),
                              ),
                            );
                          } catch (e) {
                            return ReloadWidget(
                              function: () {
                                setState(() {
                                  _content = getClubArticle(widget.info.code);
                                });
                              },
                            );
                          }
                        } else {
                          return SizedBox(height: 0);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
