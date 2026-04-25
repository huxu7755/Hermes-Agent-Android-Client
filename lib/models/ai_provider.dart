class AiProvider {
  final String id;
  final String name;
  final String icon;
  final String? apiKey;
  final String? selectedModel;
  final List<String> availableModels;
  final bool isConfigured;

  AiProvider({
    required this.id,
    required this.name,
    required this.icon,
    this.apiKey,
    this.selectedModel,
    this.availableModels = const [],
    this.isConfigured = false,
  });

  AiProvider copyWith({
    String? apiKey,
    String? selectedModel,
    List<String>? availableModels,
    bool? isConfigured,
  }) {
    return AiProvider(
      id: id,
      name: name,
      icon: icon,
      apiKey: apiKey ?? this.apiKey,
      selectedModel: selectedModel ?? this.selectedModel,
      availableModels: availableModels ?? this.availableModels,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }

  static List<AiProvider> get defaultProviders => [
        AiProvider(
          id: 'nous_portal',
          name: 'Nous Portal',
          icon: '🔮',
          availableModels: ['-nous/nousresearch/hermes-3-llama-3-405b'],
        ),
        AiProvider(
          id: 'openrouter',
          name: 'OpenRouter',
          icon: '🌐',
          availableModels: [
            'anthropic/claude-3-5-sonnet',
            'openai/gpt-4-turbo',
            'google/gemini-pro-1.5',
          ],
        ),
        AiProvider(
          id: 'openai',
          name: 'OpenAI',
          icon: '🤖',
          availableModels: ['gpt-4-turbo', 'gpt-3.5-turbo'],
        ),
        AiProvider(
          id: 'anthropic',
          name: 'Anthropic',
          icon: '🧠',
          availableModels: ['claude-3-5-sonnet', 'claude-3-opus'],
        ),
        AiProvider(
          id: 'google',
          name: 'Google Gemini',
          icon: '✨',
          availableModels: ['gemini-pro-1.5', 'gemini-ultra'],
        ),
        AiProvider(
          id: 'nvidia_nim',
          name: 'NVIDIA NIM',
          icon: '🚀',
          availableModels: ['nemotron-4-340b'],
        ),
        AiProvider(
          id: 'deepseek',
          name: 'DeepSeek',
          icon: '🔍',
          availableModels: ['deepseek-chat', 'deepseek-coder'],
        ),
      ];
}
