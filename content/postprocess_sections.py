from glob import glob


if __name__ == '__main__':
    file_paths = sorted(glob('sections/reviewed/*'), key=lambda file_path: int(file_path.split('/')[-1].split('.')[0]))

    for index, file_path in enumerate(file_paths):
        with open(file_path, 'r') as fp:
            lines = list(map(str.strip, fp.readlines()))

        lines[0] = lines[0][1:-1]
        lines = list(filter(lambda line: line != '----------', lines))

        with open(f'sections/postprocessed/{index + 1}.txt', 'w') as fp:
            fp.write('\n'.join(lines))
