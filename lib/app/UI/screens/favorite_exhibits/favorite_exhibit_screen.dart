import '/libraries/controllers.dart';
import '/libraries/configs.dart';
import '/libraries/custom_packages.dart';
import '/libraries/system_packages.dart';

class FavoriteExhibitsScreen extends StatefulWidget {
  const FavoriteExhibitsScreen({super.key});

  @override
  State<FavoriteExhibitsScreen> createState() => _FavoriteExhibitsScreenState();
}

class _FavoriteExhibitsScreenState extends State<FavoriteExhibitsScreen> {
  final _favoriteController = Get.find<FavoriteController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Экспонаты'),
        centerTitle: true
      ),
      body: _favoriteController.exhibits.isNotEmpty ? Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _favoriteController.exhibits.length,
          itemBuilder: (_, i) {
            final exhibit = _favoriteController.exhibits[i];
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: exhibit.exhibitImagePath,
                    placeholder: (_, url) => _buildLoadingIndicator(),
                    errorWidget: (_, url, error) => _buildErrorDisplay(),
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    fit: BoxFit.cover,
                  )
                ),
                const SizedBox(height: 20),
                Text(
                  exhibit.label,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      WidgetConfig.containerBoxShadow
                    ],
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                    title: const Text('Удалить из избранного'),
                    leading: const Icon(Icons.favorite, color: Colors.red, size: 30),
                    onTap: () {
                      _favoriteController.removeExhibit(exhibit);
                    }
                  )
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      WidgetConfig.containerBoxShadow
                    ],
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDescription(
                      )
                    ]
                  )
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
              ]
            );
          }
        );
      }) : Center(
        child: Text('Пусто', style: Theme.of(context).textTheme.titleLarge)
      )
    );
  }
  Widget _buildDescription({String? content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 10),
            Text(
              'Описание',
              style: Theme.of(context).textTheme.titleMedium
            )
          ]
        ),
        const SizedBox(height: 16),
        Text(
          content ?? 'Скоро',
          style: Theme.of(context).textTheme.bodyMedium
        )
      ]
    );
  }
  Widget _buildLoadingIndicator() {
    return const Align(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 4
        )
      )
    );
  }
  Widget _buildErrorDisplay() {
    return const Align(
      child: Text('Ошибка загрузки')
    );
  }
}