import 'package:bloc/bloc.dart';
import 'package:cook_book/common/global.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    // Global.analytics.logEvent(name: "error", parameters: {"message": error.toString()});
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    // Global.analytics.logEvent(name: "change_screen", parameters: {"from": change.currentState.toString(), "to": change.nextState.toString()});
    super.onChange(cubit, change);
  }
}
