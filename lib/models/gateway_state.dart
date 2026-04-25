enum GatewayStatus {
  stopped,
  starting,
  running,
  stopping,
  error,
}

class GatewayState {
  final GatewayStatus status;
  final String? errorMessage;
  final String? tokenUrl;
  final DateTime? startedAt;
  final String? version;

  GatewayState({
    this.status = GatewayStatus.stopped,
    this.errorMessage,
    this.tokenUrl,
    this.startedAt,
    this.version,
  });

  GatewayState copyWith({
    GatewayStatus? status,
    String? errorMessage,
    String? tokenUrl,
    DateTime? startedAt,
    String? version,
  }) {
    return GatewayState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      tokenUrl: tokenUrl ?? this.tokenUrl,
      startedAt: startedAt ?? this.startedAt,
      version: version ?? this.version,
    );
  }

  bool get isRunning => status == GatewayStatus.running;
  bool get isStopped => status == GatewayStatus.stopped;
  bool get isLoading =>
      status == GatewayStatus.starting || status == GatewayStatus.stopping;
}
