import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/fee_model.dart';
import '../services/fee_service.dart';

final feeServiceProvider = Provider<FeeService>((_) => FeeService());

class FeeState {
  final List<FeeModel> fees;
  final bool isLoading;
  final String? error;

  const FeeState({this.fees = const [], this.isLoading = false, this.error});

  FeeState copyWith({List<FeeModel>? fees, bool? isLoading, String? error}) {
    return FeeState(
      fees: fees ?? this.fees,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FeeNotifier extends StateNotifier<FeeState> {
  final FeeService _service;

  FeeNotifier(this._service) : super(const FeeState());

  Future<void> getFees() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _service.getFees();
      state = state.copyWith(fees: response.data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final feeProvider = StateNotifierProvider<FeeNotifier, FeeState>(
  (ref) => FeeNotifier(ref.read(feeServiceProvider)),
);
