import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/url_utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  TextSpan _buildTextSpan(
    final BuildContext context,
    final String text,
    final TextStyle textStyle,
  ) {
    return TextSpan(text: text, style: textStyle);
  }

  Text _buildSocialMediaBulletPoint(final String text, final String url) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: '- ',
            style: TextStyle(fontSize: 24),
          ),
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 24,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrlWrapper(Uri.parse(url));
              },
          ),
        ],
      ),
      textAlign: TextAlign.right,
    );
  }

  @override
  Widget build(final BuildContext context) {
    FlutterNativeSplash.remove();

    const TextStyle normalTextStyle = TextStyle(fontSize: 24);
    final TextStyle highlightedTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );

    double horizontalPaddingPercentage =
        getHorizontalPaddingPercentageByScreenSize(getScreenSize(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text('عن التطبيق'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AutoRouter.of(context).pop().then((isPopped) {
              if (!isPopped) {
                AutoRouter.of(context).pushNamed('/');
              }
            });
          },
          tooltip: 'الرجوع',
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 250,
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(
              getDeviceWidth(context) * horizontalPaddingPercentage,
              5.0,
              getDeviceWidth(context) * horizontalPaddingPercentage,
              10.0,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            _buildTextSpan(
                              context,
                              'يسعى تطبيق ',
                              normalTextStyle,
                            ),
                            _buildTextSpan(
                              context,
                              'الإسلام في ٢٠٠ سؤال وجواب',
                              highlightedTextStyle,
                            ),
                            _buildTextSpan(
                              context,
                              ' إلى تقريب العقيدة الصحيحة إلى أفهام المسلمين من خلال توفير محتوى كتاب "أعلام السنة المنشورة لاعتقاد الطائفة الناجية المنصورة" للشيخ "حافظ بن أحمد الحكمي" بشرح الشيخ "إبراهيم رفيق" بطريقة حديثة، سهلة وممتعة وفي متناول الجميع بتضمينه لشرح الكتاب المرئي والمسموع ليتمكن المسلم من قراءة المحتوى ومتابعة الشرح في آنٍ واحد.',
                              normalTextStyle,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            _buildTextSpan(
                              context,
                              'الإسلام في ٢٠٠ سؤال وجواب',
                              highlightedTextStyle,
                            ),
                            _buildTextSpan(
                              context,
                              ' هو أحد منتجات مشروع ',
                              normalTextStyle,
                            ),
                            _buildTextSpan(
                              context,
                              'الكتب المُيسّرة',
                              highlightedTextStyle,
                            ),
                            _buildTextSpan(
                              context,
                              '، والذي يهدف إلى تسهيل وتيسير وصول المسلمين بكافة مستوياتهم إلى الكتب الإسلامية الأساسية في شتّى علوم الإسلام مثل العقيدة، السيرة والحديث بطرق تقنية حديثة وسلسة، وإلى إنشاء أدوات وبرامج تُسهم في إثراء المحتوى التقني الإسلامي من خلال زيادة إنتاجية الدعاة أو من خلال توظيف التقنيات المختلفة في مجالات الدعوة والعلم الشرعي.',
                              normalTextStyle,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              _buildTextSpan(
                                context,
                                'يمكنك متابعة مشروع ',
                                normalTextStyle,
                              ),
                              _buildTextSpan(
                                context,
                                'الكتب المُيسّرة',
                                highlightedTextStyle,
                              ),
                              _buildTextSpan(
                                context,
                                ' والتواصل معنا من خلال:',
                                normalTextStyle,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        _buildSocialMediaBulletPoint(
                          'قناتنا على تيليجرام',
                          'https://t.me/ieasybooks',
                        ),
                        _buildSocialMediaBulletPoint(
                          'قناتنا على يوتيوب',
                          'https://youtube.com/@ieasybooks',
                        ),
                        _buildSocialMediaBulletPoint(
                          'حسابنا على تويتر',
                          'https://twitter.com/iieasybooks',
                        ),
                        _buildSocialMediaBulletPoint(
                          'صفحتنا على فيسبوك',
                          'https://fb.com/ieasybooks',
                        ),
                        _buildSocialMediaBulletPoint(
                          'حسابنا على GitHub (للمبرمجين)',
                          'https://github.com/ieasybooks',
                        ),
                        const Text(
                          '- بريدنا الالكتروني: easybooksdev@gmail.com',
                          style: normalTextStyle,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
