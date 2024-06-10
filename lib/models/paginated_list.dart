part of 'models.dart';

typedef NodeItemDecoder<T> = T Function(dynamic nodeJson);

class PaginatedData<T> {
  int cursor;
  int size;
  int totalNodes;
  List<T> nodes;

  int get pageNo => cursor + 1;

  PaginatedData({
    this.cursor = 0,
    this.size = 0,
    this.totalNodes = 0,
    this.nodes = const [],
  });

  PaginatedData.fromJson(JSON json, NodeItemDecoder<T> decoder)
      : this(
          cursor: int.tryParse(json['cursor'].toString()) ?? 0,
          size: int.tryParse(json['size'].toString()) ?? 0,
          totalNodes: int.tryParse(json['totalNodes'].toString()) ?? 0,
          nodes: (json['nodes'] as List).map((e) => decoder(e)).toList(),
        );

  PaginatedData<T> merge(PaginatedData<T>? other) {
    return PaginatedData(
      cursor: other?.cursor ?? cursor,
      size: other?.size ?? size,
      totalNodes: other?.totalNodes ?? totalNodes,
      nodes: other?.nodes ?? nodes,
    );
  }
}

class PaginatedList<E> {
  int _size;
  int _currentIndex = 0;
  int totalNodes = 0;

  int get estimatedPages {
    var val = totalNodes / size;
    return val.isValid ? val.ceil() : 0;
  }

  final List<PaginatedData<E>> pages;

  int get size => _size;
  int get nextCursor {
    if (isEmpty) {
      return 0;
    } else if (hasNext) {
      return _currentIndex + 1;
    } else {
      return _currentIndex;
    }
  }

  List<E> get items {
    return pages
        .sublist(0, _currentIndex + 1)
        .fold([], (pre, next) => pre.followedBy(next.nodes).toList());
  }

  PaginatedList(int size, this.pages) : _size = size {
    if (pages.isNotEmpty) totalNodes = pages.last.totalNodes;
    assert(pages.isEmpty || totalNodes >= 0, "Total nodes cannot be negative");
  }

  PaginatedList.empty(int size)
      : _size = size,
        pages = [];

  bool get isEmpty => pages.isEmpty;

  bool get isNotEmpty => pages.isNotEmpty;

  PaginatedData<E> get current {
    if (pages.isEmpty) {
      throw StateError('There are no pages in the collection');
    }
    return pages[_currentIndex];
  }

  PaginatedData<E> get first {
    if (pages.isEmpty) {
      throw StateError('There are no pages in the collection');
    }
    return pages.first;
  }

  PaginatedData<E> get last {
    if (pages.isEmpty) {
      throw StateError('There are no pages in the collection');
    }
    return pages.last;
  }

  bool get hasNext => _currentIndex < estimatedPages - 1;

  bool get hasPrevious => _currentIndex > 0;

  Iterator<PaginatedData<E>> get iterator => pages.iterator;

  void addPage(PaginatedData<E> data) {
    if (data.nodes.isEmpty) return;
    assert(isEmpty || data.size == size,
        "The size of data to be added should be equal to the amount of existing data's");
    if (isNotEmpty && data.pageNo == last.pageNo && isNotEmpty) {
      // Replace the existing last page in the collection with the new page's data
      pages.last = last.merge(data);
    } else {
      // Add the new page to the collection
      pages.add(data);
    }
    totalNodes = last.totalNodes;
    _size = last.size;
    _currentIndex = last.cursor;
  }

  void removePage() {
    if (pages.isEmpty) {
      throw StateError('There are no pages in the collection');
    }
    pages.removeLast();
    totalNodes = last.totalNodes;
    _size = last.size;
    _currentIndex = last.cursor;
  }

  void moveNextPage() {
    if (!hasNext) {
      throw StateError('There is no next page in the collection');
    }
    _currentIndex++;
  }

  void movePreviousPage() {
    if (!hasPrevious) {
      throw StateError('There is no previous page in the collection');
    }
    _currentIndex--;
  }
}
