import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/db_service.dart';
import '../models/quote_model.dart';
import 'dart:math';
import '../pages/quote_display_page.dart'; // 确保路径正确
import '../main.dart';

class MarqueeQuotePage extends StatefulWidget {
  @override
  _MarqueeQuotePageState createState() => _MarqueeQuotePageState();
}

class _MarqueeQuotePageState extends State<MarqueeQuotePage>
    with TickerProviderStateMixin {
  List<QuoteModel> _quotes = [];
  bool _isLoading = true;

  final int _displayCount = 50; // 同屏显示的文字数量
  final int _totalQuotes = 100; // 后台获取的总数据量

  List<_MovingText> _movingTexts = [];

  // Logo动画控制器和动画
  late final AnimationController _logoController;
  late final Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化Logo动画
    _logoController = AnimationController(
      duration: Duration(milliseconds: 1000), // 1秒淡入
      vsync: this,
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeIn,
      ),
    );

    // 设置Logo动画在初始文字动画的第2秒开始
    Future.delayed(Duration(milliseconds: 2000), () {
      if (mounted) {
        _logoController.forward();
        _loadQuotes();
      }
    });
  }

  Future<void> _loadQuotes() async {
    bool success = false;

    try {
      // 获取100组数据
      List<QuoteModel> quotes = await DbService.getRandomSentence(_totalQuotes);
      setState(() {
        _quotes = quotes;
      });
      success = true;

      // 初始化移动文字，标记为初始文字
      _initializeMovingTexts();

      // 设置在动画总时长后导航到QuoteDisplayPage
      Future.delayed(Duration(milliseconds: 5000), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000), // 1秒过渡
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MainPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Incoming page动画：缩放和渐显
                final scaleAnimation =
                    Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                );

                final fadeAnimation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                );

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  ),
                );
              },
            ),
          );
        }
      });
    } catch (e) {
      print('获取名句失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败，请重试！')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (!success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainPage()),
        );
      }
    }
  }

  void _initializeMovingTexts() {
    for (int i = 0; i < _displayCount; i++) {
      _addMovingText(isInitial: true);
    }
  }

  void _addMovingText({bool isInitial = false}) {
    if (_quotes.isEmpty) return;

    final random = Random();

    // 随机选择一句名句的片段
    final quote = _quotes[random.nextInt(_quotes.length)];
    final sentences = quote.content.split(RegExp(r'[。！？；，,.!?;]'));
    sentences.removeWhere((s) => s.trim().isEmpty);
    if (sentences.isEmpty) return;

    // 限制文字长度，防止过长
    final maxLength = 15;
    String content = sentences[random.nextInt(sentences.length)];
    if (content.length > maxLength) {
      content = content.substring(0, maxLength) + '...';
    }

    // 随机文字大小
    final fontSize = 16 + random.nextInt(20).toDouble();

    final isHorizontal = random.nextBool(); // 随机方向

    // 获取屏幕尺寸
    final screenSize = MediaQuery.of(context).size;

    // 竖排文字处理
    String displayContent =
        isHorizontal ? content : content.split('').join('\n');

    // 计算文字的实际尺寸
    final textPainter = TextPainter(
      text: TextSpan(
        text: displayContent,
        style: TextStyle(fontSize: fontSize),
      ),
      maxLines: isHorizontal ? 1 : null,
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // 随机起始和结束位置
    Offset startPosition, endPosition;

    if (isHorizontal) {
      // 横向移动

      // 随机移动方向（左或右）
      final moveLeftToRight = random.nextBool();

      // Y 轴随机位置（在屏幕内）
      final startY = random.nextDouble() * (screenSize.height - textHeight);

      double startX, endX;

      if (isInitial) {
        // 初始文字，起始位置在屏幕内随机
        startX = random.nextDouble() * (screenSize.width - textWidth);
      } else {
        // 后续文字，起始位置在屏幕边缘外
        startX = moveLeftToRight ? -textWidth : screenSize.width + textWidth;
      }

      // 计算结束位置
      endX = moveLeftToRight ? screenSize.width + textWidth : -textWidth;

      startPosition = Offset(startX, startY);
      endPosition = Offset(endX, startY);
    } else {
      // 竖向移动

      // 随机移动方向（上或下）
      final moveTopToBottom = random.nextBool();

      // X 轴随机位置（在屏幕内）
      final startX = random.nextDouble() * (screenSize.width - textWidth);

      double startY, endY;

      if (isInitial) {
        // 初始文字，起始位置在屏幕内随机
        startY = random.nextDouble() * (screenSize.height - textHeight);
      } else {
        // 后续文字，起始位置在屏幕边缘外
        startY = moveTopToBottom ? -textHeight : screenSize.height + textHeight;
      }

      // 计算结束位置
      endY = moveTopToBottom ? screenSize.height + textHeight : -textHeight;

      startPosition = Offset(startX, startY);
      endPosition = Offset(startX, endY);
    }

    // 设置固定动画持续时间：1秒缩放 + 3秒移动 + 1秒淡出 = 5秒
    final duration = Duration(seconds: 5);

    // 创建移动文字对象
    late _MovingText movingText; // 先声明

    movingText = _MovingText(
      content: displayContent,
      fontSize: fontSize,
      startPosition: startPosition,
      endPosition: endPosition,
      duration: duration,
      onCompleted: () {
        // 动画完成后替换为新的文字
        setState(() {
          _movingTexts.remove(movingText);
          _addMovingText(isInitial: false); // 后续文字从屏幕边缘开始
        });
      },
      vsync: this,
    );

    setState(() {
      _movingTexts.add(movingText);
    });
  }

  @override
  void dispose() {
    // 释放所有动画控制器
    for (var movingText in _movingTexts) {
      movingText.dispose();
    }

    // 释放Logo动画控制器
    _logoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Stack(
            children: [
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ..._movingTexts
                    .map((movingText) => movingText.build(context))
                    .toList(),

              // Logo
              Align(
                alignment: Alignment.center,
                child: FadeTransition(
                  opacity: _logoOpacityAnimation,
                  child: Hero(
                    tag: 'logoHero',
                    flightShuttleBuilder: (flightContext, animation,
                        flightDirection, fromHeroContext, toHeroContext) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 3.0 * (1 - animation.value), // 缩小比例
                            child: Opacity(
                              opacity: 1.0 - animation.value, // 渐隐
                              child: LogoWidget(),
                            ),
                          );
                        },
                      );
                    },
                    child: LogoWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovingText {
  final String content;
  final double fontSize;
  final Offset startPosition;
  final Offset endPosition;
  final Duration duration;
  final VoidCallback onCompleted;
  final TickerProvider vsync;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _positionAnimation;
  // late final Animation<double> _opacityAnimation;

  _MovingText({
    required this.content,
    required this.fontSize,
    required this.startPosition,
    required this.endPosition,
    required this.duration,
    required this.onCompleted,
    required this.vsync,
  }) {
    _controller = AnimationController(duration: duration, vsync: vsync)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          dispose();
          onCompleted();
        }
      });

    // 第一阶段：缩放动画（0.0 - 0.2） 从大到正常
    _scaleAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    // 第二阶段：移动动画（0.3 - 0.8）
    _positionAnimation =
        Tween<Offset>(begin: startPosition, end: endPosition).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    // 第三阶段：透明度动画（0.8 - 1.0）
    // _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: Interval(0.99, 1.0, curve: Curves.easeOut),
    //   ),
    // );

    _controller.forward();
  }

  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: 1.0, // 固定为不透明
              child: Text(
                content,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                  fontFamily: 'Kangxi',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  void dispose() {
    _controller.dispose();
  }
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // 根据需要调整背景色
        borderRadius: BorderRadius.circular(20), // 圆角半径
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // 阴影颜色
            blurRadius: 10, // 模糊半径
            spreadRadius: 2, // 扩散半径
            offset: Offset(0, 4), // 阴影偏移
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // 与Container一致
        child: Image.asset(
          'assets/icon/app_icon.png', // 请替换为您的Logo图片路径
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
