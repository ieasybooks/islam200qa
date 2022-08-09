import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:islam200qa/constants.dart';
import 'package:islam200qa/widgets/index/index_single_section_model.dart';
import 'package:islam200qa/router/routes.gr.dart';
import 'package:islam200qa/utils/string_utils.dart';
import 'package:sprintf/sprintf.dart';

class IndexSingleSection extends StatelessWidget {
  const IndexSingleSection({
    Key? key,
    required this.indexSingleSectionModel,
    required this.rightPadding,
  }) : super(key: key);

  final IndexSingleSectionModel indexSingleSectionModel;
  final double rightPadding;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(right: rightPadding),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: sprintf(
                '%s. ',
                [
                  arabizeNumbers(
                    (indexSingleSectionModel.sectionId).toString(),
                  ),
                ],
              ),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: indexTitles[indexSingleSectionModel.sectionId]),
          ],
        ),
      ),
      onTap: () {
        AutoRouter.of(context).push(
          SectionRoute(
            sectionId: indexSingleSectionModel.sectionId,
          ),
        );
        Navigator.pop(context);
      },
    );
  }
}
