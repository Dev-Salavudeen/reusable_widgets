import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

// enum LoadDetectionLevel {
//   low,
//   medium,
//   high,
// }

typedef NullableIndexedNodeBuilder<E> = Widget? Function(
    BuildContext context, E node, int index);

class PaginatedListView<E> extends StatefulWidget {
  final NullableIndexedNodeBuilder<E> itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? emptyBuilder;
  final PaginatedList<E> list;
  final ChildIndexGetter? findChildIndexCallback;
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onLoad;
  // final LoadDetectionLevel loadDetectionLevel;

  /// [itemBuilder] only
  final double? itemExtent;

  final double? cacheExtent;

  /// [itemBuilder] only
  final Widget? prototypeItem;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// [itemBuilder] only
  final int? semanticChildCount;

  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  const PaginatedListView({
    Key? key,
    required this.itemBuilder,
    required this.list,
    this.emptyBuilder,
    this.findChildIndexCallback,
    this.scrollDirection = Axis.vertical,
    // this.loadDetectionLevel = LoadDetectionLevel.low,
    this.reverse = false,
    this.primary,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
    this.padding,
    this.itemExtent,
    this.cacheExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.onLoad,
  })  : separatorBuilder = null,
        super(key: key);

  const PaginatedListView.separated({
    required this.itemBuilder,
    required IndexedWidgetBuilder this.separatorBuilder,
    required this.list,
    this.emptyBuilder,
    this.findChildIndexCallback,
    this.scrollDirection = Axis.vertical,
    // this.loadDetectionLevel = LoadDetectionLevel.low,
    this.reverse = false,
    this.primary,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
    this.padding,
    this.itemExtent,
    this.cacheExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    super.key,
    this.onLoad,
  });

  @override
  State<PaginatedListView<E>> createState() => _PaginatedListViewState<E>();
}

class _PaginatedListViewState<E> extends State<PaginatedListView<E>> {
  late ScrollController _scrollController;

  Completer<void> _loadCompleter = Completer<void>();

  double _previousOffsetCache = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return _buildEmptyView();
    } else if (widget.separatorBuilder != null) {
      return _buildViewWithSeparator(context);
    } else {
      return _buildView(context);
    }
  }

  Widget _buildViewWithSeparator(BuildContext context) {
    return ListView.separated(
      separatorBuilder: widget.separatorBuilder!,
      itemBuilder: _getItemBuilder,
      itemCount: widget.list.items.length,
      findChildIndexCallback: widget.findChildIndexCallback,
      padding: widget.padding,
      scrollDirection: widget.scrollDirection,
      clipBehavior: widget.clipBehavior,
      controller: _scrollController,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      restorationId: widget.restorationId,
      primary: widget.primary,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      reverse: widget.reverse,
    );
  }

  Widget _buildView(BuildContext context) {
    return ListView.builder(
      itemBuilder: _getItemBuilder,
      itemCount: widget.list.items.length,
      findChildIndexCallback: widget.findChildIndexCallback,
      padding: widget.padding,
      scrollDirection: widget.scrollDirection,
      clipBehavior: widget.clipBehavior,
      controller: _scrollController,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      restorationId: widget.restorationId,
      primary: widget.primary,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      itemExtent: widget.itemExtent,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      prototypeItem: widget.prototypeItem,
      reverse: widget.reverse,
      semanticChildCount: widget.semanticChildCount,
    );
  }

  Widget? _getItemBuilder(BuildContext context, int index) {
    var node = widget.list.items.elementAt(index);
    return widget.itemBuilder(context, node, index);
  }

  void _scrollListener() {
    double currentOffset = _scrollController.offset;
    double minScrollExtent = _scrollController.position.minScrollExtent;
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    bool isScrollingRight = currentOffset > _previousOffsetCache;

    _previousOffsetCache = currentOffset;
    if (currentOffset <= minScrollExtent) {
      // User has scrolled to the top/start
    } else if (currentOffset >= maxScrollExtent) {
      // User has scrolled to the bottom/end
      if (widget.onLoad != null &&
          !_loadCompleter.isCompleted &&
          isScrollingRight) {
        Future.sync(() => widget.onLoad!()).then((val) {
          _loadCompleter.complete();
          _loadCompleter = Completer<void>();
        }).catchError((err) {
          _loadCompleter.completeError(err);
          _loadCompleter = Completer<void>();
        });
      }
    }
  }

  Widget _buildEmptyView() {
    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  // double _getLoadDetectionLevelValue() {
  //   switch (widget.loadDetectionLevel) {
  //     case LoadDetectionLevel.low:
  //       return kMinInteractiveDimension;
  //     case LoadDetectionLevel.medium:
  //       return kMinInteractiveDimension * 2;
  //     case LoadDetectionLevel.high:
  //       return kMinInteractiveDimension * 4;
  //   }
  // }
}
