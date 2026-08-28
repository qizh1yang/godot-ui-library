extends Node
## 全局 UI 信号总线（autoload 注册名：UISignalBus）。
## 注意：本脚本【不加 class_name】——autoload 名本身即是全局标识符，
## 加 class_name 会报 "hides an autoload singleton" 解析错误。
##
## 组件零依赖原则——组件【不强制】使用本总线，组件对外信号（toggled/clicked/opened...）
## 直接定义在组件自身。本总线仅用于跨组件/跨场景的可选通信（如弹窗全局通知、Showcase 导航）。

## 弹窗打开/关闭（跨场景通知，如同时关闭其他弹窗）。
signal popup_opened(popup: Node)
signal popup_closed(popup: Node)

## 全局通知请求（如顶部 Toast）。
signal notification_requested(message: String)

## 场景/演示切换请求（Showcase 导航）。
signal scene_change_requested(scene_path: String)
signal demo_selected(demo_id: String)
