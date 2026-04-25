enum SetupStep {
  welcome,
  installing,
  configuring,
  completing,
  error,
}

class SetupState {
  final SetupStep step;
  final double progress;
  final String currentMessage;
  final String? errorMessage;
  final bool isComplete;

  SetupState({
    this.step = SetupStep.welcome,
    this.progress = 0.0,
    this.currentMessage = '',
    this.errorMessage,
    this.isComplete = false,
  });

  SetupState copyWith({
    SetupStep? step,
    double? progress,
    String? currentMessage,
    String? errorMessage,
    bool? isComplete,
  }) {
    return SetupState(
      step: step ?? this.step,
      progress: progress ?? this.progress,
      currentMessage: currentMessage ?? this.currentMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
