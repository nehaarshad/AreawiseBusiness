import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setLocation(String? area) async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if(area != null && area.isNotEmpty ) {
      await sp.setString('location', area);
      state = area;
    }
    else {
      state = null;
    }
  }
}