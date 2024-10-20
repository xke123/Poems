

# 项目名称及应用截图
- 项目名称及来源
  项目名称是“句读”（dòu），灵感来自我非常喜欢的一句歌词：“飞绪何筹飘零逐流，又起褶皱。苏醒以后，满天句读”。
  句读是古代中文书写时用以标记休止和停顿的符号。在古代，中文书写并没有标点符号，但为了确保阅读时语气顺畅、意思传达准确，读书人会使用圈点法在文中自行添加记号，这就是句读的起源。

- 简洁的徽标或屏幕截图
  - 应用截图
    
    <img src="https://blog-1251963815.cos.ap-beijing.myqcloud.com/2024/202410191948094.png" alt="截图1" width="240"> <img src="https://blog-1251963815.cos.ap-beijing.myqcloud.com/2024/202410191949016.png" alt="截图2" width="240"> <img src="https://blog-1251963815.cos.ap-beijing.myqcloud.com/2024/202410191949031.png" alt="截图3" width="240">

## 简介
- 本项目整合了多个数据源的大型数据库，为80多万首诗词古文、3万多位作者和6000多句名言提供了一个丰富的用户界面，让中华文化的璀璨光芒跃然纸上。
- 希望各位诗词古文爱好者通过这款应用，能够更加方便地了解和欣赏这些诗词和古文。

## 功能列表
- 本项目包含以下三个主要功能模块：
  - **诗词名句卡片**：每次进入应用时自动刷新，获取新的名句数据。用户还可以通过滑动卡片进行刷新。
  - **分类检索**：分为上下两个区域。上半部分的随机数据窗会随机从数据库获取4个朝代、4个作品集和8位作者的数据，点击可以进入详情页。下半部分则可以点击查看不同朝代、作者、作品集及文体的诗词古文。
  - **搜索页面**：通过多种筛选选项（如朝代、作者、作品名、诗句等）进行详细搜索。

## app获取
- iOS 端
  - iOS端可以通过此链接加入test flight 测试进行获取
  - https://testflight.apple.com/join/08hBSAIV
- Android 端
  - Android 端可以在release中获取,或是通过以下链接获取
  - https://blog-1251963815.cos.ap-beijing.myqcloud.com/app-debug.apk
## 演示
- GIF 动画、图片或视频展示主要功能。
- 应用的截图，展示核心界面或特色界面。

## 安装步骤
- **数据库处理**
  - 有关数据库处理的详细信息，请参见 `assets/database/` 目录中的 `readme.md` 文件。

- **如何在本地运行项目**
  - 创建一个新的 Flutter 项目。
  - 克隆本项目。
  - 替换 `lib` 目录、`assets` 目录，以及 `pubspec.yaml` 文件。
  - 运行项目。

## 架构
- **项目架构设计**
  - 本项目基本遵循 MVVM 设计规范。
  - 页面之间的关系可以查看各主要页面的 `import` 部分。

- **项目的文件夹结构介绍**
  - **基本介绍**
    - `lib` 目录中包含主要的代码文件。数据模型相关的文件放在 `models` 文件夹中，页面文件放在 `pages` 文件夹中，数据查询相关的方法放在 `services` 文件夹中，`widgets` 文件夹中包含一些可复用的组件。
  - **名句页相关文件**
    - 页面代码在 `quote_display_page.dart` 中。
    - 此页面调用了 `quote_card.dart` 组件。
  - **分类页相关文件**
    - 页面代码在 `quotes_by_category_page.dart` 中。
    - 上半部分随机数据窗的代码在 `top_content_widget.dart` 中。
    - 下半部分分类数据滚动列表的代码在 `bottom_content_widget.dart` 中。
  - **搜索及搜索结果页相关文件**
    - 搜索页代码在 `search_page.dart` 中。
    - 搜索结果页代码位于 `/pages/search/` 目录下。

## 参考项目
- 本项目的数据来源于以下几个开源项目，经过整合和删减后使用：
  - [chinese-poetry-and-prose](https://github.com/VMIJUNV/chinese-poetry-and-prose)
  - [chinese-gushiwen](https://github.com/caoxingyu/chinese-gushiwen)
