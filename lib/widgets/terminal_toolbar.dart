import 'package:flutter/material.dart';
import '../constants.dart';

class TerminalToolbar extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback? onClear;

  const TerminalToolbar({
    super.key,
    required this.onKeyTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          _ToolbarKey(label: 'Tab', onTap: () => onKeyTap('\t')),
          _ToolbarKey(label: 'Ctrl', onTap: () => onKeyTap('\x03')),
          _ToolbarKey(label: 'Esc', onTap: () => onKeyTap('\x1B')),
          _ToolbarKey(label: '↑', onTap: () => onKeyTap('\x1B[A')),
          _ToolbarKey(label: '↓', onTap: () => onKeyTap('\x1B[B')),
          _ToolbarKey(label: '→', onTap: () => onKeyTap('\x1B[C')),
          _ToolbarKey(label: '←', onTap: () => onKeyTap('\x1B[D')),
          const Spacer(),
          if (onClear != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
              onPressed: onClear,
              tooltip: 'Clear',
            ),
          IconButton(
            icon: const Icon(Icons.keyboard, color: Colors.white70, size: 20),
            onPressed: () {},
            tooltip: 'Keyboard',
          ),
        ],
      ),
    );
  }
}

class _ToolbarKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ToolbarKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
