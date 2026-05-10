# 剧情剧本编写指南
**本文档由AI生成，仅供参考**
> 本文档适用于 tinyGDstory 框架的剧本编写。编剧人员无需了解编程知识，按照本指南格式编写文本即可。
---

## 📋 目录

1. [文件基础规范](#1-文件基础规范)
2. [剧本结构说明](#2-剧本结构说明)
3. [资源定义语法](#3-资源定义语法)
4. [剧情帧语法](#4-剧情帧语法)
5. [常用指令参考](#5-常用指令参考)
6. [完整示例](#6-完整示例)
7. [常见问题](#7-常见问题)

---

## 1. 文件基础规范

| 项目 | 要求 |
| :--- | :--- |
| **文件格式** | 纯文本文件（`.txt`） |
| **文件编码** | **UTF-8**（必须，否则中文会乱码） |
| **存放路径** | `source/dialogue/章节名/文件名.txt` |
| **命名建议** | 使用英文或数字命名，如 `ep_01.txt`、`ep_02.txt` |

### 基本规则

- 每一行必须是一个完整的指令
- 以 `#` 开头的行为注释，会被系统忽略
- 空行会被系统忽略，可用于分隔段落
- **所有引号必须使用英文双引号 `"`**，不能使用中文引号

---

## 2. 剧本结构说明

剧本分为两个部分：

### 2.1 资源定义区

用于注册本章节用到的角色、场景等资源。行首必须包含 `$` 符号。通常放在文件开头。

### 2.2 剧情帧区

每一行代表剧情的一帧画面。支持对话、动作、指令等多种操作。

---

## 3. 资源定义语法

### 3.1 定义角色
$ {"type":"char", "id":"角色代号", "name":"显示名称", "title":"头衔", "img_path":"资源路径/"}


| 字段 | 说明 | 示例 |
| :--- | :--- | :--- |
| `type` | 固定填写 `char` | `"char"` |
| `id` | 角色唯一代号，后续剧情用此代号调用 | `"plana"` |
| `name` | 对话框中显示的角色名字 | `"普拉娜"` |
| `title` | 名字旁边显示的头衔/职位 | `"秘书"` |
| `img_path` | 表情图片所在文件夹路径（**末尾需带 `/`**） | `"res://assets/plana/"` |

### 3.2 定义场景
$ {"type":"scene", "id":"场景代号", "name":"场景名称", "img_path":"图片路径"}


| 字段 | 说明 | 示例 |
| :--- | :--- | :--- |
| `type` | 固定填写 `scene` | `"scene"` |
| `id` | 场景唯一代号，后续剧情用此代号调用 | `"office"` |
| `name` | 场景备注名（仅供编剧查看） | `"办公室"` |
| `img_path` | 背景图片资源路径 | `"res://assets/bgs/office.png"` |

---

## 4. 剧情帧语法

### 4.1 角色对话
{"char":{"id":"角色代号", "content":"对话内容"}}


**示例：**
{"char":{"id":"plana", "content":"老师，今天的日程已经安排好了。"}}


### 4.2 角色动作

| 动作 | 说明 | 示例 |
| :--- | :--- | :--- |
| `join` | 角色登场（淡入显示） | `{"char":{"id":"plana", "act":"join"}}` |
| `leave` | 角色退场（淡出隐藏） | `{"char":{"id":"plana", "act":"leave"}}` |
| `happy` | 切换为开心表情 | `{"char":{"id":"plana", "act":"happy"}}` |
| `angry` | 切换为生气表情 | `{"char":{"id":"plana", "act":"angry"}}` |
| `smile` | 切换为微笑表情 | `{"char":{"id":"plana", "act":"smile"}}` |
| `confuse` | 切换为困惑表情 | `{"char":{"id":"plana", "act":"confuse"}}` |
| `dummy` | 切换为默认表情 | `{"char":{"id":"plana", "act":"dummy"}}` |

### 4.3 对话 + 动作同时进行

可在同一行中同时指定 `content` 和 `act`，实现边说话边变脸的效果。
{"char":{"id":"plana", "content":"真的吗？！", "act":"confuse"}}


### 4.4 场景切换
{"scene":{"id":"场景代号", "act":"show"}}


**示例：**
{"scene":{"id":"office", "act":"show"}}


### 4.5 并行操作

同一行内可写多个操作，系统会同时执行。
{"scene":{"id":"office", "act":"show"}, "char":{"id":"plana", "act":"join"}, "char":{"id":"plana", "content":"欢迎来到办公室！"}}


---

## 5. 常用指令参考

### 5.1 全屏提示

显示黑屏白字提示，常用于章节标题或重要信息。
{"cmd":{"which":"fullscreen_notice", "args":"提示内容"}}


**示例：**
{"cmd":{"which":"fullscreen_notice", "args":"第一章 开始"}} {"cmd":{"which":"fullscreen_notice", "args":"三天后……"}}


### 5.2 清空对话框

清空当前对话框中的所有文本。
{"cmd":{"which":"clear_textbox"}}


### 5.3 隐藏/显示对话框

隐藏或显示整个对话框 UI。
{"cmd":{"which":"hide_textbox"}} {"cmd":{"which":"show_textbox"}}


### 5.4 快速跳过

本帧结束后不等待玩家点击，直接进入下一帧。适用于快速过场。
{"cmd":{"which":"fast"}}


### 5.5 音效播放（演示功能）
{"sound":{"act":"play", "path":"音频文件路径"}} {"sound":{"act":"mute"}}


> ⚠️ 注意：当前音效功能为演示版本，生产环境建议使用完整的音频管理系统。

---

## 6. 完整示例
第一章 第一话：初次见面
作者：编剧姓名
--- 资源定义 ---
"type":"char","id":"plana","name":"普拉娜","title":"秘书","img 
p
​
 ath":"res://assets/plana/" {"type":"char", "id":"player", "name":"老师", "title":"顾问", "img_path":"res://assets/player/"} $ {"type":"scene", "id":"office", "name":"办公室", "img_path":"res://assets/bgs/office.png"}

--- 剧情开始 ---
开场标题
{"cmd":{"which":"fullscreen_notice", "args":"第一章 第一话\n清晨的办公室"}}

切换场景
{"scene":{"id":"office", "act":"show"}}

角色登场
{"char":{"id":"plana", "act":"join"}}

对话开始
{"char":{"id":"plana", "content":"老师，您迟到了三分钟。"}} {"char":{"id":"plana", "content":"今天的日程非常紧凑，请做好准备。", "act":"smile"}}

另一位角色登场
{"char":{"id":"player", "act":"join"}} {"char":{"id":"plana", "content":"这位是？", "act":"confuse"}}

清空对话框，转换气氛
{"cmd":{"which":"clear_textbox"}} {"char":{"id":"player", "content":"抱歉，路上遇到了点意外。"}}

章节结束
{"char":{"id":"plana", "act":"leave"}} {"char":{"id":"player", "act":"leave"}} {"cmd":{"which":"fullscreen_notice", "args":"待续"}}


---

## 7. 常见问题

### 7.1 中文显示乱码

**原因：** 文件编码不是 UTF-8

**解决：** 用记事本或代码编辑器打开文件，另存为选择 `UTF-8` 编码。

### 7.2 角色/场景不显示

**原因：** `id` 不匹配或资源路径错误

**解决：** 
- 检查剧情中的 `id` 是否与资源定义区完全一致（区分大小写）
- 检查 `img_path` 路径是否正确，角色路径末尾需带 `/`

### 7.3 游戏报错或剧情不播放

**原因：** JSON 格式错误

**常见错误：**
- ❌ 使用了中文引号：`"内容"` → ✅ `"内容"`
- ❌ 缺少后引号：`{"id":"plana"}` → ✅ `{"id":"plana"}`
- ❌ 使用了单引号：`{'id':'plana'}` → ✅ `{"id":"plana"}`

### 7.4 对话中包含引号怎么办

**解决：** 使用反斜杠转义
{"char":{"id":"plana", "content":"他说："你好""}}


### 7.5 如何换行

**解决：** 使用 `\n` 表示换行
{"char":{"id":"plana", "content":"第一行\n第二行\n第三行"}}


---

## 8. 编辑器推荐

| 编辑器 | 优点 | 下载 |
| :--- | :--- | :--- |
| **VS Code** | JSON 高亮、语法检查、代码片段 | https://code.visualstudio.com/ |
| **Notepad++** | 轻量、支持 UTF-8 编码 | https://notepad-plus-plus.org/ |
| **记事本** | 系统自带，需手动选择 UTF-8 编码 | Windows 自带 |

### VS Code 代码片段推荐

在 VS Code 中设置以下代码片段可大幅提升编写效率：

| 触发词 | 展开内容 |
| :--- | :--- |
| `char` | `{"char":{"id":"", "content":""}}` |
| `act` | `{"char":{"id":"", "act":"join"}}` |
| `scene` | `{"scene":{"id":"", "act":"show"}}` |
| `cmd` | `{"cmd":{"which":"fullscreen_notice", "args":""}}` |
| `head` | `$ {"type":"char", "id":"", "name":"", "img_path":""}` |

---

## 9. 检查清单

提交剧本前请确认：

- [ ] 文件编码为 UTF-8
- [ ] 所有引号为英文双引号 `"`
- [ ] 角色/场景 `id` 与定义区一致
- [ ] 资源路径正确且文件存在
- [ ] 无 JSON 格式错误（可用在线 JSON 校验工具检查）
- [ ] 已测试运行无报错

---

## 10. 联系支持

如遇到无法解决的问题，请：

1. 检查本指南的常见问题部分
2. 查看控制台输出的错误信息
3. 联系程序组或提交 Issue

---

<div align="center">

**祝创作愉快！**

</div>