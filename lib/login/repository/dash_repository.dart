import 'package:lib17000ft/models/dash/dash_model.dart';
import '../../configs/app_urls.dart';
import '../../data/network/network_api_services.dart';

class DashRepository {
  final _api = NetworkServicesApi();

Future<DashModel?> fetchDashData(
  String id,
  String? from,
  String? to,
  String? stateName,
  String? block,
  String? school,
) async {
  try {
    print(
      'this is data by fetchdashdata $id $from $to $stateName $block $school',
    );
    // Initialize with required id param
    final queryParams = <String, String>{'id': id};

    // Only add filters if both 'from' and 'to' are provided (required pair)
    final hasDateRange = from != null && to != null;

    // Check if user applied any filter
    final bool hasAnyFilter = hasDateRange ||
        (stateName != null && stateName.isNotEmpty) ||
        (block != null && block.isNotEmpty) ||
        (school != null && school.isNotEmpty);

    if (hasAnyFilter) {
  print('filter applied');
  if (from != null && from.isNotEmpty && to != null && to.isNotEmpty) {
    queryParams['from'] = from;
    queryParams['to'] = to;
  }
  if (stateName != null && stateName.isNotEmpty) queryParams['state'] = stateName;
  if (block != null && block.isNotEmpty) queryParams['block'] = block;
  if (school != null && school.isNotEmpty) queryParams['school'] = school;
}


    final uri = Uri.parse(AppUrls.dashapi).replace(queryParameters: queryParams);
    print('this is my final url for dashboard data $uri');

    final response = await _api.getApi(uri.toString());
    print('this is response from dash $response');

    return DashModel.fromJson(response);
  } catch (e) {
    print('Error parsing DashModel: $e');
    rethrow;
  }
}

}