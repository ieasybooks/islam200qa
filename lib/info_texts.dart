// The privacy policy (/privacy) and the support page (/support), in Arabic and
// English. Google Play and AppGallery link both pages on
// islam200qa.ieasybooks.com, so keep them true to what the app and the
// website do, and change the policy's date (updated) with it.

/// Where readers write to us: support, mistakes in the content, privacy requests.
const String contactEmail = 'easybooksdev@gmail.com';

/// A link after a section's paragraphs: a web address, a path in the app such
/// as /privacy, or mailto: for the contact address.
class InfoLink {
  const InfoLink(this.label, this.url);

  final String label;
  final String url;
}

const InfoLink _emailLink = InfoLink(contactEmail, 'mailto:$contactEmail');

/// A part of a page: its heading, its paragraphs, and what it links to after them.
class InfoSection {
  const InfoSection({
    required this.title,
    required this.body,
    this.links = const [],
  });

  final String title;
  final List<String> body;
  final List<InfoLink> links;
}

class InfoPageText {
  const InfoPageText({
    required this.title,
    this.updated,
    required this.lead,
    required this.sections,
  });

  final String title;

  /// When the page last changed, for the privacy policy.
  final String? updated;
  final String lead;
  final List<InfoSection> sections;
}

/// The same thing in Arabic, shown first and right to left, and in English.
class InfoTexts<T> {
  const InfoTexts({required this.ar, required this.en});

  final T ar;
  final T en;
}

const InfoTexts<InfoPageText> privacyTexts = InfoTexts(
  ar: InfoPageText(
    title: 'سياسة الخصوصية',
    updated: 'آخر تحديث: ١٩ نوفمبر ٢٠٢٦',
    lead:
        'توضح هذه السياسة كيف يتعامل تطبيق «الإسلام في ٢٠٠ سؤال وجواب» وموقعه islam200qa.ieasybooks.com مع المعلومات. التطبيق من تطوير الكتب المُيسّرة، وهو مجاني، ولا يحتاج استخدامه إلى حساب.',
    sections: [
      InfoSection(
        title: 'ما يُحفظ على جهازك',
        body: [
          'نص الكتاب مضمَّن في التطبيق، فلا يُحمَّل من الإنترنت.',
          'ويحفظ التطبيق على جهازك أمرين فقط: السؤال الذي وضعت عليه علامة الحفظ، ليفتح عليه في المرة القادمة، وأنه عرض عليك جولة التعريف بالتطبيق، فلا يعرضها مرة أخرى. ويحفظهما الموقع في مساحة التخزين المحلية لمتصفحك.',
          'لا يُرسَل شيء من ذلك إلينا، ويمكنك إزالته بمسح بيانات التطبيق أو الموقع.',
        ],
      ),
      InfoSection(
        title: 'شرح الأسئلة من يوتيوب وGoogle Drive',
        body: [
          'يُعرض شرح كل سؤال داخل صفحته: الفيديو من يوتيوب، والتسجيل الصوتي من Google Drive. يُحمَّل الفيديو عند فتح السؤال، والتسجيل عند اختيار تبويبه.',
          'عندها يتصل جهازك بخوادم Google مباشرة، فتتلقى معلومات تقنية مثل عنوان الإنترنت ونوع الجهاز أو المتصفح، وقد تستخدم ملفات تعريف الارتباط. يوتيوب وGoogle Drive من خدمات Google، ويخضع ما تتلقيانه لسياسة خصوصية Google، لا لهذه السياسة.',
        ],
        links: [
          InfoLink('سياسة خصوصية Google',
              'https://policies.google.com/privacy?hl=ar'),
        ],
      ),
      InfoSection(
        title: 'الموقع',
        body: [
          'يستضيف Netlify موقع islam200qa.ieasybooks.com، وتمر طلباته عبر Cloudflare. وتحمل هذه الطلبات معلومات تقنية، مثل عنوان الإنترنت ووقت الطلب والصفحة المطلوبة ونوع المتصفح، قد يسجلها Netlify وCloudflare لتوصيل الموقع وحمايته من إساءة الاستخدام.',
          'ويحمّل الموقع بعض ملفات تشغيله وخطوطه من خوادم Google (gstatic.com).',
        ],
      ),
      InfoSection(
        title: 'الإعلانات والتحليلات',
        body: [
          'لا يتضمن التطبيق إعلانات ولا أدوات تحليل، ولا يتتبعك عبر التطبيقات أو المواقع، ولا يجمع أي بيانات عنك.',
          'ولا يتضمن الموقع إعلانات، ويستخدم خدمة Cloudflare Web Analytics لإحصاءات إجمالية عن زياراته وسرعته، دون ملفات تعريف ارتباط. لا نبيع أي بيانات، ولا نستخدمها للإعلانات.',
          'ولا يطلب التطبيق إذنًا بالوصول إلى موقعك أو الكاميرا أو الميكروفون أو جهات الاتصال.',
        ],
      ),
      InfoSection(
        title: 'المشاركة والروابط الخارجية',
        body: [
          'تتم مشاركة الأسئلة ونسخها عبر نظام جهازك، فلا يصلنا شيء مما تشاركه أو تنسخه.',
          'وتفتح الروابط في صفحة «عن التطبيق» حساباتنا على تيليجرام ويوتيوب وتويتر وفيسبوك وGitHub، وهي مواقع وتطبيقات تسري عليها سياسات خصوصيتها.',
        ],
      ),
      InfoSection(
        title: 'التواصل وطلبات الخصوصية',
        body: [
          'إذا راسلتنا، نتلقى ما تختار إرساله، مثل بريدك الإلكتروني ونص رسالتك، لنرد عليك.',
          'للسؤال عن الخصوصية، أو لطلب حذف مراسلاتك، راسلنا. ليس في التطبيق حسابات، فلا حساب يُحذف.',
        ],
        links: [_emailLink],
      ),
      InfoSection(
        title: 'تحديث السياسة',
        body: [
          'ننشر النسخة الحالية من هذه السياسة وتاريخ تحديثها في هذه الصفحة.'
        ],
      ),
    ],
  ),
  en: InfoPageText(
    title: 'Privacy policy',
    updated: 'Last updated: 19 November 2026',
    lead:
        "This policy covers how the Islam in 200 Q&A app and its website, islam200qa.ieasybooks.com, handle information. The app is made by EasyBooks. It's free, and using it needs no account.",
    sections: [
      InfoSection(
        title: 'Information stored on your device',
        body: [
          "The book's text is built into the app, so it isn't loaded from the internet.",
          "The app stores only two things on your device: the question you bookmarked, so it opens there next time, and that it has shown you its introductory tour, so it doesn't show it again. The website keeps them in your browser's local storage.",
          "None of this is sent to us, and you can remove it by clearing the app's or the site's data.",
        ],
      ),
      InfoSection(
        title: 'Explanations from YouTube and Google Drive',
        body: [
          "Each question's explanation plays within its page: the video from YouTube, and the audio recording from Google Drive. The video loads when you open a question, and the recording when you choose its tab.",
          "Your device then connects to Google's servers directly, which receive technical information such as your IP address and your device or browser, and may use cookies. YouTube and Google Drive are Google services: what they receive is governed by Google's privacy policy, not this one.",
        ],
        links: [
          InfoLink("Google's privacy policy",
              'https://policies.google.com/privacy?hl=en'),
        ],
      ),
      InfoSection(
        title: 'The website',
        body: [
          'islam200qa.ieasybooks.com is hosted by Netlify, and its requests pass through Cloudflare. These requests carry technical information, such as your IP address, the time, the page requested and your browser, which Netlify and Cloudflare may record to deliver the site and protect it from abuse.',
          "The website also loads some of its engine files and fonts from Google's servers (gstatic.com).",
        ],
      ),
      InfoSection(
        title: 'Advertising and analytics',
        body: [
          "The app contains no advertising and no analytics, doesn't track you across apps or websites, and collects no data about you.",
          "The website has no advertising either. It uses Cloudflare Web Analytics for aggregate statistics on its visits and speed, without cookies. We don't sell any data or use it for advertising.",
          "The app doesn't ask for access to your location, camera, microphone or contacts.",
        ],
      ),
      InfoSection(
        title: 'Sharing and external links',
        body: [
          "Sharing and copying a question go through your device's system, so nothing you share or copy reaches us.",
          'The links on the About page open our accounts on Telegram, YouTube, Twitter, Facebook and GitHub, which are websites and apps with their own privacy policies.',
        ],
      ),
      InfoSection(
        title: 'Contact and privacy requests',
        body: [
          'If you email us, we receive what you choose to send, such as your email address and your message, to reply to you.',
          'To ask about privacy, or to have your correspondence deleted, email us. The app has no accounts, so there is no account to delete.',
        ],
        links: [_emailLink],
      ),
      InfoSection(
        title: 'Changes to this policy',
        body: [
          'We publish the current version of this policy, and the date it was last updated, on this page.',
        ],
      ),
    ],
  ),
);

const InfoTexts<InfoPageText> supportTexts = InfoTexts(
  ar: InfoPageText(
    title: 'التواصل والدعم',
    lead:
        '«الإسلام في ٢٠٠ سؤال وجواب» من تطوير الكتب المُيسّرة. للأسئلة والاقتراحات، أو للإبلاغ عن مشكلة في التطبيق أو خطأ في نص أو شرح، راسلنا.',
    sections: [
      InfoSection(
        title: 'راسلنا',
        body: ['بريدنا للأسئلة والدعم وطلبات الخصوصية:'],
        links: [_emailLink],
      ),
      InfoSection(
        title: 'الإبلاغ عن مشكلة',
        body: [
          'إن كان الخطأ في سؤال فاذكر رقمه، الظاهر بين زرَّي التنقل، أو أرسل رابطه الذي يشاركه زر «شارك». وإن كانت المشكلة في التطبيق فاذكر نوع جهازك وإصدار نظام التشغيل وإصدار التطبيق، وما حدث قبلها.',
          'لا ترسل كلمات مرور أو معلومات حساسة.',
        ],
      ),
      InfoSection(
        title: 'تشغيل الشرح',
        body: [
          'نص الكتاب مضمَّن في التطبيق فتقرؤه دون اتصال، أما شرح كل سؤال، بالفيديو من يوتيوب والتسجيل الصوتي من Google Drive، فيحتاج إلى اتصال بالإنترنت. إذا لم يُحمَّل الشرح، فتحقق من الاتصال ثم أعد فتح السؤال.',
        ],
      ),
      InfoSection(
        title: 'الخصوصية',
        body: [
          'لا يحتاج التطبيق إلى حساب، ولا يتتبعك. لمعرفة كيف نتعامل مع المعلومات، أو لطلب يخص الخصوصية، راجع سياسة الخصوصية.',
        ],
        links: [InfoLink('سياسة الخصوصية', '/privacy')],
      ),
    ],
  ),
  en: InfoPageText(
    title: 'Contact and support',
    lead:
        'Islam in 200 Q&A is made by EasyBooks. For questions and suggestions, or to report a problem in the app or a mistake in a text or an explanation, email us.',
    sections: [
      InfoSection(
        title: 'Email us',
        body: ['Our address for questions, support and privacy requests:'],
        links: [_emailLink],
      ),
      InfoSection(
        title: 'Reporting a problem',
        body: [
          "If the mistake is in a question, give its number, shown between the navigation buttons, or send the link its Share button shares. If the problem is in the app, include your device, its operating system version, the app's version and what happened before it.",
          "Don't send passwords or sensitive information.",
        ],
      ),
      InfoSection(
        title: 'Playing the explanations',
        body: [
          "The book's text is built into the app, so you can read it offline. Each question's explanation, the video from YouTube and the audio recording from Google Drive, needs an internet connection. If an explanation doesn't load, check your connection and open the question again.",
        ],
      ),
      InfoSection(
        title: 'Privacy',
        body: [
          "The app needs no account and doesn't track you. For how we handle information, or for a privacy request, see the privacy policy.",
        ],
        links: [InfoLink('Privacy policy', '/privacy')],
      ),
    ],
  ),
);
