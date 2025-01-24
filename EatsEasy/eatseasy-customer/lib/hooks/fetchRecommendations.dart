import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchRecommendations(code, all) {
  final foods = useState<List<Food>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('');
      if(all == true){
       url = Uri.parse('${Environment.appBaseUrl}/api/foods/recommendation/$code?all=true');
      }else{

       url = Uri.parse('${Environment.appBaseUrl}/api/foods/recommendation/$code');
      }
      final response = await http.get(url);

      if (response.statusCode == 200) {
        foods.value = foodFromJson(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
