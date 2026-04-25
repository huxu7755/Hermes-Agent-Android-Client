import 'package:flutter/material.dart';
import '../constants.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final List<String> _outputLines = [];
  String _currentInput = '';

  @override
  void initState() {
    super.initState();
    _outputLines.add('Hermes Agent Terminal');
    _outputLines.add('Type "hermes" to start chatting or "hermes --help" for commands');
    _outputLines.add('');
  }

  void _handleSubmit(String value) {
    setState(() {
      _outputLines.add('\$ $value');
      _currentInput = value;
      if (value.trim().toLowerCase() == 'hermes') {
        _outputLines.add('Starting hermes agent...');
      } else if (value.trim().toLowerCase() == 'clear') {
        _outputLines.clear();
        _outputLines.add('Terminal cleared');
      } else {
        _outputLines.add('Command not found: $value');
      }
      _outputLines.add('');
    });
    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              setState(() {
                _outputLines.clear();
                _outputLines.add('Terminal cleared');
              });
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
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _outputLines.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _outputLines[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Text(
            '\$ ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              color: AppColors.accent,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Type command...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: _handleSubmit,
              onChanged: (value) {
                _currentInput = value;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: () => _handleSubmit(_textController.text),
          ),
        ],
      ),
    );
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
          '  hermes config   - View/edit config\n'
          '  hermes gateway  - Start messaging gateway\n'
          '  hermes doctor   - Diagnose issues\n'
          '  clear           - Clear terminal',
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
