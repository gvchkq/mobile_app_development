class HistoryState {
  final List<Map<String, dynamic>> calculations;
  final bool isLoading;
  final String? errorMessage;

  const HistoryState({
    this.calculations = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}