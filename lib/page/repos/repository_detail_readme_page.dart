import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsy_github_app_flutter/common/dao/repos_dao.dart';
import 'package:gsy_github_app_flutter/common/localization/default_localizations.dart';
import 'package:gsy_github_app_flutter/common/scoped_model/scoped_model.dart';
import 'package:gsy_github_app_flutter/common/style/gsy_style.dart';
import 'package:gsy_github_app_flutter/page/repos/scope/repos_detail_model.dart';
import 'package:gsy_github_app_flutter/widget/markdown/gsy_markdown_widget.dart';

/// Readme
/// Created by guoshuyu
/// Date: 2018-07-18

class RepositoryDetailReadmePage extends StatefulWidget {
  final String? userName;

  final String? reposName;

  const RepositoryDetailReadmePage(this.userName, this.reposName, {super.key});

  @override
  RepositoryDetailReadmePageState createState() =>
      RepositoryDetailReadmePageState();
}

class RepositoryDetailReadmePageState extends State<RepositoryDetailReadmePage>
    with AutomaticKeepAliveClientMixin {
  bool isShow = false;

  String? markdownData;

  RepositoryDetailReadmePageState();

  refreshReadme() {
    ReposDao.getRepositoryDetailReadmeDao(widget.userName, widget.reposName,
            ReposDetailModel.of(context).currentBranch)
        .then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
          return res.next?.call();
        }
      }
      return Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var widget = (markdownData == null)
        ? Center(
            child: Container(
              width: 200.0,
              height: 200.0,
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitDoubleBounce(
                      color: Theme.of(context).primaryColor),
                  Container(width: 10.0),
                  Text(
                      GSYLocalizations.i18n(context)!.loading_text,
                      style: GSYConstant.middleText),
                ],
              ),
            ),
          )
        : GSYMarkdownWidget(markdownData: markdownData);

    return ScopedModelDescendant<ReposDetailModel>(
      builder: (context, child, model) => widget,
    );
  }
}
