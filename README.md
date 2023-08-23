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


## 为缺少`source`标签的档案添加Ehentai元数据

当 Ehentai 插件运行失败，且批量操作中运行失败的档案未自动勾选时，可以使用此插件为所有缺少`source`的档案调用 Ehentai 插件查询元数据

**实现原理：**

1. 获取所有档案
2. 检查是否有`source`标签，如有，则跳过后续步骤
3. 调用 Ehentai 插件获取元数据信息（标签）
4. 将新标签写入数据库

详细逻辑见 [[addEhentaiMetadata.py]]、[[addEhentaiMetadata.pm]]

**pm版使用说明：**

1. 下载 [addEhentaiMetadata.pm](https://github.com/chu-shen/LANraragi/blob/feat-ratingAndcomment/lib/LANraragi/Plugin/Scripts/addEhentaiMetadata.pm)
2. 在插件设置中上传此文件
3. 点击运行：`Scripts`->`Triger Script`

**py版使用说明：**

*最新代码见pm版*

1. 下载 [[addEhentaiMetadata.py]]
2. 修改`BASE_URL`和`API_KEY`
3. 运行 [[addEhentaiMetadata.py]]

### pm版更新

- 为出现"No matching EH Gallery Found!"问题的档案添加`source:nogalleryinehentai`标签，后续执行脚本时这些档案将被跳过

    可以在脚本执行参数中填入`True`，对这些档案再次进行搜索匹配

- 可设置每次请求间延时（秒），避免频繁请求触发封禁


## 查找重复档案

根据档案名查找重复档案并保存至`DuplicateArchives`分类

**使用说明：**

1. 下载 [DuplicateFinder.pm](https://github.com/chu-shen/LANraragi/blob/feat-ratingAndcomment/lib/LANraragi/Plugin/Scripts/DuplicateFinder.pm)
2. 在插件设置中上传此文件
3. 点击运行：`Scripts`->`Triger Script`
4. 重复的档案将被添加到`DuplicateArchives`分类，之后根据标题排序删除重复的即可