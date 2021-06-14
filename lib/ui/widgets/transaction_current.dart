import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/widgets/home_button.dart';

class TransactionCurrent extends StatelessWidget {
  final Transaction transaction;
  final Function(Depot) onTapPhone;
  final VoidCallback onTapChat;
  final VoidCallback onDenyTransaction;

  const TransactionCurrent({
    required this.transaction,
    required this.onTapPhone,
    required this.onTapChat,
    required this.onDenyTransaction,
  });

  void _denyAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Batalkan Pesanan'),
          content: Text('Yakin ingin membatalkan pesanan ?'),
          actions: [
            TextButton(
              onPressed: () {
                onDenyTransaction();

                Navigator.pop(context);
              },
              child: Text(
                'Iya',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var customIconButton = CustomIconButton(
      label: 'Telepon',
      icon: Icons.phone,
      onPressed: () => onTapPhone(transaction.depot!),
    );
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                width: 100.0,
                fit: BoxFit.fitWidth,
                image: transaction.depot!.image == null
                    ? AssetImage('assets/images/shop.png')
                    : CachedNetworkImageProvider(transaction.depot!.image!)
                        as ImageProvider,
              ),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.depot!.address),
                  const SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('${transaction.createdAt}'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIconButton,
            CustomIconButton(
              label: 'Chat',
              icon: Icons.chat,
              onPressed: onTapChat,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration: Pallette.containerDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.depotName,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.statusDescription,
                style: const TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        transaction.status == 1
            ? MaterialButton(
                onPressed: () => _denyAction(context),
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text('Batalkan pesanan',
                    style: TextStyle(color: Colors.red)),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
