import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormData{
  String inputType;
  String? error;

  FormData({
    required this.inputType,
    this.error
  });

  FormData copyWith({String? newError}){
    return FormData(inputType: inputType, error: newError);
  }
}

class FormStateNotifier extends StateNotifier<FormData>{
  FormStateNotifier({
    required FormData initialFormState
  }) : super(initialFormState);

  bool validate(String input){
    if(input.trim().isEmpty){
      state = state.copyWith(newError: "Field cannot be empty");
      return true;
    }else{
      state = state.copyWith(newError: null);
      return false;
    }
  }

  void updateError(String? newError){
    state = state.copyWith(newError: newError);
  }
}

final emailStateNotifierProvider = StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier(initialFormState: FormData(inputType: 'email', error: null));
},);

final passwordStateNotifierProvider = StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier(initialFormState: FormData(inputType: 'password', error: null));
},);

final usernameStateNotifierProvider = StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier(initialFormState: FormData(inputType: 'username', error: null));
},);

final confirmPasswordStateNotifierProvider = StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier(initialFormState: FormData(inputType: 'password', error: null));
},);

final titleStateNotifierProvider = StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier(initialFormState: FormData(inputType: "title", error: null));
},);

final descriptionNotifierProvider = StateNotifierProvider<FormStateNotifier, FormData>((ref) {
  return FormStateNotifier(initialFormState: FormData(inputType: "description", error: null));
},);