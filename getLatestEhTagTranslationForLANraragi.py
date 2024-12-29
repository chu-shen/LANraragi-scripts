import os
import json
import requests
 
repo_owner = 'EhTagTranslation'  
repo_name = 'Database'  
url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/releases/latest'  

response = requests.get(url)  
release_data = response.json()  

if response.status_code != 200:  
    print(f"Failed to retrieve release data: {release_data.get('message')}")
    quit()
else:  
    print(f"Latest Release: {release_data['name']}")  
    print(f"Release Notes: {release_data['body']}")  

    assets = release_data['assets']  
    for asset in assets:   
        if asset['name'] == 'db.text.json':
            db_file_url = asset['browser_download_url'] 
            break  

    if db_file_url:  
        response = requests.get(db_file_url, stream=True)  
        response.raise_for_status()
        with open('db.text.json', 'wb') as file:  
            for chunk in response.iter_content(chunk_size=8192):  
                if chunk:
                    file.write(chunk)  
        print(f"Downloaded: db.text.json")  
    else:  
        print("No assets available for download.")
        quit()


os.mkdir('build')

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
            if tag_name=='artistcg':
                tag_name = 'artist cg'
            if tag_name=='gamecg':
                tag_name = 'game cg'
            if tag_name=='imageset':
                tag_name = 'image set'
        tags[namespace+':'+tag_name] = item['frontMatters']['name'] + \
            ':'+tag_data['name']

# 将标签名称和中文翻译写入文件
with open('build/tags.txt', 'w', encoding='utf-8') as f:
    for tag_name, tag_translation in tags.items():
        f.write(f'{tag_name} -> {tag_translation}\n')

# 创建 index.html 文件并写入内容  
with open('build/index.html', 'w', encoding='utf-8') as f:  
    f.write(f"""  
    <!DOCTYPE html>  
    <html lang="en">  
    <head>  
        <meta charset="UTF-8">  
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  
        <title>Tag Translations {release_data['published_at']}</title>  
    </head>  
    <body>
    <pre>
    <!-- 将 tags.txt 的内容放在这里 -->  
    </pre> 
    </body>  
    <script>
    fetch("tags.txt")
        .then(response => response.text())
        .then(data => {{document.querySelector("pre").textContent = data;}});  
</script>
    </html>  
    """)  
print("index.html created with publish time.")  