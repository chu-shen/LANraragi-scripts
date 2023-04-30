import os
import json

# 读取EhTagTranslation翻译数据库的JSON文件
# 最新文件见https://github.com/EhTagTranslation/Database/releases
with open('db.text.json', 'r', encoding='utf-8') as f:
    ehTagTranslation = json.load(f)

# 遍历标签数据，提取标签名称和中文翻译
# 格式：rows:female -> 内容索引:女性
tags = {}
for item in ehTagTranslation['data']:
    for tag_name, tag_data in item['data'].items():
        namespace = item['namespace']
        if namespace == 'reclass':
            namespace = 'category'
        tags[namespace+':'+tag_name] = item['frontMatters']['name'] + \
            ':'+tag_data['name']

# 将标签名称和中文翻译写入文件
with open('tags.txt', 'w', encoding='utf-8') as f:
    for tag_name, tag_translation in tags.items():
        f.write(f'{tag_name} -> {tag_translation}\n')


#--------------------------------------#


# 用于替换LANraragi中已有的英文标签
# 读取LANraragi备份的JSON文件，在软件中导出
file_path = 'backup.json'
# 如果没有备份文件,则跳过后续处理
if os.path.isfile(file_path):
    # 读取JSON数据
    with open('backup.json', 'r', encoding='utf-8') as f:
        lanraragi_backup = json.load(f)

    for archive in lanraragi_backup['archives']:
        tags_dict = []
        if archive['tags'] is not None:
            for tag in archive['tags'].split(','):
                tag = tag.strip()
                if tag in tags:
                    tag = tags[tag]
                tags_dict.append(tag)

            archive['tags'] = ','.join(tags_dict)

    # 将替换后的数据转换为JSON格式并输出
    # 然后在软件中恢复此文件即可
    with open('backup_chs.json', 'w', encoding='utf-8') as f:
        json.dump(lanraragi_backup, f, ensure_ascii=False, indent=4)
