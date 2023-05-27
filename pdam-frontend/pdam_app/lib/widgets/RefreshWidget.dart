import 'package:flutter/cupertino.dart';

class RefreshWidget extends StatefulWidget {
  final Widget child;
  final Future Function() onRefresh;
  final ScrollController scrollController;

  const RefreshWidget(
      {super.key,
      required this.child,
      required this.onRefresh,
      required this.scrollController});

  @override
  State<RefreshWidget> createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
        ),
        SliverToBoxAdapter(
          child: widget.child,
        )
      ],
    );
  }
}
