import '/libraries/services.dart';
import '/libraries/configs.dart';
import '/libraries/screens.dart';
import '/libraries/custom_packages.dart';
import '/libraries/api.dart';
import '/libraries/models.dart';
import '/libraries/system_packages.dart';

class CatalogExpositionsScreen extends StatefulWidget {
  const CatalogExpositionsScreen({super.key});

  @override
  State<CatalogExpositionsScreen> createState() => _CatalogExpositionsScreenState();
}

class _CatalogExpositionsScreenState extends State<CatalogExpositionsScreen> {
  final _infoExpRoutes = [
    () {
      NavigationService().navigateToScreen(() => InfoExposition1Screen());
    },
    () {
      NavigationService().navigateToScreen(() => InfoExposition2Screen());
    },
    () {
      NavigationService().navigateToScreen(() => InfoExposition3Screen());
    }
  ];
  late Future<List<Exposition>> expositionData;
  
  @override
  void initState() {
    super.initState();
    expositionData = ApiExpostion().getExpositions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог экспозиций')),
      body: FutureBuilder<List<Exposition>>(
        future: expositionData,
        builder: (_, snap) => snap.connectionState == ConnectionState.waiting ? _buildLoadingIndicator(
        ) : snap.hasData ? _buildExpositionsList(
          expositions: snap.data!
        ) : _buildErrorDisplay()
      )
    );
  }
  Widget _buildExpositionsList({required List<Exposition> expositions}) {
    return ListView.builder(
      itemCount: expositions.length,
      itemBuilder: (_, i) => _buildExpositionItem(exposition: expositions[i], index: i)
    );
  }
  Widget _buildExpositionItem({required Exposition exposition, required int index}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExpostionHeader(label: exposition.label),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExpositionImage(imageUrl: exposition.expositionImagePath),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      exposition.label2 ?? 'Скоро', 
                      style: Theme.of(context).textTheme.bodyMedium
                    )
                  )
                ]
              ),
              const SizedBox(height: 10),
              _buildInfoButton(index),
              const SizedBox(height: 10),
              _buildExhibitsButton(exhibits: exposition.exhibits ?? [])
            ]
          )
        )
      ),
    );
  }
  Widget _buildExpostionHeader({required String label}) {
    return Text(
      label, 
      style: Theme.of(context).textTheme.titleMedium
    );
  }
  Widget _buildExpositionImage({required String imageUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        placeholder: (_, url) => _buildLoadingIndicator(),
        errorWidget: (_, url, error) => _buildErrorDisplay(),
        fit: BoxFit.cover,
        width: 150,
        height: 265,
        imageUrl: imageUrl,
      ),
    );
  }
  Widget _buildInfoButton(int index) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        title: const Text('Информация об экспозиции'),
        leading: SvgPicture.asset('assets/icons/SVG/info.svg', width: 30, height: 30),
        onTap: () {
          _infoExpRoutes[index]();
        }
      )
    );
  }
  Widget _buildExhibitsButton({required List<Exhibit> exhibits}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          WidgetConfig.containerBoxShadow
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        title: const Text('Информация об экспонатах'),
        leading: SvgPicture.asset('assets/icons/SVG/painting.svg', width: 30, height: 30),
        onTap: () {
          NavigationService().navigateToScreen(() => InfoExhibitScreen(exhibits: exhibits));
        }
      )
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