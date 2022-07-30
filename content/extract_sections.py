import re

from bs4 import BeautifulSoup


def convert_english_to_arabic_numbers(text):
    return text.translate(text.maketrans('1234567890', '١٢٣٤٥٦٧٨٩٠'))


def read_and_process_book_content():
    with open('book.htm', 'r') as fp:
        html = fp.read()

    html = html.replace('</p>', '\n').replace('\u200c', '')

    return html


def remove_headers(soup):
    for div in soup.find_all('div', {'class': 'PageHead'}):
        div.decompose()

    return soup


def extract_paragraphs_and_footnotes(soup):
    paragraphs = list()
    footnotes = list()

    for div in soup.find_all('div', {'class': 'PageText'})[1:]:
        footnote = div.find('div', {'class': 'footnote'})

        if footnote:
            footnotes.extend(footnote.text.split('\n'))
            footnote.decompose()

        paragraphs.extend(div.text.split('\n'))

    paragraphs = list(map(str.strip, paragraphs))
    paragraphs = list(filter(None, paragraphs))

    new_footnotes = list()

    current_footnote = 0
    while current_footnote < len(footnotes):
        if footnotes[current_footnote][0] == '(':
            start_footnote = current_footnote
            current_footnote += 1

            while current_footnote < len(footnotes) and footnotes[current_footnote][0] != '(':
                current_footnote += 1

            new_footnotes.append('\n'.join(footnotes[start_footnote:current_footnote]))

    # Special case about page 16.
    new_footnotes = new_footnotes[:18] + ['\n'.join(new_footnotes[18:23])] + new_footnotes[23:]

    return paragraphs, new_footnotes


def build_sections(paragraphs):
    section = list()
    sections = list()

    # Split paragraphs into sections.
    for paragraph in paragraphs:
        if paragraph[0] == '[' and paragraph[-1] == ']':
            if section:
                sections.append(section)

            section = list()

        section.append(paragraph)

    if section:
        sections.append(section)

    # Concatenate related lines.
    for i, section in enumerate(sections):
        new_section = [section[0]]

        j = 1
        while j < len(section):
            new_paragraph = ''
            while section[j][-1] not in '.؟' and j + 1 < len(section):
                new_paragraph += f'{section[j]} '
                j += 1
            new_paragraph += section[j]

            new_section.append(new_paragraph)

            if new_section[-1][-1] == ']':
                new_section[-1] += ' .'

            j += 1

        sections[i] = new_section

    return sections


def append_footnotes_to_section(footnotes, sections):
    current_footnote = 0

    for i, section in enumerate(sections):
        tmp_sections = list(section)
        section_footnotes = list()
        new_line_added = False

        footnotes_numbering = 1
        for j, paragraph in enumerate(tmp_sections):
            paragraph_footnotes = re.findall(r'\([٠١٢٣٤٥٦٧٨٩]+\)', paragraph)
            footnotes_count = len(paragraph_footnotes)

            for k, footnote in enumerate(paragraph_footnotes):
                sections[i][j] = sections[i][j].replace(footnote, str(k), 1)
                paragraph_footnotes[k] = str(k)

            for footnote in paragraph_footnotes:
                sections[i][j] = sections[i][j].replace(
                    footnote,
                    convert_english_to_arabic_numbers(f'({footnotes_numbering})'),
                    1,
                )
                footnotes_numbering += 1

            if footnotes_count > 0:
                if not new_line_added:
                    sections[i].append('\n----------')
                    new_line_added = True

                section_footnotes.extend(footnotes[current_footnote : current_footnote + footnotes_count])
                current_footnote += footnotes_count

        footnotes_numbering = 1
        footnotes_mapping = dict()
        for j, footnote in enumerate(section_footnotes):
            footnote_footnotes = re.findall(r'\([٠١٢٣٤٥٦٧٨٩]+\)', footnote)

            section_footnotes[j] = section_footnotes[j].replace(
                footnote_footnotes[0],
                convert_english_to_arabic_numbers(f'({footnotes_numbering})'),
                1,
            )
            footnotes_mapping[footnote_footnotes[0]] = convert_english_to_arabic_numbers(f'({footnotes_numbering})')
            footnotes_numbering += 1

            for footnote in footnote_footnotes[1:]:
                try:
                    section_footnotes[j] = section_footnotes[j].replace(footnote, footnotes_mapping[footnote])
                except KeyError:
                    continue

        if section_footnotes:
            sections[i].append('\n\n'.join(section_footnotes))

    return sections


def process_section(section):
    if section[-2] == '\n----------':
        for index, paragraph in enumerate(section[:-2]):
            section[index] = re.sub(
                r'\s+',
                ' ',
                paragraph.replace(' .', '.')
                .replace(' ،', '،')
                .replace(' »', '»')
                .replace('« ', '«')
                .replace(' / ', '/'),
            ).strip()

        section[-1] = (
            re.sub(
                r'\s+',
                ' ',
                section[-1]
                .replace('\n\n', '||')
                .replace(' .', '.')
                .replace(' ،', '،')
                .replace(' »', '»')
                .replace('« ', '«')
                .replace(' / ', '/'),
            )
            .strip()
            .replace('||', '\n\n')
        )
    else:
        for index, paragraph in enumerate(section):
            section[index] = re.sub(
                r'\s+',
                ' ',
                paragraph.replace(' .', '.')
                .replace(' ،', '،')
                .replace(' »', '»')
                .replace('« ', '«')
                .replace(' / ', '/'),
            ).strip()

    return section


def write_sections(sections):
    for index, section in enumerate(sections):
        with open(f'sections/preprocessed/{index + 1}.txt', 'w') as fp:
            fp.write('\n'.join(section))


if __name__ == '__main__':
    html = read_and_process_book_content()
    soup = BeautifulSoup(html, features='lxml')
    soup = remove_headers(soup)
    paragraphs, footnotes = extract_paragraphs_and_footnotes(soup)
    sections = build_sections(paragraphs)
    sections = append_footnotes_to_section(footnotes, sections)
    sections = list(map(process_section, sections))
    write_sections(sections)
