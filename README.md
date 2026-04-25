# Hermes Agent Android Client

基于 Nous Research 的 [hermes-agent](https://github.com/NousResearch/hermes-agent) 制作的安卓客户端，参考 [openclaw-termux](https://github.com/mithun50/openclaw-termux) 的架构设计。

## 功能特性

- **完整终端界面** - 内置终端模拟器，支持 hermes 命令行交互
- **消息网关控制** - 启动/停止 Telegram、Discord、Slack 等平台的网关
- **节点能力** - 支持相机、闪光灯、定位、传感器、屏幕录制等设备能力
- **AI 模型配置** - 支持 Nous Portal、OpenRouter、OpenAI、Anthropic、Google Gemini 等多种 AI 提供商
- **实时日志** - 网关日志实时查看和过滤
- **自启动设置** - 可配置应用启动时自动开启网关

## 构建要求

- Flutter SDK 3.24.0+
- Android SDK (API 29+)
- Android 10+ 设备

## 构建步骤

1. **安装 Flutter SDK**
   ```bash
   cd ~
   git clone https://github.com/flutter/flutter.git -b stable --depth 1
   export PATH="$PATH:$HOME/flutter/bin"
   flutter doctor
   ```

2. **获取依赖**
   ```bash
   cd hermes_agent_android
   flutter pub get
   ```

3. **构建 APK**
   ```bash
   flutter build apk --release
   ```

   或调试版本：
   ```bash
   flutter build apk --debug
   ```

4. **APK 输出位置**
   - Release: `build/app/outputs/flutter-apk/app-release.apk`
   - Debug: `build/app/outputs/flutter-apk/app-debug.apk`

## 项目结构

```
hermes_agent_android/
├── lib/
│   ├── main.dart              # 应用入口
│   ├── constants.dart         # 常量定义
│   ├── models/                # 数据模型
│   │   ├── ai_provider.dart
│   │   ├── gateway_state.dart
│   │   ├── node_state.dart
│   │   └── setup_state.dart
│   ├── providers/             # 状态管理
│   │   ├── gateway_provider.dart
│   │   ├── node_provider.dart
│   │   └── setup_provider.dart
│   ├── screens/               # 界面
│   │   ├── splash_screen.dart
│   │   ├── setup_wizard_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── terminal_screen.dart
│   │   ├── providers_screen.dart
│   │   ├── logs_screen.dart
│   │   └── settings_screen.dart
│   ├── services/              # 业务逻辑
│   │   ├── gateway_service.dart
│   │   ├── bootstrap_service.dart
│   │   ├── node_service.dart
│   │   └── preferences_service.dart
│   └── widgets/               # 通用组件
│       ├── gateway_controls.dart
│       ├── node_controls.dart
│       ├── terminal_toolbar.dart
│       ├── status_card.dart
│       └── progress_step.dart
└── android/                   # Android 原生配置
```

## Hermes Agent CLI 命令

- `hermes` - 启动交互式聊天
- `hermes model` - 选择 LLM 提供商和模型
- `hermes tools` - 配置启用的工具
- `hermes config set` - 设置配置项
- `hermes gateway` - 启动消息网关
- `hermes setup` - 运行完整设置向导
- `hermes doctor` - 诊断问题

## 支持的 AI 提供商

- Nous Portal
- OpenRouter (200+ 模型)
- OpenAI
- Anthropic
- Google Gemini
- NVIDIA NIM
- DeepSeek
- 以及更多...

## 消息平台

- Telegram
- Discord
- Slack
- WhatsApp
- Signal
- Email

## 许可

MIT License - 基于 [hermes-agent](https://github.com/NousResearch/hermes-agent)
