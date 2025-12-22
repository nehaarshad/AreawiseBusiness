import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectLocationViewModelProvider = StateNotifierProvider<selectLocationViewModel, String?>((ref) {
  return selectLocationViewModel(ref);
});

class selectLocationViewModel extends StateNotifier<String?> {
  final Ref ref;

  selectLocationViewModel(this.ref) : super(null);

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void setLocation(String? area) {
    state = area != null && area.isNotEmpty ? area : null;
  }
}