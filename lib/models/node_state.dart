class NodeState {
  final bool enabled;
  final bool connected;
  final String? errorMessage;
  final List<String> capabilities;

  NodeState({
    this.enabled = false,
    this.connected = false,
    this.errorMessage,
    this.capabilities = const [],
  });

  NodeState copyWith({
    bool? enabled,
    bool? connected,
    String? errorMessage,
    List<String>? capabilities,
  }) {
    return NodeState(
      enabled: enabled ?? this.enabled,
      connected: connected ?? this.connected,
      errorMessage: errorMessage ?? this.errorMessage,
      capabilities: capabilities ?? this.capabilities,
    );
  }
}

class NodeCapability {
  final String name;
  final List<String> commands;
  final String? permission;
  final bool isImplemented;

  NodeCapability({
    required this.name,
    required this.commands,
    this.permission,
    this.isImplemented = true,
  });

  static List<NodeCapability> get defaultCapabilities => [
        NodeCapability(name: 'Camera', commands: ['camera.snap', 'camera.clip', 'camera.list'], permission: 'Camera'),
        NodeCapability(name: 'Flash', commands: ['flash.on', 'flash.off', 'flash.toggle', 'flash.status'], permission: 'Camera'),
        NodeCapability(name: 'Location', commands: ['location.get'], permission: 'Location'),
        NodeCapability(name: 'Screen', commands: ['screen.record'], permission: 'MediaProjection'),
        NodeCapability(name: 'Sensor', commands: ['sensor.read', 'sensor.list'], permission: 'Body Sensors'),
        NodeCapability(name: 'Haptic', commands: ['haptic.vibrate'], permission: null),
      ];
}
