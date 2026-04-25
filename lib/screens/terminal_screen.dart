import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';
import '../constants.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  late Terminal _terminal;
  final _terminalController = TerminalController();

  @override
  void initState() {
    super.initState();
    _terminal = Terminal(
      maxLines: 10000,
    );
    _setupTerminal();
  }

  void _setupTerminal() {
    _terminal.write('Hermes Agent Terminal\r\n');
    _terminal.write('Type "hermes" to start chatting or "hermes --help" for commands\r\n\r\n\$ ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Terminal'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _terminal.buffer.clear();
              _setupTerminal();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.all(8),
              child: TerminalView(
                _terminal,
                controller: _terminalController,
                autofocus: true,
                backgroundOpacity: 1.0,
                textStyle: const TerminalStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          _ToolbarKey(label: 'Tab', onTap: () => _sendKey('\t')),
          _ToolbarKey(label: 'Ctrl', onTap: () => _sendKey('\x03')),
          _ToolbarKey(label: 'Esc', onTap: () => _sendKey('\x1B')),
          _ToolbarKey(label: '↑', onTap: () => _sendKey('\x1B[A')),
          _ToolbarKey(label: '↓', onTap: () => _sendKey('\x1B[B')),
          _ToolbarKey(label: '→', onTap: () => _sendKey('\x1B[C')),
          _ToolbarKey(label: '←', onTap: () => _sendKey('\x1B[D')),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _sendKey(String key) {
    _terminal.sendKey(key);
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Terminal Help', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Commands:\n'
          '  hermes          - Start interactive chat\n'
          '  hermes model    - Change model\n'
          '  hermes tools    - Configure tools\n'
          '  hermes config    - View/edit config\n'
          '  hermes gateway   - Start messaging gateway\n'
          '  hermes doctor    - Diagnose issues\n\n'
          'Keyboard shortcuts:\n'
          '  Tab    - Autocomplete\n'
          '  Ctrl+C - Interrupt\n'
          '  Esc    - Cancel input',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(4),
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
