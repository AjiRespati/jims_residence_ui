import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/confirmation_dialog.dart';

class TransferOwnerItem extends StatelessWidget with GetItMixin {
  TransferOwnerItem({required this.item, required this.isMobile, super.key});

  final dynamic item;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final level = get<SystemViewModel>().level;
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: ClipRRect(
          child: InkWell(
            // onTap:
            //     item['transactionType'] == 'debit'
            //         ? null
            //         : () {
            //           get<RoomViewModel>().choosenInvoiceId = item['id'];
            //           Navigator.pushNamed(context, paymentDetailRoute);
            //         },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        item['proofPath'] != null
                            ? GestureDetector(
                              onTap:
                                  () => showPopup(
                                    context,
                                    null,
                                    ApplicationInfo.baseUrl + item['proofPath'],
                                    "bukti_transfer",
                                    isMobile,
                                  ),
                              child: Container(
                                height: 60,
                                width: 85,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Image.network(
                                  ApplicationInfo.baseUrl + item['proofPath'],
                                ),
                              ),
                            )
                            : Container(
                              height: 60,
                              width: 85,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),

                        SizedBox(width: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatDateFromYearToDay(
                                DateTime.parse(item['transferDate']),
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                item['BoardingHouse']['name'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 35, width: 1, color: Colors.grey),
                    ],
                  ),
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        item['description'],
                        // style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 35, width: 1, color: Colors.grey),
                    ],
                  ),

                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrency(item['amount'].toDouble()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 90),
                  if (level < 2)
                    SizedBox(width: 30)
                  else
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            confirmationDialog(
                              context,
                              "Hapus Transaksi",
                              "Apakah transaksi ini, ${item['description']}, ${formatCurrency(item?['amount'] ?? 0.toDouble())}, akan dihapus?",
                              handleConfirmation: (isConfirmed) async {
                                if (isConfirmed) {
                                  RoomViewModel model = get<RoomViewModel>();
                                  DateTime? periode = model.periode;
                                  await model.deleteTransferOwner(
                                    id: item['id'],
                                  );
                                  await model.getAllTransferOwners(
                                    boardingHouseId:
                                        item['BoardingHouse']['id'],
                                    dateFrom:
                                        periode != null
                                            ? DateTime(
                                              periode.year,
                                              periode.month,
                                              1,
                                            )
                                            : DateTime(now.year, now.month, 1),
                                    dateTo:
                                        periode != null
                                            ? DateTime(
                                              periode.year,
                                              periode.month + 1,
                                            ).subtract(Duration(seconds: 1))
                                            : DateTime(
                                              now.year,
                                              now.month + 1,
                                            ).subtract(Duration(seconds: 1)),
                                  );
                                }
                              },
                              isMobile: false,
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
