import 'package:flutter/material.dart';
import 'package:islam200qa/keys_to_be_inherited.dart';
import 'package:islam200qa/utils/shared_preferences_utils.dart';
import 'package:showcaseview/showcaseview.dart';

class TitleCard extends StatefulWidget {
  const TitleCard({
    Key? key,
    required this.sectionId,
    required this.paragraph,
  }) : super(key: key);

  final int sectionId;
  final String paragraph;

  @override
  State<TitleCard> createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {
  late final Widget _defaultBookmark = Showcase(
    key: KeysToBeInherited.of(context).bookmarkKey!,
    title: 'الحفظ والمتابعة',
    description:
        'يمكنك حفظ آخر سؤال توقفت عنده وإكمال القراءة منه لاحقا من خلال الضغط على هذا الزر',
    child: SizedBox(
      width: 50.0,
      child: RawMaterialButton(
        onPressed: () {
          setBookmark(widget.sectionId);
          _updateBookmarkButton();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إضافة علامة الحفظ.'),
              duration: Duration(milliseconds: 1000),
            ),
          );
        },
        elevation: 2,
        fillColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(0),
        child: const SelectionContainer.disabled(
          child: Icon(
            Icons.bookmark_add_outlined,
            size: 25.0,
          ),
        ),
      ),
    ),
  );

  late Widget _bookmarkButton = _defaultBookmark;

  void _updateBookmarkButton() {
    getBookmark().then(
      (bookmark) {
        setState(() {
          if (bookmark == widget.sectionId) {
            _bookmarkButton = SizedBox(
              width: 50.0,
              child: RawMaterialButton(
                onPressed: () {
                  setBookmark(-1);
                  _updateBookmarkButton();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إزالة علامة الحفظ.'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                elevation: 2,
                fillColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                child: const SelectionContainer.disabled(
                  child: Icon(
                    Icons.bookmark_added,
                    size: 25.0,
                  ),
                ),
              ),
            );
          } else {
            _bookmarkButton = _defaultBookmark;
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _updateBookmarkButton();
  }

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.paragraph,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            _bookmarkButton,
          ],
        ),
      ),
    );
  }
}
