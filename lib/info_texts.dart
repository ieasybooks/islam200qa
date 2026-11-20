// The About, Privacy policy, Terms of use and Contact & support pages, in
// Arabic at /about, /privacy, /terms and /support, which the app shows, and in
// English at /en/about, /en/privacy, /en/terms and /en/support, for the website
// and English links. Google Play and AppGallery link /privacy on
// islam200qa.ieasybooks.com, and AppGallery /support too (store/store.json).
//
// The texts are the approved ones, which EasyBooks' other apps share: keep them
// word for word (test/approved_pages.txt checks them), true to what the app and
// the website do, and without naming the website's hosting providers. Change
// the date (updated) of the privacy policy or the terms with them.

/// Where readers write to us: support, mistakes in the content, rights and
/// privacy requests.
const String contactEmail = 'easybooksdev@gmail.com';

/// A link to [contactEmail] inside a paragraph.
const String _email = '[$contactEmail](mailto:$contactEmail)';

/// A page's language: Arabic, right to left, or English, left to right.
enum InfoLanguage { ar, en }

/// The four pages, in the order the links at the end of each page list them.
enum InfoPageId { about, privacy, terms, support }

/// The page's address in the app and on the website: /privacy in Arabic,
/// /en/privacy in English.
String infoPath(final InfoPageId page, final InfoLanguage language) =>
    language == InfoLanguage.en ? '/en/${page.name}' : '/${page.name}';

/// A part of a page: its heading and its paragraphs.
///
/// Each string is one paragraph. A link in it is written [its words](address),
/// where the address is one of these pages (/en/terms), a web address or
/// mailto:.
class InfoSection {
  const InfoSection(this.title, this.paragraphs);

  final String title;
  final List<String> paragraphs;
}

class InfoPageText {
  const InfoPageText({
    required this.label,
    required this.title,
    this.updated,
    required this.lead,
    required this.sections,
  });

  /// The page's short name, in the app bar and in the links at the end of the
  /// other pages.
  final String label;
  final String title;

  /// When the page last changed, for the privacy policy and the terms.
  final String? updated;

  /// The paragraph under the title.
  final String lead;
  final List<InfoSection> sections;
}

/// The same thing in Arabic and in English.
class InfoTexts<T> {
  const InfoTexts({required this.ar, required this.en});

  final T ar;
  final T en;

  T of(final InfoLanguage language) => language == InfoLanguage.en ? en : ar;
}

/// A run of a paragraph: plain text, or a link's words and its address.
class InfoTextPart {
  const InfoTextPart(this.text, [this.url]);

  final String text;
  final String? url;
}

final RegExp _link = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

/// A paragraph cut into its text and its links.
List<InfoTextPart> infoTextParts(final String paragraph) {
  final List<InfoTextPart> parts = [];
  int start = 0;
  for (final RegExpMatch match in _link.allMatches(paragraph)) {
    if (match.start > start) {
      parts.add(InfoTextPart(paragraph.substring(start, match.start)));
    }
    parts.add(InfoTextPart(match.group(1)!, match.group(2)));
    start = match.end;
  }
  if (start < paragraph.length) {
    parts.add(InfoTextPart(paragraph.substring(start)));
  }
  return parts;
}

/// A paragraph as it reads, its links' words without their addresses.
String infoPlainText(final String paragraph) =>
    infoTextParts(paragraph).map((part) => part.text).join();

const InfoTexts<InfoPageText> aboutTexts = InfoTexts(
  ar: InfoPageText(
    label: 'عن التطبيق',
    title: 'عن «الإسلام في ٢٠٠ سؤال وجواب»',
    lead:
        'يقدّم تطبيق «الإسلام في ٢٠٠ سؤال وجواب» العقيدة الإسلامية في مئتي سؤال وجواب، مع شرح مرئي وصوتي لكل سؤال.',
    sections: [
      InfoSection('ما يقدّمه التطبيق', [
        'أسئلة الكتاب المئتان وأجوبتها محفوظة داخل التطبيق، فتقرؤها دون اتصال بالإنترنت، ولكل سؤال شرح مرئي وصوتي. ويمكنك وضع علامة عند السؤال الذي توقفت عنده، ومشاركة أي سؤال برابط.',
      ]),
      InfoSection('مصدر المحتوى', [
        'نص التطبيق كتاب «أعلام السنة المنشورة لاعتقاد الطائفة الناجية المنصورة» للشيخ حافظ بن أحمد الحكمي، بشرح مرئي وصوتي للشيخ إبراهيم رفيق.',
      ]),
      InfoSection('مَن يطوّر التطبيق', [
        '«الإسلام في ٢٠٠ سؤال وجواب» من تطوير الكتب المُيسّرة، وهو مجاني وخالٍ من الإعلانات، ويمكنك استخدامه دون حساب.',
        'تابع الكتب المُيسّرة على [تيليجرام](https://t.me/ieasybooks) و[يوتيوب](https://youtube.com/@ieasybooks) و[X](https://x.com/iieasybooks) و[فيسبوك](https://fb.com/ieasybooks) و[GitHub](https://github.com/ieasybooks).',
      ]),
    ],
  ),
  en: InfoPageText(
    label: 'About',
    title: 'About Islam in 200 Q&A',
    lead:
        'Islam in 200 Q&A presents the Islamic creed in 200 questions and answers, each with a video and an audio explanation.',
    sections: [
      InfoSection("What's in Islam in 200 Q&A", [
        "The book's 200 questions and answers, built into the app so you can read them offline, with a video and an audio explanation for every question. Bookmark where you stopped, and share any question with a link.",
      ]),
      InfoSection('Where the content comes from', [
        "The text is Sheikh Hafiz ibn Ahmad al-Hakami's book A'lam al-Sunnah al-Manshurah, and the explanations are by Sheikh Ibrahim Rafiq.",
      ]),
      InfoSection('Who makes it', [
        "Islam in 200 Q&A is made by EasyBooks. It's free, has no ads and works without an account.",
        'Follow EasyBooks on [Telegram](https://t.me/ieasybooks), [YouTube](https://youtube.com/@ieasybooks), [X](https://x.com/iieasybooks), [Facebook](https://fb.com/ieasybooks) and [GitHub](https://github.com/ieasybooks).',
      ]),
    ],
  ),
);

const InfoTexts<InfoPageText> privacyTexts = InfoTexts(
  ar: InfoPageText(
    label: 'سياسة الخصوصية',
    title: 'سياسة الخصوصية',
    updated: 'آخر تحديث: ٢٠ نوفمبر ٢٠٢٦',
    lead:
        'تبيّن هذه السياسة كيف نتعامل مع المعلومات في تطبيق «الإسلام في ٢٠٠ سؤال وجواب» على Android وموقع islam200qa.ieasybooks.com. التطبيق من تطوير الكتب المُيسّرة، ويمكنك استخدامه دون حساب.',
    sections: [
      InfoSection('ما يُحفظ على جهازك', [
        'لا يحفظ التطبيق على جهازك، أو في متصفحك عند استخدام الموقع، إلا أمرين: السؤال الذي وضعت عنده علامة، وأن الجولة التعريفية عُرضت عليك.',
        'ولا يُرسَل شيء من ذلك إلينا، ويمكنك حذفه بمسح بيانات التطبيق أو الموقع.',
      ]),
      InfoSection('الخدمات التي نستخدمها', [
        'يُعرض الشرح المرئي لكل سؤال عبر مشغّل يوتيوب، ويُحمَّل شرحه الصوتي من خوادم Google. وعندئذ يتصل جهازك بخوادم هذه الخدمات مباشرة، فتتلقى معلومات تقنية مثل عنوان IP، وقد تستخدم ملفات تعريف الارتباط، وفق سياسات الخصوصية الخاصة بها.',
      ]),
      InfoSection('الإعلانات والإحصاءات', [
        'لا يعرض التطبيق إعلانات، ولا يتتبّعك في التطبيقات أو المواقع الأخرى. ويجمع موقع islam200qa.ieasybooks.com إحصاءات إجمالية عن زياراته وسرعة تحميل صفحاته، دون استخدام ملفات تعريف الارتباط. ولا نبيع أي بيانات، ولا نستخدمها لأغراض إعلانية.',
      ]),
      InfoSection('الأذونات', [
        'لا يطلب التطبيق إذن الوصول إلى موقعك الجغرافي أو الكاميرا أو الميكروفون أو جهات الاتصال.',
      ]),
      InfoSection('التواصل وطلبات الخصوصية', [
        'إذا راسلتنا، نتلقى ما ترسله إلينا، كاسمك وبريدك الإلكتروني ونص رسالتك، ولا نستخدمه إلا للرد عليك. ولأي سؤال عن الخصوصية، أو لطلب حذف رسائلك، راسلنا على $_email.',
      ]),
      InfoSection('تحديثات هذه السياسة', [
        'ننشر في هذه الصفحة النسخة الحالية من هذه السياسة، مع تاريخ آخر تحديث لها.',
      ]),
    ],
  ),
  en: InfoPageText(
    label: 'Privacy policy',
    title: 'Privacy policy',
    updated: 'Last updated: 20 November 2026',
    lead:
        'This policy explains how the Islam in 200 Q&A app for Android and the islam200qa.ieasybooks.com website handle information. Islam in 200 Q&A is made by EasyBooks, and you can use it without an account.',
    sections: [
      InfoSection('Information stored on your device', [
        'Islam in 200 Q&A saves only two things on your device, or in your browser on the website: the question you bookmarked, and that it has shown you its introductory tour.',
        "None of this is sent to us, and you can remove it by clearing the app's or the site's data.",
      ]),
      InfoSection('Services we use', [
        "Each question's video explanation plays in YouTube's player, and its audio explanation also loads from Google. Your device then connects to their servers directly, which receive technical information such as your IP address and may use cookies, under their own privacy policies.",
      ]),
      InfoSection('Advertising and analytics', [
        "Islam in 200 Q&A has no ads and doesn't track you across apps or websites. The islam200qa.ieasybooks.com website keeps aggregate statistics on its visits and loading speed, without cookies. We don't sell any data or use it for advertising.",
      ]),
      InfoSection('Permissions', [
        "Islam in 200 Q&A doesn't ask for access to your location, camera, microphone or contacts.",
      ]),
      InfoSection('Contact and privacy requests', [
        'If you write to us, we receive what you send, such as your name, email address and message, and use it only to reply to you. To ask about privacy, or to have your messages deleted, email $_email.',
      ]),
      InfoSection('Changes to this policy', [
        'We publish the current version of this policy, and the date it was last updated, on this page.',
      ]),
    ],
  ),
);

const InfoTexts<InfoPageText> termsTexts = InfoTexts(
  ar: InfoPageText(
    label: 'شروط الاستخدام',
    title: 'شروط الاستخدام',
    updated: 'آخر تحديث: ٢٠ نوفمبر ٢٠٢٦',
    lead:
        'تنظّم هذه الشروط استخدامك لتطبيق «الإسلام في ٢٠٠ سؤال وجواب» على Android وموقع islam200qa.ieasybooks.com، ويُعدّ استخدامك له موافقةً عليها. التطبيق من تطوير الكتب المُيسّرة، وهو مجاني.',
    sections: [
      InfoSection('استخدام «الإسلام في ٢٠٠ سؤال وجواب»', [
        'استخدم التطبيق استخدامًا مشروعًا ولائقًا، ولا تحاول تعطيله، أو الوصول إلى أجزاء غير مسموح لك بها، أو إرسال طلبات كثيرة تُبطئه على المستخدمين الآخرين.',
      ]),
      InfoSection('المحتوى والحقوق', [
        'ينسب التطبيق الكتاب إلى مؤلفه الشيخ حافظ بن أحمد الحكمي، والشرح إلى الشيخ إبراهيم رفيق. وتبقى الحقوق كلها لأصحابها، ولا يدّعي التطبيق ملكية شيء منها.',
        'إذا كنت صاحب حق في مادة يعرضها التطبيق، وأردت تصحيحها أو تعديل نسبتها أو حذفها، فراسلنا على $_email، وأرفق رابطها وبيّن صلتك بها. ونحن نراجع كل طلب ونتخذ الإجراء المناسب.',
      ]),
      InfoSection('الدقة والتوافر', [
        'يُقدَّم التطبيق مجانًا و«كما هو»، دون ضمانات من أي نوع. وقد يتغير محتواه أو يصبح غير متاح أو تقع فيه أخطاء، ولا نضمن أن يعمل دائمًا أو يخلو من الأعطال. وإن وجدت خطأ، فنرجو أن تبلغنا به.',
      ]),
      InfoSection('حدود المسؤولية', [
        'في حدود ما يسمح به القانون، لا تتحمل الكتب المُيسّرة أي مسؤولية عن خسارة أو ضرر ينشأ عن استخدام التطبيق أو محتواه، أو عن تعذّر استخدامهما.',
      ]),
      InfoSection('تحديثات هذه الشروط', [
        'قد نحدّث هذه الشروط من حين لآخر، وننشر نسختها الحالية في هذه الصفحة مع تاريخ آخر تحديث. واستمرارك في استخدام التطبيق بعد التحديث يعني قبولك للشروط المحدّثة.',
      ]),
      InfoSection('التواصل', [
        'لأي سؤال عن هذه الشروط، راسلنا على $_email.',
      ]),
    ],
  ),
  en: InfoPageText(
    label: 'Terms of use',
    title: 'Terms of use',
    updated: 'Last updated: 20 November 2026',
    lead:
        'These terms cover your use of the Islam in 200 Q&A app for Android and the islam200qa.ieasybooks.com website. By using Islam in 200 Q&A, you agree to them. Islam in 200 Q&A is made by EasyBooks and is free.',
    sections: [
      InfoSection('Using Islam in 200 Q&A', [
        "Use Islam in 200 Q&A lawfully and respectfully. Don't disrupt it, try to get into parts of it you aren't allowed to reach, or send it so many requests that it slows down for others.",
      ]),
      InfoSection('Content and rights', [
        'Islam in 200 Q&A credits the book to Sheikh Hafiz ibn Ahmad al-Hakami and the explanations to Sheikh Ibrahim Rafiq. Their rights stay with their owners, and Islam in 200 Q&A claims no ownership of them.',
        'If you own rights in something Islam in 200 Q&A shows and want it corrected, credited differently or removed, email $_email with a link to it and your relationship to it. We review every request and act on it.',
      ]),
      InfoSection('Accuracy and availability', [
        "Islam in 200 Q&A is provided free and as is, without warranties of any kind. Its content may change, become unavailable or contain mistakes, and we don't guarantee that it will always work or be free of errors. If you find a mistake, please report it.",
      ]),
      InfoSection('Limitation of liability', [
        "As far as the law allows, EasyBooks isn't liable for any loss or damage arising from using, or being unable to use, Islam in 200 Q&A or its content.",
      ]),
      InfoSection('Changes to these terms', [
        'We may update these terms. We publish the current version here, with the date it was last updated. Continuing to use Islam in 200 Q&A after an update means you accept it.',
      ]),
      InfoSection('Contact', [
        'For questions about these terms, email $_email.',
      ]),
    ],
  ),
);

const InfoTexts<InfoPageText> supportTexts = InfoTexts(
  ar: InfoPageText(
    label: 'التواصل والدعم',
    title: 'التواصل والدعم',
    lead:
        '«الإسلام في ٢٠٠ سؤال وجواب» من تطوير الكتب المُيسّرة. لأي سؤال أو اقتراح، أو للإبلاغ عن مشكلة أو خطأ، تواصل معنا.',
    sections: [
      InfoSection('راسلنا', [
        'بريدنا الإلكتروني للأسئلة والدعم وطلبات الخصوصية: $_email. ويمكنك كذلك [فتح بلاغ على GitHub](https://github.com/ieasybooks/islam200qa/issues)، وهو علني، فلا تضع فيه معلومات شخصية.',
      ]),
      InfoSection('الإبلاغ عن مشكلة', [
        'إن كانت ملاحظتك عن شيء محدد في التطبيق، فأرسل رابطه أو أخبرنا بمكانه. وإن كانت المشكلة في عمل التطبيق أو الموقع، فاذكر نوع جهازك، وإصدار نظام تشغيله، وإصدار التطبيق، وما حدث قبل ظهورها. ولا ترسل إلينا كلمات مرور أو أي معلومات حساسة.',
      ]),
      InfoSection('المحتوى والحقوق', [
        'إذا كنت صاحب حق في مادة يعرضها التطبيق، فراجع قسم «المحتوى والحقوق» في [شروط الاستخدام](/terms)، أو راسلنا.',
      ]),
      InfoSection('الخصوصية', [
        'يمكنك استخدام التطبيق دون حساب، وهو لا يتتبّعك في التطبيقات أو المواقع الأخرى. ولمعرفة كيف نتعامل مع المعلومات، أو لتقديم طلب يتعلق بالخصوصية، راجع [سياسة الخصوصية](/privacy).',
      ]),
    ],
  ),
  en: InfoPageText(
    label: 'Contact & support',
    title: 'Contact & support',
    lead:
        'Islam in 200 Q&A is made by EasyBooks. For questions and suggestions, or to report a problem or a mistake, contact us.',
    sections: [
      InfoSection('Email us', [
        "Our address for questions, support and privacy requests: $_email. You can also [open an issue on GitHub](https://github.com/ieasybooks/islam200qa/issues); it's public, so keep personal information out of it.",
      ]),
      InfoSection('Reporting a problem', [
        "If it's about something specific in Islam in 200 Q&A, send its link or tell us where to find it. If it's about the app or the website, include your device, its operating system version, Islam in 200 Q&A's version and what happened before it. Don't send passwords or sensitive information.",
      ]),
      InfoSection('Content and rights', [
        'If you own rights in something Islam in 200 Q&A shows, see “Content and rights” in [the terms of use](/en/terms), or email us.',
      ]),
      InfoSection('Privacy', [
        "Islam in 200 Q&A works without an account and doesn't track you across apps or websites. For how we handle information, or for a privacy request, see [the privacy policy](/en/privacy).",
      ]),
    ],
  ),
);

const Map<InfoPageId, InfoTexts<InfoPageText>> infoTexts = {
  InfoPageId.about: aboutTexts,
  InfoPageId.privacy: privacyTexts,
  InfoPageId.terms: termsTexts,
  InfoPageId.support: supportTexts,
};
