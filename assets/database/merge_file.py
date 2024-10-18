import glob

def merge_file(output_file_name):
    with open(output_file_name, 'wb') as output_file:
        for file_name in sorted(glob.glob('poems_part_*'), key=lambda x: int(x.split('_')[-1])):
            with open(file_name, 'rb') as input_file:
                output_file.write(input_file.read())
    print(f'文件已合并为 {output_file_name}')

if __name__ == '__main__':
    merge_file('poems.db')
