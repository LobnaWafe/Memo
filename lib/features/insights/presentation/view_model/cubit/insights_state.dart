part of 'insights_cubit.dart';

@immutable
sealed class InsightsState {}

final class InsightsInitial extends InsightsState {}
final class InsightsLoading extends InsightsState {}
final class InsightsSuccess extends InsightsState {
  final List<MemoryModel> memoryModel;

  InsightsSuccess({required this.memoryModel});
}
final class InsightsFailure extends InsightsState {
  final String errMsg;

  InsightsFailure({required this.errMsg});

}