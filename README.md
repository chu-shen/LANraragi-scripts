# LANraragi-scripts
Scripts for LANraragi

## 标签中文化脚本

**实现原理：**

1. 提取[EhTagTranslation/Database](https://github.com/EhTagTranslation/Database/wiki/%E5%BC%80%E5%8F%91%E6%8C%87%E5%8D%97)翻译数据库的数据
2. 根据 [Tag Rules](https://sugoi.gitbook.io/lanraragi/v/dev/advanced-usage/tag-rules) 将所有匹配的英文标签替换为中文标签（会在插件添加标签时**自动应用**）

详细逻辑见 [[getEhTagTranslationForLANraragi.py]]

**使用说明：**

1. 下载 [[db.text.json]] 和 [[getEhTagTranslationForLANraragi.py]] 放在同一目录下
2. 运行 [[getEhTagTranslationForLANraragi.py]]，会在同目录下生成 [[tags.txt]]
3. 复制 [[tags.txt]] 中的内容到软件「Admin Settings」的「Tag Rules」中即可（会在为同人志添加标签时**自动替换**）
4. 如果需要修改软件中已存在的同人志，则需要备份数据库，然后将导出的文件放在同一目录下然后运行，最后将输出的文件还原回去即可
    - 开箱即用插件推荐👉https://github.com/zhy201810576/ETagConverter

**缺陷：**

1. 没法像 EhSyringe 提供标签说明及输入提示（中英）
2. 翻译数据库无实时性
