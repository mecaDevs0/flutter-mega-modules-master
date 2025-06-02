import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';

import 'empty_box_widget.dart';

class PaginatedListView<T> extends StatefulWidget {
  final Stream<List<T>> stream;
  final Function(BuildContext, T)? builder;
  final Future<void> Function() onRefresh;
  final Function() onLoadMore;
  final Function()? onEmpty;
  final bool separated;

  const PaginatedListView({
    required this.stream,
    this.builder,
    required this.onRefresh,
    required this.onLoadMore,
    this.onEmpty,
    this.separated = true,
  });

  @override
  _PaginatedListViewState createState() => _PaginatedListViewState();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final scrollController = ScrollController();
  var oldSize = 0;
  var canLoadMore = true;
  var loadedMore = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.position.pixels &&
          canLoadMore) {
        loadedMore = true;
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Modular.get<MegaBaseBloc>().isLoadingList,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data!) {
          return SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: widget.onRefresh,
          color: Theme.of(context).primaryColor,
          child: StreamBuilder<List<T>>(
            stream: widget.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasError &&
                  snapshot.hasData &&
                  snapshot.data!.length > 0) {
                canLoadMore = snapshot.data!.length > oldSize || !loadedMore;
                oldSize = snapshot.data!.length;

                return ListView.separated(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder: (context, index) =>
                      widget.builder!(context, snapshot.data![index]),
                  separatorBuilder: (context, index) => Divider(
                    color: widget.separated ? Colors.grey : Colors.transparent,
                    thickness: 0.2,
                    height: widget.separated ? 1 : 0,
                  ),
                  itemCount: snapshot.data!.length,
                );
              } else {
                return const EmptyBoxWidget();
              }
            },
          ),
        );
      },
    );
  }
}
