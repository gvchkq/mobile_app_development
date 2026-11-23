class MainScreenState {
  final double? interest;
  final double? total;
  final String? errorMessage;
  final bool isCalculated;

  const MainScreenState({
    this.interest,
    this.total,
    this.errorMessage,
    this.isCalculated = false,
  });
}