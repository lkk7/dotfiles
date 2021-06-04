import json

file = input('path to file:\n')

with open(file, encoding='utf-8') as f:
    nb = json.load(f)

count = 1
for cell in nb['cells']:
    if 'execution_count' in cell:
        cell['execution_count'] = count
        count += 1

    try:
        for output in cell['outputs']:
            if 'execution_count' in output:
                output['execution_count'] = cell['execution_count']

    except KeyError:
        continue

with open(file, 'w+') as f:
    json.dump(nb, f, indent=2, ensure_ascii=False)
