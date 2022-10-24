import 'package:islam200qa/utils/string_utils.dart';
import 'package:islam200qa/widgets/index/index_multi_sections_model.dart';
import 'package:islam200qa/widgets/index/index_section_model.dart';
import 'package:islam200qa/widgets/index/index_sections_combiner_model.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';

const int lastSection = 212;

const double indexBasePadding = 8.0;

List<IndexSectionModel> index = [
  const IndexSingleSectionModel(
    sectionId: 1,
  ),
  IndexMultiSectionsModel(
    title: 'أول ما يجب على الانسان والغاية من وجوده',
    startSection: 2,
    endSection: 12,
  ),
  IndexSectionsCombinerModel(
    title: 'مراتب الدين',
    children: [
      const IndexSingleSectionModel(
        sectionId: 13,
      ),
      IndexMultiSectionsModel(
        title: 'الإسلام وأدله',
        startSection: 14,
        endSection: 35,
      ),
      IndexSectionsCombinerModel(
        title: 'الإيمان وأدلته',
        children: [
          const IndexSingleSectionModel(
            sectionId: 36,
          ),
          IndexMultiSectionsModel(
            title: 'الإيمان قول وعمل',
            startSection: 37,
            endSection: 42,
          ),
          IndexSectionsCombinerModel(
            title: 'الإيمان بالله وأقسامه الثلاثة',
            children: [
              const IndexSingleSectionModel(
                sectionId: 43,
              ),
              IndexMultiSectionsModel(
                title: 'توحيد الألوهية وضده الشرك',
                startSection: 44,
                endSection: 47,
              ),
              IndexMultiSectionsModel(
                title: 'توحيد الربوبية وضده الكفر',
                startSection: 48,
                endSection: 49,
              ),
              IndexMultiSectionsModel(
                title: 'توحيد الأسماء والصفات وأدلته وبيان بعض ما اختلف فيه في هذا الباب',
                startSection: 50,
                endSection: 70,
              ),
              const IndexSingleSectionModel(
                sectionId: 71,
              ),
            ],
          ),
          IndexMultiSectionsModel(
            title: 'الإيمان بالملائكة',
            startSection: 72,
            endSection: 74,
          ),
          IndexMultiSectionsModel(
            title: 'الإيمان بالكتب',
            startSection: 75,
            endSection: 84,
          ),
          IndexMultiSectionsModel(
            title: 'الإيمان بالرسل',
            startSection: 85,
            endSection: 98,
          ),
          IndexSectionsCombinerModel(
            title: 'الإيمان باليوم الآخر',
            children: [
              const IndexSingleSectionModel(
                sectionId: 99,
              ),
              const IndexSingleSectionModel(
                sectionId: 100,
              ),
              const IndexSingleSectionModel(
                sectionId: 101,
              ),
              IndexMultiSectionsModel(
                title: 'بعض أمارات اليوم الآخر',
                startSection: 102,
                endSection: 103,
              ),
              const IndexSingleSectionModel(
                sectionId: 104,
              ),
              IndexMultiSectionsModel(
                title: 'فتنة القبر ونعيمه أو عذابه',
                startSection: 105,
                endSection: 106,
              ),
              IndexMultiSectionsModel(
                title: 'البعث والنفخ',
                startSection: 107,
                endSection: 109,
              ),
              IndexMultiSectionsModel(
                title: 'الحشر',
                startSection: 110,
                endSection: 113,
              ),
              IndexMultiSectionsModel(
                title: 'العرض والحساب ونشر الصحف',
                startSection: 114,
                endSection: 117,
              ),
              IndexMultiSectionsModel(
                title: 'الميزان وبيان وصفه',
                startSection: 118,
                endSection: 119,
              ),
              IndexMultiSectionsModel(
                title: 'الصراط',
                startSection: 120,
                endSection: 121,
              ),
              IndexMultiSectionsModel(
                title: 'القصاص وصفته',
                startSection: 122,
                endSection: 123,
              ),
              IndexMultiSectionsModel(
                title: 'الحوض وصفته',
                startSection: 124,
                endSection: 125,
              ),
              IndexMultiSectionsModel(
                title: 'الجنة والنار ووصفهما وبعض الشبه المتعلقة بهما',
                startSection: 126,
                endSection: 129,
              ),
              const IndexSingleSectionModel(
                sectionId: 130,
              ),
              IndexMultiSectionsModel(
                title: 'الشفاعة وأنواعها',
                startSection: 131,
                endSection: 132,
              ),
              const IndexSingleSectionModel(
                sectionId: 133,
              ),
            ],
          ),
          IndexSectionsCombinerModel(
            title: 'الإيمان بالقدر',
            children: [
              const IndexSingleSectionModel(
                sectionId: 134,
              ),
              const IndexSingleSectionModel(
                sectionId: 135,
              ),
              IndexMultiSectionsModel(
                title: 'المرتبة الأولى: الإيمان بالعلم',
                startSection: 136,
                endSection: 136,
              ),
              IndexMultiSectionsModel(
                title: 'المرتبة الثانية: الإيمان بالكتابة وبيان أنواعها',
                startSection: 137,
                endSection: 143,
              ),
              IndexMultiSectionsModel(
                title: 'المرتبة الثالثة: الإيمان بالمشيئة',
                startSection: 144,
                endSection: 145,
              ),
              IndexMultiSectionsModel(
                title: 'المرتبة الرابعة: الإيمان بالخلق',
                startSection: 146,
                endSection: 146,
              ),
              IndexMultiSectionsModel(
                title: 'بعض الشبهات المتعلقة بباب القدر',
                startSection: 147,
                endSection: 150,
              ),
            ],
          ),
          const IndexSingleSectionModel(
            sectionId: 151,
          ),
        ],
      ),
      IndexMultiSectionsModel(
        title: 'الإحسان وأدلته',
        startSection: 152,
        endSection: 152,
      ),
    ],
  ),
  IndexSectionsCombinerModel(
    title: 'الكفر وأنواعه',
    children: [
      const IndexSingleSectionModel(
        sectionId: 153,
      ),
      const IndexSingleSectionModel(
        sectionId: 154,
      ),
      IndexMultiSectionsModel(
        title: 'الكفر الأكبر وأقسامه',
        startSection: 155,
        endSection: 157,
      ),
      const IndexSingleSectionModel(
        sectionId: 158,
      ),
      const IndexSingleSectionModel(
        sectionId: 159,
      ),
      IndexMultiSectionsModel(
        title: 'أقسام الظلم والفسوق والنفاق',
        startSection: 160,
        endSection: 163,
      ),
      IndexMultiSectionsModel(
        title: 'من أشكال الكفر: حكم السحر والساحر',
        startSection: 164,
        endSection: 166,
      ),
      IndexMultiSectionsModel(
        title: 'الرقى المشروعة  والرقى الممنوعة',
        startSection: 167,
        endSection: 168,
      ),
      IndexMultiSectionsModel(
        title: 'حكم التعاليق والتمائم',
        startSection: 169,
        endSection: 170,
      ),
      IndexMultiSectionsModel(
        title: 'حكم الكهان والمنجمين',
        startSection: 171,
        endSection: 174,
      ),
      const IndexSingleSectionModel(
        sectionId: 175,
      ),
      const IndexSingleSectionModel(
        sectionId: 176,
      ),
    ],
  ),
  IndexSectionsCombinerModel(
    title: 'أقسام المعاصي وبم تكفر السيئات',
    children: [
      const IndexSingleSectionModel(
        sectionId: 177,
      ),
      const IndexSingleSectionModel(
        sectionId: 178,
      ),
      IndexMultiSectionsModel(
        title: 'التوبة النصوح',
        startSection: 179,
        endSection: 185,
      ),
    ],
  ),
  IndexSectionsCombinerModel(
    title: 'الصراط المستقيم الذي أمرنا الله تعالى بسلوكه',
    children: [
      IndexMultiSectionsModel(
        title: 'السنّة',
        startSection: 186,
        endSection: 188,
      ),
      IndexMultiSectionsModel(
        title: 'البدع وأنواعها',
        startSection: 189,
        endSection: 195,
      ),
    ],
  ),
  IndexMultiSectionsModel(
    title: 'الواجب التزامه في أصحاب الرسول صلى الله عليه وسلم وأهل بيته',
    startSection: 196,
    endSection: 206,
  ),
  IndexMultiSectionsModel(
    title: 'متفرقات',
    startSection: 207,
    endSection: 211,
  ),
  const IndexSingleSectionModel(
    sectionId: 212,
  ),
];

const List<String> indexTitles = [
  '',
  'المقدمة',
  'أول ما يجب على العباد',
  'الأمر الذي خلق الله الخلق لأجله',
  'معنى العبد',
  'تعريف العبادة',
  'متى يكون العمل عبادة',
  'علامة محبة العبد ربه عز وجل',
  'بماذا عرف العباد ما يحبه الله ويرضاه',
  'شروط العبادة',
  'صدق العزيمة',
  'معنى إخلاص النية',
  'الشَّرع الذي أمر اللهُ تعالى أن لا يُدان إلا به',
  'مراتب دين الإسلام',
  'معنى الإسلام',
  'الدليل على شموله الدين كله عند الإطلاق',
  'الدليل على تعريف الدين بالأركان الخمسة عند التفصيل',
  'محلُّ الشهادتين من الدّين',
  'دليل شهادة أن لا إله إلا الله',
  'معنى شهادة أن لا إله إلا الله',
  'شروط شهادة أن لا إله إلا الله',
  'دليل اشتراط العلم من الكتاب والسنة',
  'دليل اشتراط اليقين من الكتاب والسنة',
  'دليل اشتراط الانقياد من الكتاب والسنة',
  'دليل اشتراط القبول من الكتاب والسنة',
  'دليل الصدق من الكتاب والسنة',
  'دليل اشتراط المحبة من الكتاب والسنة',
  'دليل الموالاة لله والمعاداة لأجله',
  'دليل شهادة أن محمدا رسول الله صلى الله عليه وسلم',
  'معنى شهادة أن محمدا رسول الله صلى الله عليه وسلم',
  'شروط شهادة أن محمدا رسول الله صلى الله عليه وسلم',
  'دليل الصلاة والزكاة',
  'دليل الصوم',
  'دليل الحج',
  'حكم من جحد واحدا من قواعد الإسلام الخمس أو أقر به واستكبر عنه',
  'حكم من أقر بها ثم تركها لنوع تكاسل أو تأويل',
  'تعريف الإيمان',
  'الدليل على أن الإيمان قول وعمل',
  'الدليل على زيادة الإيمان ونقصانه',
  'الدليل على تفاضل أهل الإيمان فيه',
  'الدليل على أن الإيمان يشمل الدين كله عند الإطلاق',
  'الدليل على تعريف الإيمان بالأركان الستة عند التفصيل من السنة والكتاب',
  'معنى الإيمان بالله عز وجل',
  'توحيد الإلهية',
  'ما يضاد توحيد الإلهية',
  'الشرك الأكبر',
  'الشرك الأصغر',
  'الفرق بين الواو وثم',
  'توحيد الربوبية',
  'ما يضاد توحيد الربوبية',
  'توحيد الأسماء والصفات',
  'دليل الأسماء الحسنى من الكتاب والسنة',
  'مثال الأسماء الحسنى من القرآن',
  'مثال الأسماء الحسنى من السنة',
  'دلالة الأسماء الحسنى وأمثلتها',
  'أقسام دلالة الأسماء الحسنى من جهة التضمن',
  'أقسام الأسماء الحسنى من جهة إطلاقها على الله عز وجل',
  'مثال لصفات الذات من الكتاب',
  'مثال لصفات الذات من السنة',
  'مثال لصفات الأفعال من الكتاب',
  'مثال لصفات الأفعال من السنة',
  'أسماء الله تعالى كلها توقيفية',
  'ما يتضمنه اسمه العلي الأعلى وما في معناه',
  'دليل علو الفوقية من الكتاب',
  'دليل علو الفوقية من السنة',
  'أقوال أئمة السلف الصالح في مسألة الاستواء',
  'دليل علو القهر من الكتاب',
  'دليل علو القهر من السنة',
  'دليل علو الشأن',
  'معنى قوله عليه السلام في الأسماء الحسنى من أحصاها دخل الجنة',
  'ما يضاد توحيد الأسماء والصفات',
  'جميع أنواع التوحيد متلازمة',
  'الدليل على الإيمان بالملائكة من الكتاب والسنة',
  'معنى الإيمان بالملائكة',
  'بعض أنواع الملائكة',
  'دليل الإيمان بالكتب',
  'تسمية الكتب في القرآن',
  'معنى الإيمان بكتب الله عز وجل',
  'منزلة القرآن من الكتب المتقدمة',
  'ما يجب التزامه في حق القرآن على جميع الأمة',
  'معنى التمسك بالكتاب والقيام بحقه',
  'حكم من قال بخلق القرآن',
  'صفة الكلام ذاتية أو فعلية',
  'التعريف بالواقفة وبيان حكمهم',
  'حكم من قال لفظي بالقرآن مخلوق',
  'دليل الإيمان بالرسل',
  'معنى الإيمان بالرسل',
  'اتفقت دعوة الرسل على أصل العبادة وأساسها',
  'الدليل على اتفاق الرسل في أصل العبادة',
  'الدليل على اختلاف شرائع الرسل في الفروع',
  'هل قص الله جميع الرسل في القرآن',
  'جملة الرسل الذين سماهم الله في القرآن',
  'أُولو العزم من الرسل',
  'أول الرسل',
  'متى كان الاختلاف',
  'خاتم النبيين والدليل على ذلك',
  'خصائص النبي صلى الله عليه وسلم',
  'معجزات الأنبياء',
  'دليل إعجاز القرآن الكريم',
  'دليل الإيمان باليوم الآخر',
  'معنى الإيمان باليوم الآخر',
  'متى تكون الساعة',
  'مثال أمارات الساعة من الكتاب',
  'مثال أمارات الساعة من السنة',
  'دليل الإيمان بالموت',
  'دليل فتنة القبر ونعيمه أو عذابه من الكتاب',
  'دليل فتنة القبر ونعيمه أو عذابه من السنة',
  'دليل البعث من القبور',
  'حكم من كذب البعث',
  'دليل النفخ في الصور وكم نفخات ينفخ فيه',
  'صفة الحشر من الكتاب',
  'صفة الحشر من السنة',
  'صفة الموقف من الكتاب',
  'صفة الموقف من السنة',
  'صفة العرض والحساب من الكتاب',
  'صفة العرض والحساب من السنة',
  'صفة نشر الصحف من الكتاب',
  'دليل نشر الصحف من السنة',
  'دليل الميزان من الكتاب وبيان صفة الوزن',
  'دليل الميزان من السنة وبيان صفة الوزن',
  'دليل الصراط من الكتاب',
  'دليل الصراط من السنة',
  'دليل القصاص من الكتاب',
  'دليل القصاص وصفته من السنة',
  'دليل الحوض من الكتاب',
  'دليل الحوض وصفته من السنة',
  'دليل الإيمان بالجنة والنار',
  'معنى الإيمان بالجنة والنار',
  'الدليل على وجود الجنة والنار الآن',
  'الدليل على بقاء الجنة والنار وأنهما لا يفنيان',
  'الدليل على أن المؤمنين يرون ربهم تبارك وتعالى في الدار الآخرة',
  'دليل الإيمان بالشفاعة وممن تكون ولمن تكون',
  'أنواع الشفاعة الست وأعظمها',
  'معنى حديث لن يُدخل الجنة أحد عمله والجمع بينه وبين آية وَنُودُوا أَنْ تِلْكُمُ الْجَنَّةُ أُورِثْتُمُوهَا بِمَا كُنْتُمْ تَعْمَلُون',
  'دليل الإيمان بالقدر جملة',
  'مراتب الإيمان بالقدر',
  'دليل المرتبة الأولى الإيمان بالعلم',
  'دليل المرتبة الثانية الإيمان بكتابة المقادير وما يدخلها من التقادير',
  'دليل التقدير الأزلي',
  'دليل التقدير العمري يوم الميثاق',
  'دليل التقدير العمري الذي عند أول تخليق النطفة',
  'دليل التقدير الحولي في ليلة القدر',
  'دليل التقدير اليومي',
  'ما يقتضيه سبق المقادير بالشقاوة والسعادة',
  'دليل المرتبة الثالثة وهي الإيمان بالمشيئة',
  'الإرادة في النصوص جاءت على معنيين',
  'دليل المرتبة الرابعة من الإيمان بالقدر وهي مرتبة الخلق',
  'معنى قول النبي عليه السلام والخير كله في يديك والشر ليس إليك',
  'للعباد قدرة على أعمالهم ولهم مشيئة وإرادة',
  'أليس ممكنا في قدرة الله أن يجعل كل عباده مؤمنين',
  'منزلة الإيمان بالقدر من الدين',
  'شعب الإيمان',
  'دليل الإحسان من الكتاب والسنة',
  'ما يضاد الإيمان',
  'كيفية منافاة الكفر الاعتقادي للإيمان بالكلية',
  'أقسام الكفر الأكبر المخرج من الملة',
  'كفر الجهل والتكذيب',
  'كفر النفاق',
  'الكفر العملي الذي لا يخرج من الملة',
  'السجود للصنم والاستهانة بالكتاب وسب الرسول والهزل بالدين',
  'أقسام الظلم والفسوق والنفاق',
  'مثال كل من الظلم الأكبر والأصغر',
  'مثال الفسوق الأكبر والأصغر',
  'مثال النفاق الأكبر والأصغر',
  'حكم السحر والساحر',
  'حد الساحر',
  'تعريف النشرة وبيان حكمها',
  'الرقى المشروعة',
  'الرقى الممنوعة',
  'حكم التعاليق من التمائم والأوتار والحلق والخيوط والودع ونحوها',
  'حكم التعاليق من القرآن',
  'حكم الكهان',
  'حكم من صدق كاهنا',
  'حكم التَّنْجيم',
  'حكم الاستسقاء بالأنواء',
  'حكم الطِّيَرَة وما يُذْهِبُها',
  'حكم العين',
  'أقسام المعاصي وبماذا تكفر السيئات',
  'تعريف الكبائر',
  'ما تكفر به جميع الصغائر والكبائر',
  'التوبة النصوح',
  'وقت انقطاع التوبة في حق كل فرد من أفراد الناس',
  'انقطاع التوبة من عمر الدنيا',
  'حكم من مات من الموحدين مُصِرَّا على كبيرة',
  'هل الحدود كفارات لأهلها',
  'الجمع بين قوله عليه السلام فهو إلى الله إن شاء عفا عنه وإن شاء عاقبه وبين أن من رجحت سيئاته بحسناته دخل النار',
  'المراد بالصراط المستقيم الذي أمرنا الله تعالى بسلوكه',
  'الصراط المستقيم كيفية سلوكه والسلامة من الانحراف عنه',
  'ما يضاد السنة',
  'أقسام البدعة باعتبار إخلالها بالدين',
  'البدع المكفرة',
  'البدع الغير مكفرة',
  'أقسام البدع بحسب ما تقع فيه',
  'أقسام البدع في العبادات',
  'حالات البدعة مع العبادة التي تقع فيها',
  'البدع في المعاملات',
  'الواجب التزامه في أصحاب رسول الله صلى الله عليه وسلم وأهل بيته',
  'أفضل الصحابة إجمالا',
  'أفضل الصحابة تفصيلا',
  'مدة الخلافة بعد رسول الله صلى الله عليه وسلم',
  'الدليل على خلافة الأربعة جملة',
  'الدليل على خلافة الثلاثة إجمالا',
  'الدليل على خلافة أبي بكر وعمر رضي الله عنهما إجمالا',
  'الدليل على خلافة أبي بكر وتقديمه فيها',
  'الدليل على تقديم عمر في الخلافة بعد أبي بكر',
  'الدليل على تقديم عثمان بعدهما في الخلافة',
  'الدليل على خلافة علي وأولويته بالحق بعدهم',
  'الواجب لولاة الأمور والدليل على ذلك',
  'على من يجب الأمر بالمعروف والنهي عن المنكر وما مراتبه',
  'حكم كرامات الأولياء',
  'صفة أولياء الله',
  'الطائفة التي عناها النبي عليه السلام بقوله لا تزال طائفة من أمتي على الحق ظاهرة',
  'الخاتمة',
];

final List<String> indexTitlesProcessed = indexTitles.map(normalizeArabicText).toList();

const String privacyPolicyMd = """
Privacy Policy
==============

EasyBooks for information technology operates the الإسلام في ٢٠٠ سؤال وجواب mobile application .

This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.

We use your data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.

Information Collection And Use
------------------------------

We collect several different types of information for various purposes to provide and improve our Service to you.

### Types of Data Collected

#### Personal Data

While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:

*   Cookies and Usage Data

#### Usage Data

We may also collect information that your browser sends whenever you visit our Service or when you access the Service by or through a mobile device ("Usage Data").

When you access the Service by or through a mobile device, this Usage Data may include information such as the type of mobile device you use, your mobile device unique ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use, unique device identifiers and other diagnostic data.

#### Tracking & Cookies Data

We use cookies and similar tracking technologies to track the activity on our Service and hold certain information.

Cookies are files with small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device. Tracking technologies also used are beacons, tags, and scripts to collect and track information and to improve and analyze our Service.

You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service.

Examples of Cookies we use:

*   **Session Cookies.** We use Session Cookies to operate our Service.
*   **Preference Cookies.** We use Preference Cookies to remember your preferences and various settings.
*   **Security Cookies.** We use Security Cookies for security purposes.

Use of Data
-----------

EasyBooks for information technology uses the collected data for various purposes:

*   To provide and maintain the Service
*   To notify you about changes to our Service
*   To allow you to participate in interactive features of our Service when you choose to do so
*   To provide customer care and support
*   To provide analysis or valuable information so that we can improve the Service
*   To monitor the usage of the Service
*   To detect, prevent and address technical issues

Transfer Of Data
----------------

Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.

If you are located outside Jordan and choose to provide information to us, please note that we transfer the data, including Personal Data, to Jordan and process it there.

Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.

EasyBooks for information technology will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.

Disclosure Of Data
------------------

### Legal Requirements

EasyBooks for information technology may disclose your Personal Data in the good faith belief that such action is necessary to:

*   To comply with a legal obligation
*   To protect and defend the rights or property of EasyBooks for information technology
*   To prevent or investigate possible wrongdoing in connection with the Service
*   To protect the personal safety of users of the Service or the public
*   To protect against legal liability

Security Of Data
----------------

The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.

Service Providers
-----------------

We may employ third party companies and individuals to facilitate our Service ("Service Providers"), to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.

These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.

### Analytics

We may use third-party Service Providers to monitor and analyze the use of our Service.

*   **Google Analytics**
    
    Google Analytics is a web analytics service offered by Google that tracks and reports website traffic. Google uses the data collected to track and monitor the use of our Service. This data is shared with other Google services. Google may use the collected data to contextualize and personalize the ads of its own advertising network.
    
    For more information on the privacy practices of Google, please visit the Google Privacy & Terms web page: [https://policies.google.com/privacy?hl=en](https://policies.google.com/privacy?hl=en)
    

Links To Other Sites
--------------------

Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.

We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.

Children's Privacy
------------------

Our Service does not address anyone under the age of 18 ("Children").

We do not knowingly collect personally identifiable information from anyone under the age of 18. If you are a parent or guardian and you are aware that your Children has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from children without verification of parental consent, we take steps to remove that information from our servers.

Changes To This Privacy Policy
------------------------------

We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update the "effective date" at the top of this Privacy Policy.

You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

Contact Us
----------

If you have any questions about this Privacy Policy, please contact us:

*   By email: easybooksdev@gmail.com
    """;

