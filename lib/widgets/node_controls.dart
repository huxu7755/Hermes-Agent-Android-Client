import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/node_provider.dart';
import '../models/node_state.dart';

class NodeControls extends StatelessWidget {
  const NodeControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NodeProvider>(
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
                        color: provider.state.connected
                            ? AppColors.success
                            : Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: (provider.state.connected
                                    ? AppColors.success
                                    : Colors.grey)
                                .withOpacity(0.5),
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
                            'Node Connection',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.state.connected
                                ? 'Connected'
                                : 'Disconnected',
                            style: TextStyle(
                              color: provider.state.connected
                                  ? AppColors.success
                                  : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (provider.state.connected) {
                        await provider.disableNode();
                      } else {
                        await provider.enableNode();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.state.connected
                          ? AppColors.warning
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          provider.state.connected
                              ? Icons.link_off
                              : Icons.link,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          provider.state.connected
                              ? 'Disconnect'
                              : 'Connect',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                if (provider.state.capabilities.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Capabilities',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: provider.state.capabilities.map((cap) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          cap,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
