from glob import glob

if __name__ == '__main__':
    file_paths = sorted(glob('sections/postprocessed/*'), key=lambda file_path: int(file_path.split('/')[-1].split('.')[0]))

    sectionsIndex = list()

    for index, file_path in enumerate(file_paths):
        with open(file_path, 'r') as fp:
            lines = list(map(str.strip, fp.readlines()))

        sectionsIndex.append(lines[0])

    with open('sections/index.txt', 'w') as fp:
        fp.write('\n'.join(sectionsIndex))
