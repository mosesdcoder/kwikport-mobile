import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/agency_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class AgencyDetailsDialog extends StatelessWidget {
  final AgencyModel agency;

  const AgencyDetailsDialog({
    super.key,
    required this.agency,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorCodes.aeroBlue.withOpacity(0.1),
                    colorCodes.paleCornflowerBlue.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Agency Details",
                    style: kwikTextStlye(
                      20.0,
                      FontWeight.w700,
                      colorCodes.black,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 20),
                      color: colorCodes.graniteGrey,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Agency Logo/Image with shadow
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorCodes.aeroBlue.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/icons/dashboard/procurement_agency_logo.png",
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Agency Name
                    _buildDetailCard(
                      "Agency Name",
                      agency.name ?? "N/A",
                    ),
                    
                    // Rating
                    _buildDetailCard(
                      "Rating",
                      "${agency.rating?.toStringAsFixed(1) ?? '0.0'} ⭐",
                    ),
                    
                    // Service Fee
                    _buildDetailCard(
                      "Service Fee (USD)",
                      MoneyUtils.formatMoney(
                        agency.serviceFeePerTonInUSD ?? agency.serviceFeeInUSD ?? 0,
                        symbol: "\$",
                        decimalDigits: 2,
                      ),
                    ),
                    
                    // Service Fee (Naira)
                    _buildDetailCard(
                      "Service Fee (NGN)",
                      MoneyUtils.formatMoney(
                        agency.serviceFeePerTon ?? agency.serviceFee ?? 0,
                        symbol: "₦",
                        decimalDigits: 2,
                      ),
                    ),
                    
                    // Delivery Time
                    _buildDetailCard(
                      "Delivery Time",
                      "${agency.numberOfDaysToDeliver ?? 0} days",
                    ),
                    
                    // Route Coverage
                    _buildDetailCard(
                      "Route Coverage",
                      agency.routeCoverage ?? "N/A",
                    ),
                    
                
                    // Address
                    if (agency.address != null)
                      _buildDetailCard(
                        "Address",
                        agency.address!,
                      ),
                    
                
                    
                 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, {bool isLongText = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorCodes.paleCornflowerBlue.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: kwikTextStlye(
              11.0,
              FontWeight.w500,
              colorCodes.graniteGrey.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: kwikTextStlye(
              15.0,
              FontWeight.w600,
              colorCodes.black,
            ),
            maxLines: isLongText ? null : 3,
            overflow: isLongText ? null : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}
