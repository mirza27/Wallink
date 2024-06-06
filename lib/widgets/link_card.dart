import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/notif_controller.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/dialog/delete_confirmation.dart';
import 'package:wallink_v1/dialog/launch_confirmation.dart';
import 'package:wallink_v1/form/edit_link_form.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/tracker_service.dart';

class LinkCard extends StatefulWidget {
  final Link link;
  final Function() onChanged; // memanggil fungsi edit di subcategory card

  const LinkCard({super.key, required this.link, required this.onChanged});

  @override
  State<LinkCard> createState() => _LinkCardState();
}

// fungsi launch url
class _LinkCardState extends State<LinkCard> {
  bool _isColored = false;
  bool _alwaysAskConfirmation = true;
  final NotifController notifController = Get.put(NotifController());

  Future<void> _launchURL(BuildContext context, String url) async {
    if (!url.startsWith("https://") && !url.startsWith("http://")) {
      url = "https://$url";

      await (TrackerService()).track(
        "launch-link",
        {},
        content: {
          "linkId": widget.link.id.toString(),
          "link": url,
        },
      );
    }

    final Uri uri = Uri.parse(url);

    showDialog(
      context: context,
      builder: (context) => LaunchConfirmationDialog(
        title: 'Launch this link?',
        message: 'Are you sure you want to launch this link?',
        onLaunchConfirmed: () async {
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw "can't launch url";
          }
        },
      ),
    );
  }

  // fungsi copy

  Future<void> _copytoClipboard(String url) async {
    Clipboard.setData(ClipboardData(text: url));
    await notifController.showNotif('Link copied', 'Link copied to clipboard',
        Icons.copy, Colors.lightGreen);
    setState(() {
      _isColored = true; // Ubah _isColored menjadi true
    });

    // Tunggu sampai animasi selesai
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isColored = false; // Kembalikan _isColored ke false
    });
  }

  // delete link
  Future<void> _deleteLink(int linkId) async {
    await deleteLink(linkId);
    await widget.onChanged.call();
    await (TrackerService()).track(
      "delete-link",
      {},
      content: {
        "linkId": linkId.toString(),
      },
    );
  }

  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  double _scrollMax = 0.0;
  Timer? _timer;
  final int _delaySeconds = 1;

  void _markAsArchived(int id) async {
    await markAsArchived(id);
    setState(() {
      widget.onChanged.call();
    });
  }

  void _markAsUnArchived(int id) async {
    await markAsUnArchived(id);
    setState(() {
      widget.onChanged.call();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollMax = _scrollController.position.maxScrollExtent;
      // _startScrolling();
    });
  }

  Future<void> _loadPreferences() async {
    bool alwaysAskConfirmation = await AppPreferences.getAlwaysAsk();

    setState(() {
      _alwaysAskConfirmation = alwaysAskConfirmation;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollPosition < _scrollMax) {
        _scrollPosition += 1.0;
        _scrollController.animateTo(_scrollPosition,
            duration: const Duration(milliseconds: 50), curve: Curves.linear);
      } else {
        _scrollPosition = 0.0;
        _scrollController.jumpTo(_scrollPosition);
        _timer?.cancel();
        Future.delayed(
          Duration(seconds: _delaySeconds),
          () {
            _startScrolling();
          },
        );
      }
    });
  }

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          // delete link
          SlidableAction(
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(0),
            onPressed: (context) {
              if (_alwaysAskConfirmation) {
                showDialog(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                    title: 'Warning!',
                    message:
                        'Are you sure you want to delete this link? This action cannot be undone',
                    onDeleteConfirmed: () async {
                      _deleteLink(
                        widget.link.id!,
                      );
                      await notifController.showNotif(
                          'Success',
                          'Link deleted successfully',
                          Icons.delete,
                          Colors.green);
                    },
                    isThisLink: true,
                  ),
                );
              } else {
                _deleteLink(
                  widget.link.id!,
                );
              }
            },
            icon: CupertinoIcons.delete,
            backgroundColor: const Color.fromARGB(255, 255, 201, 201),
            foregroundColor: const Color.fromARGB(255, 229, 72, 77),
          ),
          const SizedBox(
            width: 5,
          ),

          // edit link
          SlidableAction(
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(0),
            onPressed: (context) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(30, 31, 36, 1),
                            width: 1.5,
                          ),
                        ),
                        content: EditLinkForm(
                          link: widget.link,
                          //onUpdate: widget.onChanged,
                          onUpdate: () async {
                            await notifController.showNotif(
                                "Success",
                                'Link updated successfully',
                                Icons.security_update_good,
                                Color.fromARGB(255, 220, 211, 5));
                            widget.onChanged();
                          },
                        ),
                        insetPadding: const EdgeInsets.all(10),
                      ));
            },
            backgroundColor: const Color.fromARGB(255, 255, 253, 201),
            foregroundColor: Color.fromARGB(255, 167, 159, 0),
            icon: Icons.create_outlined,
          ),
          const SizedBox(
            width: 5,
          ),

          // archive link
          SlidableAction(
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(0),
            onPressed: (context) async {
              if (widget.link.is_archive ?? false) {
                _markAsArchived(widget.link.id!);
              } else {
                _markAsUnArchived(widget.link.id!);
              }
              setState(() {
                widget.link.is_archive = !(widget.link.is_archive ?? false);
              });
              await notifController.showNotif(
                widget.link.is_archive ?? false
                    ? 'Link Unarchived'
                    : 'Link Archived',
                widget.link.is_archive ?? false
                    ? 'Link has been successfully unarchived'
                    : 'Link has been successfully archived',
                widget.link.is_archive ?? false
                    ? Icons.unarchive
                    : Icons.archive,
                Colors.blue, // Warna latar belakang biru
              );
            },
            foregroundColor: const Color.fromARGB(255, 5, 105, 220),
            backgroundColor: const Color.fromARGB(255, 201, 226, 255),
            icon: CupertinoIcons.archivebox,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () {
          _copytoClipboard(widget.link.link as String);
        },
        onTap: () {
          _launchURL(context, widget.link.link as String);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _isColored ? Colors.grey.withOpacity(0.2) : null,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Row(
              children: <Widget>[
                // LINK DAN LAUNCH LINK
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          // nama link
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.link.nameLink as String,
                                style: const TextStyle(
                                  fontFamily: 'sharp',
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.link.link as String,
                        style: const TextStyle(
                          fontFamily: 'sharp',
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),

                // favorit icon
                GestureDetector(
                  onTap: () async {
                    if (widget.link.is_favorite ?? false) {
                      await markAsUnFavorite(widget.link.id!);
                      await notifController.showNotif(
                          'Removed from Favorites',
                          'Link removed from favorites',
                          Icons.favorite_border,
                          Colors.pink);
                    } else {
                      await markAsFavorite(widget.link.id!);
                      await notifController.showNotif(
                          'Added to Favorites',
                          'Link added to favorites',
                          Icons.favorite,
                          Colors.pink);
                    }
                    setState(() {
                      // Toggle nilai is_favorite saat tombol ditekan
                      widget.link.is_favorite =
                          !(widget.link.is_favorite ?? false);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        widget.link.is_favorite ?? false
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 21,
                        color: widget.link.is_favorite ?? false
                            ? Colors.red
                            : null, // Warna abu-abu jika is_favorite false
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
