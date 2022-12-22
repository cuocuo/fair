import 'package:fair_online/app/themes.dart';
import 'package:fair_online/editor/component/analyze_widget.dart';
import 'package:fair_online/editor/component/editor_panel_widget.dart';
import 'package:fair_online/editor/component/flutter_editor_controller.dart';
import 'package:fair_online/editor/component/flutter_editor_widget.dart';
import 'package:fair_online/editor/component/preview_widget.dart';
import 'package:fair_online/models/editor_example_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Example1 extends StatefulWidget {
  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  late FlutterEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = FlutterEditorController(key: "example1");
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return LayoutBuilder(builder: (context, dimens) {
      return Row(
        children: [
          Container(
            width: dimens.maxWidth * 2 / 5,
            height: dimens.maxHeight,

            ///代码编辑器
            child: FlutterEditor(controller: controller),
          ),
          Builder(builder: (context) {
            final rightWidth = dimens.maxWidth * 3 / 5;
            return Container(
              width: rightWidth,
              height: dimens.maxHeight,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: Colors.white70,
                      width: rightWidth / 2,
                      height: 500,

                      ///预览
                      child: Preview(
                        controller: controller,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: rightWidth / 2,
                      height: 400,
                      color: Colors.blueGrey,

                      ///编辑器联动面板（Console）
                      child: EditorPanel(
                          controller: controller,
                          onArrowPressed: () {
                            EditorExampleModel model = context.read();
                            model.isEditorPanelShow = !model.isEditorPanelShow;
                          },
                          isExpandEnabled: false),
                    ),
                  ),

                  ///run按钮
                  ValueListenableBuilder<bool>(
                      valueListenable: controller.isRunningNotifier,
                      builder: (context, value, child) {
                        return ElevatedButton.icon(
                            icon: value
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          theme.accent1Darker),
                                      backgroundColor: theme.grey,
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                : Icon(
                                    Icons.play_arrow,
                                    size: 20,
                                  ),
                            label: Text('Run'),
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(100, 50)),
                              backgroundColor: MaterialStateProperty.all(
                                  value ? theme.bg2 : theme.accent1),
                            ),
                            onPressed: () {
                              controller.handleRun();
                            });
                      }),

                  ///analyze视图
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          width: 420,
                          height: 400,
                          child: Analyze(controller: controller)))
                ],
              ),
            );
          })
        ],
      );
    });
  }
}
