import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// Base abstract class for all BLoCs with common functionality
abstract class BaseBLoC<Event, State> extends Bloc<Event, State> {
  BaseBLoC(super.initialState);

  /// Helper method to safely emit state
  @visibleForTesting
  void safeEmit(State newState) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(newState);
    }
  }

  /// Generic error handling method
  void handleError(Object error, StackTrace stackTrace) {
    // Implement centralized error logging or reporting
    print('Error in BLoC: $error');
    print('Stacktrace: $stackTrace');
  }
}
