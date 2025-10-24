import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/dashboards/build_map_marker.dart';
import 'package:fourtyninehub/helpers/marker_generator.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// --- Data Models ---
class Person {
  final String name;
  final String gender;
  final double lat;
  final double lng;
  final String vehicleType;
  final List<List<double>>? _polyline; // nullable for safety
  final bool isAvailable;

  Person({
    required this.name,
    required this.gender,
    required this.lat,
    required this.lng,
    required List<List<double>>? polyline,
    required this.vehicleType,
    this.isAvailable = true,
  }) : _polyline = polyline;

  /// Always return a valid list (never null)
  List<List<double>> get polyline => _polyline ?? [];
}

final List<Person> courierPeople = [
  Person(name: 'Ahmed',
      polyline:[[31.67768, 31.28032], [31.67784, 31.2803], [31.67799, 31.28031], [31.67818, 31.2804], [31.6783, 31.28038], [31.67831, 31.28053], [31.67893, 31.28002], [31.67949, 31.27964], [31.67989, 31.27932], [31.68061, 31.27887], [31.68112, 31.27853], [31.68138, 31.27839], [31.68152, 31.27834], [31.68289, 31.27767], [31.68336, 31.27751], [31.68409, 31.27732], [31.6842, 31.2773], [31.6841, 31.27705], [31.68462, 31.27684], [31.68505, 31.27663], [31.68524, 31.27658], [31.68634, 31.27611], [31.68682, 31.27587], [31.68791, 31.27548], [31.68818, 31.2753], [31.68829, 31.27524], [31.68832, 31.27521], [31.68837, 31.27504], [31.68841, 31.27495], [31.68856, 31.2748], [31.68905, 31.2746], [31.68941, 31.27441], [31.68959, 31.27429], [31.68976, 31.27422], [31.68992, 31.27419], [31.6904, 31.2739], [31.69032, 31.27378], [31.69024, 31.2737], [31.69003, 31.27358], [31.68968, 31.27329], [31.68864, 31.27227], [31.68832, 31.27175], [31.68811, 31.27128], [31.68791, 31.2707], [31.68776, 31.26987], [31.68769, 31.26929], [31.68757, 31.26848], [31.68749, 31.26782], [31.68753, 31.26744], [31.68764, 31.26698], [31.6877, 31.26678], [31.68726, 31.26663], [31.68646, 31.2664], [31.68625, 31.26637], [31.68573, 31.26637], [31.68549, 31.2664], [31.68525, 31.26639], [31.68507, 31.26641], [31.68464, 31.26631], [31.68388, 31.26609], [31.68405, 31.26563]],

      gender: 'Male', lat: 31.285818049110347, lng: 31.6686781054431, vehicleType: 'Car'),
  Person(name: 'Sara',
      polyline: [[31.66214, 31.2783], [31.66201, 31.2785], [31.66149, 31.27911], [31.661, 31.27979], [31.66078, 31.28], [31.66023, 31.28039], [31.65995, 31.28054], [31.65957, 31.2807], [31.65915, 31.28068], [31.65895, 31.28079], [31.65883, 31.28076], [31.65855, 31.28066], [31.6587, 31.28018], [31.65883, 31.27995], [31.65911, 31.27952], [31.66017, 31.27819], [31.66147, 31.27667], [31.66283, 31.27518], [31.66319, 31.27487], [31.6642, 31.27418], [31.66447, 31.27403], [31.66483, 31.27388], [31.66564, 31.27362], [31.66643, 31.27345], [31.66745, 31.27328], [31.66876, 31.27307], [31.67086, 31.27267], [31.67263, 31.27236], [31.67354, 31.27216], [31.67425, 31.27194], [31.67512, 31.27164], [31.67725, 31.27076], [31.67745, 31.27067], [31.67795, 31.27037], [31.67838, 31.27006], [31.67855, 31.26992], [31.67945, 31.26892], [31.68025, 31.26777], [31.6805, 31.2673], [31.68068, 31.2666], [31.68072, 31.26611], [31.68069, 31.26552], [31.68088, 31.26553], [31.68092, 31.26558], [31.68093, 31.26573], [31.68127, 31.26571], [31.68136, 31.26558], [31.68175, 31.26556], [31.68199, 31.26557], [31.68216, 31.26553], [31.68239, 31.26554], [31.68247, 31.26552], [31.68272, 31.26563], [31.68294, 31.26574], [31.68369, 31.26603], [31.68386, 31.26558]],
      gender: 'Female', lat: 31.274352176106316, lng: 31.688569365707956, vehicleType: 'Motorcycle'),
  Person(name: 'Omar',
      polyline: [[31.66214, 31.2783], [31.66201, 31.2785], [31.66149, 31.27911], [31.661, 31.27979], [31.66078, 31.28], [31.66023, 31.28039], [31.65995, 31.28054], [31.65957, 31.2807], [31.65915, 31.28068], [31.65895, 31.28079], [31.65883, 31.28076], [31.65855, 31.28066], [31.6587, 31.28018], [31.65883, 31.27995], [31.65911, 31.27952], [31.66017, 31.27819], [31.66147, 31.27667], [31.66283, 31.27518], [31.66319, 31.27487], [31.6642, 31.27418], [31.66447, 31.27403], [31.66483, 31.27388], [31.66564, 31.27362], [31.66643, 31.27345], [31.66745, 31.27328], [31.66876, 31.27307], [31.67086, 31.27267], [31.67263, 31.27236], [31.67354, 31.27216], [31.67425, 31.27194], [31.67512, 31.27164], [31.67725, 31.27076], [31.67745, 31.27067], [31.67795, 31.27037], [31.67838, 31.27006], [31.67855, 31.26992], [31.67945, 31.26892], [31.68025, 31.26777], [31.6805, 31.2673], [31.68068, 31.2666], [31.68072, 31.26611], [31.68068, 31.26536], [31.68066, 31.26524], [31.68092, 31.26516], [31.68129, 31.26501], [31.68142, 31.26493], [31.68154, 31.26479], [31.6816, 31.26471], [31.68171, 31.26461], [31.68206, 31.26446], [31.68227, 31.26441], [31.68241, 31.26442], [31.68282, 31.26462], [31.68319, 31.26475], [31.68358, 31.26486], [31.68487, 31.26516], [31.68537, 31.26524], [31.68641, 31.26533], [31.68774, 31.2655], [31.68847, 31.26565], [31.68812, 31.26692], [31.68796, 31.26766], [31.68795, 31.26812], [31.68813, 31.26967], [31.68828, 31.27051], [31.68845, 31.27101], [31.68858, 31.27131], [31.68887, 31.27188], [31.68915, 31.27223], [31.68965, 31.2727], [31.69358, 31.27628], [31.69397, 31.27659], [31.69472, 31.27712], [31.69494, 31.27735], [31.69506, 31.27759], [31.69521, 31.27814], [31.696, 31.28193], [31.69613, 31.28244], [31.69638, 31.28322], [31.69706, 31.2851], [31.69873, 31.28982], [31.69881, 31.29015], [31.69894, 31.29138], [31.69915, 31.29237], [31.69954, 31.29403], [31.69961, 31.29427], [31.69972, 31.29455], [31.70023, 31.29549], [31.7017, 31.29812], [31.70239, 31.29916], [31.70327, 31.30042], [31.70433, 31.30182], [31.70448, 31.30202], [31.70469, 31.30241], [31.70525, 31.30368], [31.70557, 31.30446], [31.70607, 31.30588], [31.7063, 31.30647], [31.70737, 31.30885], [31.70747, 31.30905], [31.70838, 31.31128], [31.70892, 31.31236], [31.70916, 31.31291], [31.70932, 31.31322], [31.70958, 31.31388], [31.70991, 31.3146], [31.71024, 31.31529], [31.71097, 31.31628], [31.71189, 31.31753], [31.7122, 31.31795], [31.71257, 31.31832], [31.71286, 31.31859], [31.71347, 31.31906], [31.71359, 31.31922], [31.71357, 31.3193], [31.71348, 31.31947], [31.7134, 31.3195], [31.71312, 31.31954], [31.71303, 31.31958], [31.71263, 31.31979], [31.70972, 31.32169], [31.70843, 31.32258], [31.70382, 31.32561], [31.70203, 31.32674], [31.70197, 31.3268], [31.70173, 31.32692], [31.70069, 31.32762], [31.70058, 31.3277], [31.69973, 31.32824], [31.69799, 31.32941], [31.69533, 31.33117], [31.69456, 31.33167], [31.69117, 31.33391], [31.68684, 31.33676], [31.68173, 31.33992], [31.67883, 31.3417], [31.67854, 31.34189], [31.67842, 31.34195], [31.67737, 31.34258], [31.67713, 31.34276], [31.67701, 31.34293], [31.67695, 31.34312], [31.67698, 31.34331], [31.67707, 31.34347], [31.67722, 31.3436], [31.67739, 31.34367], [31.67758, 31.34369], [31.67779, 31.34366], [31.67798, 31.34356], [31.67813, 31.34341], [31.6782, 31.34322], [31.67818, 31.34307], [31.67801, 31.3428], [31.67679, 31.34156], [31.67632, 31.34106], [31.67573, 31.34047], [31.6736, 31.33827], [31.67295, 31.33759], [31.67028, 31.33487], [31.66906, 31.3336], [31.66669, 31.33113], [31.6627, 31.32703], [31.66008, 31.32427], [31.65816, 31.32234], [31.65805, 31.32219], [31.65616, 31.32019], [31.65461, 31.31826], [31.65428, 31.31787], [31.65205, 31.31515], [31.65142, 31.31439], [31.64888, 31.3113], [31.64697, 31.30893], [31.64443, 31.30585], [31.64362, 31.30484], [31.64161, 31.30242], [31.63975, 31.30017], [31.63891, 31.29911], [31.63591, 31.29546], [31.63467, 31.29397], [31.63397, 31.2931], [31.63381, 31.29288], [31.63313, 31.29209], [31.63025, 31.28854], [31.62862, 31.28659], [31.62738, 31.28503], [31.62685, 31.2844], [31.62644, 31.28387], [31.62276, 31.27942], [31.62182, 31.27827], [31.62035, 31.27649], [31.62045, 31.27643], [31.62299, 31.27951], [31.62321, 31.27974], [31.62382, 31.27939], [31.62369, 31.2793], [31.62353, 31.27908], [31.62353, 31.279], [31.62441, 31.27721], [31.62802, 31.27016], [31.62895, 31.2683], [31.62908, 31.26808], [31.62924, 31.26788], [31.63133, 31.26583], [31.6318, 31.26538], [31.6321, 31.26514], [31.63358, 31.26368], [31.63442, 31.26289], [31.63921, 31.2582], [31.64145, 31.25594], [31.64215, 31.25525], [31.64303, 31.25445], [31.64434, 31.25316], [31.64508, 31.25242], [31.64792, 31.24972], [31.64825, 31.24939], [31.64842, 31.24916], [31.65106, 31.25018], [31.65318, 31.25097], [31.65428, 31.2514], [31.6544, 31.25121], [31.65515, 31.25151], [31.65803, 31.2526], [31.65896, 31.25297]],
      gender: 'Male', lat: 31.302664399477298, lng: 31.647542300307304, vehicleType: 'Bicycle'),
  Person(name: 'Mona',
      polyline: [[31.63999, 31.26974], [31.63939, 31.27006], [31.63899, 31.27021], [31.63858, 31.27045], [31.63829, 31.27056], [31.63753, 31.27093], [31.63734, 31.27105], [31.63726, 31.27114], [31.63723, 31.27106], [31.63708, 31.27086], [31.63717, 31.27079], [31.6372, 31.27074], [31.63763, 31.26805], [31.63778, 31.26675], [31.63777, 31.26664], [31.63756, 31.26536], [31.63757, 31.26515], [31.63752, 31.26482], [31.63743, 31.26461], [31.63523, 31.26211], [31.63921, 31.2582], [31.64145, 31.25594], [31.64215, 31.25525], [31.64303, 31.25445], [31.64434, 31.25316], [31.64508, 31.25242], [31.64792, 31.24972], [31.64825, 31.24939], [31.64842, 31.24916], [31.65106, 31.25018], [31.65318, 31.25097], [31.65428, 31.2514], [31.6544, 31.25121], [31.65515, 31.25151], [31.65803, 31.2526], [31.65896, 31.25297]],
      gender: 'Female', lat: 31.30295774631812, lng: 31.72650652772886, vehicleType: 'Car'),
  Person(name: 'Ali',
      polyline: [[31.61219, 31.25499], [31.61221, 31.25458], [31.61241, 31.25357], [31.6125, 31.25332], [31.61482, 31.24961], [31.61575, 31.24816], [31.61628, 31.2473], [31.61663, 31.24677], [31.61748, 31.24728], [31.61783, 31.24752], [31.61818, 31.24784], [31.61833, 31.24801], [31.61862, 31.24848], [31.61904, 31.24905], [31.6192, 31.24919], [31.61943, 31.24931], [31.61972, 31.24939], [31.61997, 31.24941], [31.62109, 31.2492], [31.62345, 31.24869], [31.62443, 31.24845], [31.62677, 31.24796], [31.62707, 31.2479], [31.62844, 31.24758], [31.63016, 31.24719], [31.63309, 31.24652], [31.63429, 31.24624], [31.63449, 31.24621], [31.63475, 31.2462], [31.63761, 31.2465], [31.64069, 31.24682], [31.64109, 31.24686], [31.64116, 31.24685], [31.64218, 31.24697], [31.64297, 31.24708], [31.64322, 31.24714], [31.6438, 31.24736], [31.64543, 31.248], [31.64689, 31.24856], [31.6509, 31.25012], [31.65318, 31.25097], [31.65428, 31.2514], [31.6544, 31.25121], [31.65515, 31.25151], [31.65803, 31.2526], [31.65896, 31.25297]],
      gender: 'Male', lat: 31.249113394030847, lng: 31.64445239309742, vehicleType: 'Motorcycle'),
];
// --- Main Widget ---
class TrackingAvailableTrips extends StatefulWidget {
  const TrackingAvailableTrips({super.key});

  @override
  State<TrackingAvailableTrips> createState() => _TrackingAvailableTripsState();
}

class _TrackingAvailableTripsState extends State<TrackingAvailableTrips> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  CameraPosition? _initialCameraPosition;

  bool _isLoading = true;
  List<Person> _filteredPeople = [];
  Person? _selectedPerson;

  static const String _manIconPath = 'assets/icons/man.png';
  static const String _womanIconPath = 'assets/icons/woman.png';

  @override
  void initState() {
    super.initState();
    Future.microtask(_initializeMap);
  }

  Future<void> _preCacheAvatars(BuildContext context) async {
    await Future.wait([
      precacheImage(const AssetImage(_manIconPath), context),
      precacheImage(const AssetImage(_womanIconPath), context),
    ]);
  }

  Future<void> _initializeMap() async {
    _filteredPeople = List.from(courierPeople);

    if (_filteredPeople.isEmpty) {
      _initialCameraPosition = const CameraPosition(
        target: LatLng(31.3, 31.7),
        zoom: 12.0,
      );
    } else {
      _initialCameraPosition = CameraPosition(
        target: LatLng(_filteredPeople.first.lat, _filteredPeople.first.lng),
        zoom: 12.0,
      );
      _selectedPerson = _filteredPeople.first;
    }

    await _preCacheAvatars(context);
    _setMarkerWidgets();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  LatLngBounds _calculateBounds(List<Person> people) {
    if (people.isEmpty) {
      return LatLngBounds(
        southwest: LatLng(30.0, 30.0),
        northeast: LatLng(32.0, 33.0),
      );
    }

    double minLat = people.map((p) => p.lat).reduce(min);
    double maxLat = people.map((p) => p.lat).reduce(max);
    double minLng = people.map((p) => p.lng).reduce(min);
    double maxLng = people.map((p) => p.lng).reduce(max);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _fitBounds(LatLngBounds bounds) async {
    if (!_controller.isCompleted) return;
    final GoogleMapController controller = await _controller.future;
    const double padding = 50.0;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  void _createPolyline(Person person) async {
    if (person.polyline.isEmpty) {
      setState(() => _polylines = {});
      return;
    }

    // ✅ Use correct coordinate order (LatLng(lat, lng))
    final List<LatLng> points =
    person.polyline.map((p) => LatLng(p[1], p[0])).toList();

    final polyline = Polyline(
      polylineId: PolylineId('route_${person.name}'),
      points: points,
      color: AppColors.SECONDARY_COLOR,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    setState(() {
      _polylines = {polyline};
    });

    // Fit camera to the route
    double minLat = points.map((p) => p.latitude).reduce(min);
    double maxLat = points.map((p) => p.latitude).reduce(max);
    double minLng = points.map((p) => p.longitude).reduce(min);
    double maxLng = points.map((p) => p.longitude).reduce(max);

    _fitBounds(
      LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      ),
    );
  }

  List<Marker> mapBitmapsToMarkers(
      List<Uint8List> bitmaps, List<Person> couriersList) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final Person model = couriersList[i];
      markersList.add(Marker(
        markerId: MarkerId("${model.lat}_${model.lng}_${model.name}"),
        position: LatLng(model.lat, model.lng),
        icon: BitmapDescriptor.fromBytes(bmp),
        onTap: () => _selectCourier(model),
      ));
    });
    return markersList;
  }

  Future<void> _setMarkerWidgets() async {
    if (_filteredPeople.isEmpty) {
      setState(() {
        _markers = {};
        _polylines = {};
        _isLoading = false;
      });
      _fitBounds(_calculateBounds([]));
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));

    MarkerGenerator(markerWidgets(_filteredPeople), (bitmaps) {
      final markersList = mapBitmapsToMarkers(bitmaps, _filteredPeople);
      final bounds = _calculateBounds(_filteredPeople);

      if (mounted) {
        setState(() {
          _markers = markersList.toSet();
          _isLoading = false;
        });

        if (_selectedPerson != null) {
          _createPolyline(_selectedPerson!);
        }

        _fitBounds(bounds);
      }
    }).generate(context);
  }

  List<Widget> markerWidgets(List<Person> courierList) {
    return courierList.map((c) => _getMarkerWidget(c)).toList();
  }

  Widget _getMarkerWidget(Person person) {
    return BuildMapMarker(
      model: person,
      manIconPath: _manIconPath,
      womanIconPath: _womanIconPath,
    );
  }

  void _selectCourier(Person person) {
    setState(() => _selectedPerson = person);
    _createPolyline(person);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${person.name} (${person.vehicleType})'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_initialCameraPosition == null)
            const Center(child: CustomCircularProgressIndicator())
          else
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition!,
              onMapCreated: _onMapCreated,
              markers: _markers,
              // polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              mapToolbarEnabled: true,
            ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
