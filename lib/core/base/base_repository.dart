import 'dart:async';

/// Base abstract class for repositories with common functionality
abstract class BaseRepository<T> {
  /// Stream controller for data
  final _dataController = StreamController<List<T>>.broadcast();

  /// Getter for data stream
  Stream<List<T>> get dataStream => _dataController.stream;

  /// Method to fetch data
  Future<void> fetchData();

  /// Method to add item
  Future<void> addItem(T item);

  /// Method to update item
  Future<void> updateItem(T item);

  /// Method to delete item
  Future<void> deleteItem(String id);

  /// Close the stream controller
  void dispose() {
    _dataController.close();
  }

  /// Helper method to handle errors consistently
  void handleError(Object error, StackTrace stackTrace) {
    print('Repository Error: $error');
    print('Stacktrace: $stackTrace');
    _dataController.addError(error);
  }
}
