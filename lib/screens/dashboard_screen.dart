import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/gateway_provider.dart';
import '../providers/node_provider.dart';
import '../models/gateway_state.dart';
import '../widgets/gateway_controls.dart';
import '../widgets/node_controls.dart';
import 'terminal_screen.dart';
import 'providers_screen.dart';
import 'logs_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GatewayProvider>().checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Hermes Agent',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GatewayControls(),
            const SizedBox(height: 16),
            const NodeControls(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildSystemInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.terminal,
                    label: 'Terminal',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TerminalScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.cloud,
                    label: 'Providers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProvidersScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.article,
                    label: 'Logs',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LogsScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer<GatewayProvider>(
                    builder: (context, provider, _) {
                      return _ActionButton(
                        icon: Icons.refresh,
                        label: 'Restart',
                        onTap: () async {
                          if (provider.state.isRunning) {
                            await provider.stopGateway();
                          }
                          await provider.startGateway();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfo() {
    return Consumer<GatewayProvider>(
      builder: (context, provider, _) {
        final uptime = provider.state.startedAt != null
            ? DateTime.now().difference(provider.state.startedAt!)
            : null;

        return Card(
          color: AppColors.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Info',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  label: 'Status',
                  value: _getStatusText(provider.state.status),
                  valueColor: _getStatusColor(provider.state.status),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Version',
                  value: provider.state.version ?? 'Unknown',
                ),
                if (uptime != null) ...[
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Uptime',
                    value: _formatDuration(uptime),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(GatewayStatus status) {
    switch (status) {
      case GatewayStatus.stopped:
        return 'Stopped';
      case GatewayStatus.starting:
        return 'Starting...';
      case GatewayStatus.running:
        return 'Running';
      case GatewayStatus.stopping:
        return 'Stopping...';
      case GatewayStatus.error:
        return 'Error';
    }
  }

  Color _getStatusColor(GatewayStatus status) {
    switch (status) {
      case GatewayStatus.stopped:
        return Colors.grey;
      case GatewayStatus.starting:
      case GatewayStatus.stopping:
        return AppColors.warning;
      case GatewayStatus.running:
        return AppColors.success;
      case GatewayStatus.error:
        return AppColors.error;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
