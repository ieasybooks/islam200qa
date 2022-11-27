import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islam200qa/utils/screen_utils.dart';
import 'package:islam200qa/utils/url_utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    FlutterNativeSplash.remove();

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
                            const TextSpan(
                              text: 'يسعى تطبيق ',
                              style: TextStyle(fontSize: 24),
                            ),
                            TextSpan(
                              text: 'الإسلام في ٢٠٠ سؤال وجواب',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' إلى تقريب العقيدة الصحيحة إلى أفهام المسلمين من خلال توفير محتوى كتاب "أعلام السنة المنشورة لاعتقاد الطائفة الناجية المنصورة" للشيخ "حافظ بن أحمد الحكمي" بشرح الشيخ "إبراهيم رفيق" بطريقة حديثة، سهلة وممتعة وفي متناول الجميع بتضمينه لشرح الكتاب المرئي والمسموع ليتمكن المسلم من قراءة المحتوى ومتابعة الشرح في آنٍ واحد.',
                              style: TextStyle(fontSize: 24),
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
                            TextSpan(
                              text: 'الإسلام في ٢٠٠ سؤال وجواب',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const TextSpan(
                              text: ' هو أحد منتجات مشروع ',
                              style: TextStyle(fontSize: 24),
                            ),
                            TextSpan(
                              text: 'الكتب المُيسّرة',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  '، والذي يهدف إلى تسهيل وتيسير وصول المسلمين بكافة مستوياتهم إلى الكتب الإسلامية الأساسية في شتّى علوم الإسلام مثل العقيدة، السيرة والحديث بطرق تقنية حديثة وسلسة، وإلى إنشاء أدوات وبرامج تُسهم في إثراء المحتوى التقني الإسلامي من خلال زيادة إنتاجية الدعاة أو من خلال توظيف التقنيات المختلفة في مجالات الدعوة والعلم الشرعي.',
                              style: TextStyle(fontSize: 24),
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
                              const TextSpan(
                                text: 'يمكنك متابعة مشروع ',
                                style: TextStyle(fontSize: 24),
                              ),
                              TextSpan(
                                text: 'الكتب المُيسّرة',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const TextSpan(
                                text: ' والتواصل معنا من خلال:',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '- ',
                                style: TextStyle(fontSize: 24),
                              ),
                              TextSpan(
                                text: 'قناتنا على اليوتيوب',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlWrapper(
                                      Uri.parse(
                                          'https://youtube.com/@ieasybooks'),
                                    );
                                  },
                              )
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '- ',
                                style: TextStyle(fontSize: 24),
                              ),
                              TextSpan(
                                text: 'قناتنا على تيليجرام',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlWrapper(
                                      Uri.parse(
                                          'https://t.me/ieasybooks'),
                                    );
                                  },
                              )
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '- ',
                                style: TextStyle(fontSize: 24),
                              ),
                              TextSpan(
                                text: 'صفحتنا على الفيسبوك',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlWrapper(
                                      Uri.parse(
                                          'https://fb.com/ieasybooks'),
                                    );
                                  },
                              )
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '- ',
                                style: TextStyle(fontSize: 24),
                              ),
                              TextSpan(
                                text: 'حسابنا على GitHub (للمبرمجين)',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 24,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlWrapper(
                                      Uri.parse(
                                          'https://github.com/ieasybooks'),
                                    );
                                  },
                              )
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const Text(
                          '- بريدنا الالكتروني: easybooksdev@gmail.com',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.justify,
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
