import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/gateway_provider.dart';
import '../models/gateway_state.dart';

class GatewayControls extends StatelessWidget {
  const GatewayControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GatewayProvider>(
      builder: (context, provider, _) {
        return Card(
          color: AppColors.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getStatusColor(provider.state.status),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(provider.state.status).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gateway Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusText(provider.state.status),
                            style: TextStyle(
                              color: _getStatusColor(provider.state.status),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.state.isRunning && provider.state.tokenUrl != null)
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        color: Colors.white54,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: provider.state.tokenUrl!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (provider.state.isRunning && provider.state.tokenUrl != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.link,
                          color: AppColors.accent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.state.tokenUrl!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: provider.state.isLoading
                        ? null
                        : () async {
                            if (provider.state.isRunning) {
                              await provider.stopGateway();
                            } else {
                              await provider.startGateway();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.state.isRunning
                          ? AppColors.error
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: provider.state.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                provider.state.isRunning
                                    ? Icons.stop
                                    : Icons.play_arrow,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                provider.state.isRunning
                                    ? 'Stop Gateway'
                                    : 'Start Gateway',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (provider.state.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.state.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
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
}
