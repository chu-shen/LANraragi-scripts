import requests

# 修改链接和API KEY
BASE_URL='http://IP:PORT'
API_KEY='********'

ARCHIVES_URL = BASE_URL+'/api/archives'
PLUGINS_URL = BASE_URL+'/api/plugins'
PLUGIN_NAMESPACE = 'ehplugin'

# 获取所有档案
response = requests.get(ARCHIVES_URL)
if response.status_code == 200:
    archives = response.json()
else:
    print('Error: Failed to get all archives, status code', response.status_code)
    exit(1)


for item in archives:
    # 跳过有`source`标签的档案
    if 'source' in item['tags']:
        continue
    arcid=item['arcid']
    plugin_params = {'key': API_KEY,
                     'plugin': PLUGIN_NAMESPACE, 'id': arcid}
    response = requests.post(PLUGINS_URL+'/use', params=plugin_params)
    if response.status_code == 200:
        ehentai = response.json()
        
        METADATA_URL = ARCHIVES_URL+'/'+arcid+'/metadata'
        # 在原标签的基础上增加Ehentai标签
        try:
            tags = item['tags']+','+ehentai['data']['new_tags']
        except:
            print(ehentai['data']['error'])
            continue
        metatdata_params = {'key': API_KEY, 'tags': tags}
        response = requests.put(METADATA_URL, params=metatdata_params)
        if response.status_code == 200:
            results = response.json()
            print(results)
        else:
            print('Error: Failed to update metadata, status code', response.status_code)
            exit(1)
    else:
        print('Error: Failed to get metatdata, status code', response.status_code)
        exit(1)
