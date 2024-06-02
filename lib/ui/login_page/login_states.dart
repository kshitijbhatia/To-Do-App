import 'package:flutter_riverpod/flutter_riverpod.dart';

final rememberButtonStateProvider = StateProvider<bool>((ref) {
  return true;
},);

final showPasswordStateProvider = StateProvider<bool>((ref) {
  return false;
},);