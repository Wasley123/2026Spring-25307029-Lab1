# TicTacToeGame - 鸿蒙 ArkTS 井字棋小游戏 🎮

一个基于鸿蒙 ArkTS 开发的双人对战井字棋小游戏，实现了基础的棋盘绘制、轮流落子、胜负判断与平局检测功能。

---

## ✨ 项目功能
- 双人轮流对战：玩家分别使用 O/X 标记，交替落子
- 胜负判断：自动识别横、竖、斜向三连获胜条件
- 平局检测：棋盘填满无获胜方时自动判定平局
- 界面简洁：适配鸿蒙系统的基础 UI 布局，交互清晰

---

## 🛠️ 开发环境与依赖
- 开发语言：ArkTS（HarmonyOS 开发语言）
- 开发工具：DevEco Studio 或 VS Code（安装鸿蒙开发插件）
- 项目类型：鸿蒙 ArkTS 应用
- 依赖管理：ohpm（鸿蒙包管理工具）

---

## 🚀 如何运行项目

### 1. 前置准备
1.  安装 DevEco Studio，并配置好鸿蒙 SDK（建议 API 版本 9+）
2.  克隆本仓库到本地：
    ```bash
    git clone https://github.com/Wasley123/2026Spring-25307029-Lab1.git
    cd 2026Spring-25307029-Lab1/TicTacToeGame
    ```

### 2. 安装依赖
在项目根目录执行鸿蒙包管理命令，安装项目依赖：
```bash
ohpm install
