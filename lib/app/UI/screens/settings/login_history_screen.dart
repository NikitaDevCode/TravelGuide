import '/libraries/controllers.dart';
import '/libraries/services.dart';
import '/libraries/custom_packages.dart';
import '/libraries/widgets.dart';
import '/libraries/api.dart';
import '/libraries/models.dart';
import '/libraries/system_packages.dart';

class LoginHistoryScreen extends StatefulWidget {
  const LoginHistoryScreen({super.key});

  @override
  State<LoginHistoryScreen> createState() => _LoginHistoryScreenState();
}

class _LoginHistoryScreenState extends State<LoginHistoryScreen> {
  final _loadingStateController = Get.find<LoadingStateController>();
  String _currentDeviceUniqueId = '';
  void _getCurrentDeviceUnique() async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    _currentDeviceUniqueId = deviceInfo['uniqueId']; 
  }
  late Future<List<Device>> _devicesData;
  @override
  void initState() {
    super.initState();
    _devicesData = ApiSecurity().getDevices();
    _getCurrentDeviceUnique();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История сеансов')),
      body: FutureBuilder<List<Device>>(
        future: _devicesData,
        builder: (_, snap) => snap.connectionState == ConnectionState.waiting ? _buildLoadingIndicator(
        ) : snap.hasData ? _buildDevicesist(
          devices: snap.data!
        ) : _buildErrorDisplay(),
      )
    );
  }
  Widget _buildDevicesist({required List<Device> devices}) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (_, i) => _buildDeviceContainer(devices[i])
          )
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            return CustomButton(
              onPressed: _loadingStateController.isLoadingState ? null : () async {
                _loadingStateController.changeLoadingState();
                await ApiSecurity().logoutAll();
                _loadingStateController.changeLoadingState();
              }, 
              widget: _loadingStateController.isLoadingState ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.white
                )
              ) : Text('Выйти на всех устройствах', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white
              ))
            );
          })
        )
      ]
    );
  }
  Widget _buildDeviceContainer(Device device) {
    final isLoggedOut = device.lastLogoutAt != null && device.lastLogoutAt!.isAfter(device.lastLoginAt);
    final isActiveDevice = device.uniqueId == _currentDeviceUniqueId;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/SVG/phone.svg', width: 50, height: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Тип: ${device.deviceType}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Модель: ${device.model}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ОС: ${device.osVersion}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Последний вход',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(device.lastLoginAt),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  isActiveDevice ? Row(
                    children: [
                      
                      const Icon(
                        Icons.check_circle, 
                        color: Colors.green
                      ),
                      const SizedBox(width: 6),
                      Text('Активное устройство', style: Theme.of(context).textTheme.bodyMedium),
                    ]
                  ) : (isLoggedOut ? const Text(
                    'Выход выполнен', 
                    style: TextStyle(
                      color: Colors.red
                    )
                  ) : const Text(
                    'Активно')
                  ),
                  if (!isActiveDevice)
                  const SizedBox(height: 10),
                  if (!isActiveDevice && !isLoggedOut)
                  Obx(() {
                    return CustomButton(
                      onPressed: _loadingStateController.isLoadingState ? null : () async {
                        await _logoutDevice(device);
                      }, 
                      widget: _loadingStateController.isLoadingState ? const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.white
                        )
                      ) : Text('Выход', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white
                      ))
                    );
                  })
                ]
              )
            )
          ]
        )
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
  Future<void> _logoutDevice(Device device) async {
    _loadingStateController.changeLoadingState();
    final response = await ApiSecurity().logoutDevice(
      uniqueId: device.uniqueId,
    );
    if (response.success) {
      _devicesData = ApiSecurity().getDevices();
      setState(() {});
    }
    _loadingStateController.changeLoadingState();
  }
}