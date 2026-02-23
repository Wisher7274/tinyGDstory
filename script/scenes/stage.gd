# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Wisher7274
"""
author: Wisher7274
版本：v1.1 (并行执行与体验优化)
"""
extends Control

@export_group("Paths")
@export var default_dialogue_path: String = "res://source/dialogue/chapter_1/ep_1.txt"	#剧情文件的位置
@export var character_scene_path: String = "res://scenes/object/Character.tscn" #角色立绘类（场景文件）的位置

@export_group("Settings")
@export var default_font_size: int = 20
@export var default_typing_delay: float = 0.05

# --- 舞台节点 ---
@onready var node_text: Label = $DialogBox/Text
@onready var node_who: Label = $DialogBox/Who
@onready var node_title: Label = $DialogBox/Who/Who_Title
@onready var node_bg: TextureRect = $Background
# 全屏提示节点（确保场景中有这个节点）
@onready var ui_cover: Control = $fullscreen_cover 
@onready var ui_notice: Control = $fullscreen_cover/Notice
@onready var ui_text: Label = $fullscreen_cover/Text

# --- 数据 ---
var frames_data: Array = []
var dialogue_header: Dictionary = {"char": {}, "scene": {}}
var char_sprites: Dictionary = {}
var scene_bgs: Dictionary = {}

# --- 状态 ---
var current_idx: int = 0
var is_input_locked: bool = false  # 输入锁，防止菜单打开时跳过剧情
var skip_typing: bool = false      # 打字机跳过标志
var need_ctc: bool = true
var sound_players := []

# --- 信号 ---
signal ctc
signal typing_finished

func _ready() -> void:
	
	# 初始化 UI 字体
	init_ui()
	
	# 加载剧情
	load_dialogue_file(default_dialogue_path)
	
	# 初始化资源 (仅一次)
	init_resources()
	
	# 开始运行
	run()

func _exit_tree() -> void:
	# 清理资源，防止重入场景时重复添加节点
	for ch in char_sprites.values():
		if is_instance_valid(ch):
			ch.queue_free()
	char_sprites.clear()
	scene_bgs.clear()
	frames_data.clear()
	dialogue_header = {"char": {}, "scene": {}}

func init_ui():
	var font_size = default_font_size
	node_text.add_theme_font_size_override("font_size", font_size)
	node_text.text = ""
	node_title.text = ""
	node_who.text = ""

func init_resources(): 
	# 加载角色立绘资源
	for id in dialogue_header["char"]:
		var packed: PackedScene = load("res://scenes/object/Character.tscn")
		var char_instance: CharacterSprite = packed.instantiate()
		# 确保数据存在
		if dialogue_header["char"][id].has("img_path"):
			char_instance.img_path = dialogue_header["char"][id]["img_path"]
		char_instance.id = dialogue_header["char"][id]["id"]
		self.char_sprites[id] = char_instance
		
	# 加载场景背景
	for id in dialogue_header["scene"]:
		if dialogue_header["scene"][id].has("img_path"):
			var resource = load(dialogue_header["scene"][id]["img_path"])
			scene_bgs[id] = resource

func load_dialogue_file(path: String) -> void:
	frames_data.clear()
	# 修复：清空 Header，防止多章节加载污染
	dialogue_header = {"char": {}, "scene": {}}
	
	if not FileAccess.file_exists(path):
		print("文件不存在：", path)
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		var trim_line = line.strip_edges()
		
		if trim_line.is_empty() or trim_line.begins_with("#"):
			continue
			
		# 处理 Header
		if trim_line.begins_with("$"):
			var json_str = trim_line.substr(1) 
			var json_data = JSON.parse_string(json_str)
			if json_data is Dictionary and json_data != null:
				var type = json_data.get("type")
				var id = json_data.get("id")
				if type and id:
					dialogue_header[type][id] = json_data
				else:
					print("Header 结构错误：缺少 type 或 id")
			continue
			
		# 处理帧
		var json_frame = JSON.parse_string(trim_line)
		if json_frame is Dictionary:
			frames_data.append(json_frame)
		else:
			print("帧解析失败：", trim_line)
	
	file.close()
	print("StageManager：解析完成，共", frames_data.size(), "条内容")

# --- 导演逻辑 ---

func run():
	while current_idx < frames_data.size():
		await play_frame(frames_data[current_idx])
		current_idx += 1
	# 确保输入锁解开，防止卡死
	is_input_locked = false 
	self.queue_free()

func play_frame(frame: Dictionary):
	"""
	核心优化：并行处理帧内操作
	1. 启动所有 Tween 动画 (后台运行)
	2. 启动打字机 (前台等待，但允许跳过)
	3. 等待所有 Tween 完成
	4. 等待 CTC
	"""
	var active_tweens: Array[Tween] = []
	need_ctc = true
	
	# 重置跳过标志
	skip_typing = false
	
	# [DEMO ONLY] 简易音效播放
	# 注意：此功能仅为演示用途，生产环境建议接入完整的音频管理系统喵
	if frame.get("sound") is Dictionary:
		var sound: Dictionary = frame["sound"]
		match sound["act"]:
			"play":
				var node_player: AudioStreamPlayer = AudioStreamPlayer.new()
				var stream: AudioStreamMP3 = load(sound.get("path"))
				node_player.stream = stream
				stream.loop = true
				node_player.volume_db = -15.0
				self.add_child(node_player)
				node_player.play()
				sound_players.append(node_player)
			"mute":
				for player in sound_players:
					player.queue_free()
	# 分割线————————————————————————————————				
	
	# 1. 角色逻辑
	if frame.get("char") is Dictionary:
		var character: Dictionary = frame["char"]
		var id: String = character.get("id", "")
		
		# 动作 (返回 Tween)
		if character.has("act") and id:
			var tween = char_action(id, character["act"])
			if tween: active_tweens.append(tween)
			
		# 文本更新 (不等待，立即刷新 UI)
		if id and character.has("content"):
			if dialogue_header["char"].has(id):
				node_who.text = dialogue_header["char"][id]["name"]
				node_title.text = character.get("title_override", dialogue_header["char"][id]["title"])
		
		# 打字机 (核心耗时操作)
		if character.has("content") and character["content"] is String:
			# 启动打字机，期间 Tween 会继续运行
			await typewriter(node_text, character["content"])
	
	# 2. 场景逻辑
	if frame.get("scene") is Dictionary:
		var scene: Dictionary = frame["scene"]
		if scene.has("id") and scene.has("act"):
			var tween = scene_action(scene["id"], scene["act"])
			if tween: active_tweens.append(tween)
			
	# 3. 指令逻辑
	if frame.get("cmd") is Dictionary:
		var cmd: Dictionary = frame["cmd"]
		await execute_cmd(cmd)
	
	# 4. 等待所有后台动画完成
	# 即使打字机结束了，如果角色还在移动，也要等移动结束
	for tween in active_tweens:
		if tween and tween.is_running():
			await tween.finished
				
	# 5. 等待玩家继续
	if need_ctc:
		await wait_for_ctc()

# --- 导演工具 ---
func execute_cmd(cmd: Dictionary):
	match cmd.get("which"):
			"fullscreen_notice":
				await full_screen_notice(cmd.get("args"))
				need_ctc = false
			"clear_textbox":
				node_text.text = ""
				node_title.text = ""
				node_who.text = ""
			"fast":
				need_ctc = false
			"hide_textbox":
				fade_out($DialogBox)
			"show_textbox":
				fade_in($DialogBox)
			_:
				print("command not found")

func char_action(id: String, act: String) -> Tween:
	var target: CharacterSprite = char_sprites.get(id)
	if not target: return null
	
	var tween: Tween = null
	match act:
		"join":
			if not target.is_inside_tree():
				add_child(target)
			target.visible = true
			tween = fade_in(target)
		"leave":
			tween = fade_out(target)
			# 注意：leave 后通常不需要立即 free，以便复用
		_:
			# 其他命令可能不包含动画，直接执行
			if target.is_inside_tree():
				target.execute_cmd(act)
	return tween

func scene_action(id: String, act: String) -> Tween:
	var tween: Tween = null
	match act:
		"show":
			if scene_bgs.has(id):
				node_bg.texture = scene_bgs[id]
				tween = fade_in(node_bg)
	return tween

func full_screen_notice(content: String, duration: float = 2.0, enable_ctc: bool = true):
	if not is_instance_valid(ui_cover): return
	
	ui_text.text = ""
	ui_notice.visible = false
	
	# 淡入
	var tween_in = fade_in(ui_cover, 0.3)
	await tween_in.finished
	
	# 打字
	if enable_ctc:
		await typewriter(ui_text, content)
		# 最小显示时长
		await get_tree().create_timer(duration).timeout
		ui_notice.visible = true
		await wait_for_ctc()
	else:
		await get_tree().create_timer(duration).timeout
		
	# 淡出
	var tween_out = fade_out(ui_cover, 0.3)
	await tween_out.finished

func typewriter(label: Label, text: String, delay: float = -1.0) -> void:
	# 修复：默认参数不能调用函数，改为内部判断
	if delay < 0:
		delay = 0.05
		
	label.text = ""
	
	if delay == 0.0 or text.is_empty():
		label.text = text
		typing_finished.emit()
		return
		
	# 打字循环
	for ch in text:
		# 优化：支持跳过
		if skip_typing:
			label.text = text
			break
			
		label.text += ch
		await get_tree().create_timer(delay).timeout
	
	typing_finished.emit()

func fade_in(node: CanvasItem, duration: float = 0.3) -> Tween:
	node.modulate.a = 0.0
	node.visible = true
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)
	return tween

func fade_out(node: CanvasItem, duration: float = 0.3, hide_after: bool = true) -> Tween:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	if hide_after:
		tween.tween_callback(func(): node.visible = false)
	return tween

# --- 输入与交互 ---

func wait_for_ctc():
	"""
	专门等待 CTC 信号，避免信号丢失问题
	"""
	await ctc

func _input(event: InputEvent) -> void:
	# 优化：增加输入锁判断
	if is_input_locked:
		return
		
	if event.is_action_pressed("press_to_continue"):
		# 优化：如果正在打字，触发跳过
		if not skip_typing:
			skip_typing = true
		# 发射信号唤醒等待中的协程
		ctc.emit()

func _on_click_pressed() -> void:
	if is_input_locked: return
	skip_typing = true
	ctc.emit()
	
