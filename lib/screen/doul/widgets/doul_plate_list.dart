part of '../doul_page.dart';

enum _DoulPriceType { starting, auction }

class _DoulPlateList extends StatelessWidget {
  const _DoulPlateList({
    required this.title,
    required this.plates,
    required this.screenState,
    required this.priceType,
  });

  final String title;
  final List<PlateModel> plates;
  final ScreenState screenState;
  final _DoulPriceType priceType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CText(
          text: title,
          fontSize: FontSizeRes.body,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: ConstRes.defaultVertical),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (screenState.isLoading) {
      return const Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorRes.primaryColor),
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (screenState.isFailure) {
      return const Center(child: CText(text: 'Không thể tải dữ liệu'));
    }

    if (plates.isEmpty) {
      return const Center(child: CText(text: 'Không có dữ liệu'));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: plates.length,
      separatorBuilder:
          (context, index) => const SizedBox(height: ConstRes.defaultVertical),
      itemBuilder: (context, index) => _buildPlateItem(plates[index]),
    );
  }

  Widget _buildPlateItem(PlateModel plate) {
    final price =
        priceType == _DoulPriceType.starting
            ? plate.startingPrice
            : plate.auctionPrice;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.grey, width: 1),
        color: ColorRes.backgroundWhiteColor,
        borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ConstRes.defaultVertical,
        vertical: ConstRes.defaultVertical,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: plate.plateColor,
                      borderRadius: BorderRadius.circular(
                        ConstRes.defaultRadius,
                      ),
                      border: Border.all(color: ColorRes.grey, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: ConstRes.defaultHorizontal / 2,
                      vertical: ConstRes.defaultVertical / 2,
                    ),
                    child: CText(
                      text: _formatPlate(plate.fullNumber, isCar: plate.isCar),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: ConstRes.defaultHorizontal),
              Expanded(child: CText(text: plate.province.name, maxLines: 10)),
            ],
          ),
          const SizedBox(height: ConstRes.defaultVertical),
          Row(
            children: [
              Expanded(
                child: CText(text: CurrencyUtils.format(price), maxLines: 10),
              ),
              const SizedBox(width: ConstRes.defaultHorizontal),
              Expanded(
                child: CText(
                  text: DateTimeUtils.getFullDateTime(
                    DateTimeUtils.getDateTime(plate.auctionStartTime),
                  ),
                  maxLines: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPlate(String plate, {bool isCar = false}) {
    final value = plate.replaceAll('-', '').replaceAll('.', '');
    if (isCar) {
      if (value.substring(3).length > 4) {
        return '${value.substring(0, 3)}-${value.substring(3, 6)}.${value.substring(6)}';
      } else {
        return '${value.substring(0, 3)}-${value.substring(3)}';
      }
    } else {
      if (value.substring(4).length > 4) {
        return '${value.substring(0, 4)}-${value.substring(4, 7)}.${value.substring(7)}';
      } else {
        return '${value.substring(0, 4)}-${value.substring(4)}';
      }
    }
  }
}
