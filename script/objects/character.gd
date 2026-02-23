# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Wisher7274

## 角色立绘控制器
## 
## 负责管理角色表情的切换与显示。
## 通过 [img_path] 指定资源目录，自动加载该目录下的表情图片。
## 
## 使用示例：
##   1. 将本脚本附加到角色场景根节点
##   2. 在 Inspector 中设置 [img_path] 为表情图片所在文件夹路径
##   3. 确保文件夹内包含对应命名的图片文件（见下方说明）
## 
## 图片命名规范：
##   {img_path}dummy.png    - 默认表情
##   {img_path}happy.png    - 开心
##   {img_path}angry.png    - 生气
##   {img_path}smile.png    - 微笑
##   {img_path}confuse.png  - 困惑
## 
## 扩展新表情：
##   1. 在 [enum status] 中添加新状态
##   2. 在 [init()] 中加载新图片资源
##   3. 在 [execute_cmd()] 中添加对应的命令分支

extends Control
class_name CharacterSprite

# 表情图片资源目录路径（末尾需带 "/"）
# 示例："res://assets/sprites/plana/"
@export var img_path: String

# 角色唯一标识符，用于剧情系统中引用此角色
@export var id: String

@onready var node_sprite = $Sprite
enum status{
	dummy,
	happy,
	angry,
	smile,
	confuse
}

# 表情状态 -> 纹理资源 的映射表
var img_resources: Dictionary = {}

# 初始化：加载所有表情图片资源
# 注意：如果图片路径或命名不正确，此处会报错
# 调试时请检查控制台输出
func init():
	img_resources[status.dummy] = load(img_path+"dummy.png")
	img_resources[status.confuse] = load(img_path+"confuse.png")
	img_resources[status.angry] = load(img_path+"angry.png")
	img_resources[status.happy] = load(img_path+"happy.png")
	img_resources[status.smile] = load(img_path+"smile.png")

## 执行表情切换命令
## 
## 由剧情系统的 [play_frame] 调用，根据 JSON 帧中的 [act] 字段触发
## 
## 支持的表情命令：
##   - "smile"   : 切换为微笑
##   - "confuse" : 切换为困惑
##   - "happy"   : 切换为开心
##   - "angry"   : 切换为生气
##   - "hide"    : 隐藏角色（不销毁，仅隐藏）
## 
## 扩展新命令：
##   在 match 分支中添加新的 case，调用 [set_sprite()] 即可
func execute_cmd(cmd: String):
	match cmd:
		"smile":
			set_sprite(img_resources[status.smile])
		"confuse":
			set_sprite(img_resources[status.confuse])
		"happy":
			set_sprite(img_resources[status.happy])
		"angry":
			set_sprite(img_resources[status.angry])
		"hide":
			self.visible = false

# 设置当前显示的表情纹理
func set_sprite(sprite: CompressedTexture2D):
	node_sprite.texture = sprite

func _ready() -> void:
	init()
	set_sprite(img_resources[status.dummy])
