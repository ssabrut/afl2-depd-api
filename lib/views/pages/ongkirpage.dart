part of 'pages.dart';

class OngkirPage extends StatefulWidget {
  const OngkirPage({super.key});

  @override
  State<OngkirPage> createState() => _OngkirPageState();
}

class _OngkirPageState extends State<OngkirPage> {
  bool isLoading = false;
  String dropdownValue = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];
  final beratController = TextEditingController();

  dynamic originProvId;
  dynamic originProvData;
  dynamic selectedOriginProv;
  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) => {
          setState(() {
            listProvince = value;
          })
        });
    return listProvince;
  }

  dynamic originCityId;
  dynamic originCityData;
  dynamic selectedOriginCity;
  Future<List<City>> getCities(dynamic originProvId) async {
    dynamic listCity;
    await MasterDataService.getCity(originProvId).then((value) => {
          setState(() {
            listCity = value;
          })
        });
    return listCity;
  }

  dynamic destProvId;
  dynamic destProvData;
  dynamic selectedDestProv;

  dynamic destCityId;
  dynamic destCityData;
  dynamic selectedDestCity;

  @override
  void initState() {
    super.initState();
    originProvData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hitung Ongkir"),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: kurir.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? item) {
                                  setState(() {
                                    dropdownValue = item!;
                                  });
                                }),
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: beratController,
                                decoration: const InputDecoration(
                                  labelText: 'Berat (gr)',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value == null || value == 0.toString()
                                      ? 'Berat harus diisi atau tidak boleh 0'
                                      : null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      // origin
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Origin",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // origin provinces
                            Container(
                              width: 150,
                              child: FutureBuilder<List<Province>>(
                                future: originProvData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedOriginProv,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedOriginProv == null
                                            ? const Text("Pilih provinsi")
                                            : Text(selectedOriginProv.province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.province.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOriginProv = newValue;
                                            originProvId =
                                                selectedOriginProv.provinceId;
                                          });
                                          selectedOriginCity = null;
                                          originCityData =
                                              getCities(originProvId);
                                        });
                                  } else if (snapshot.hasError) {
                                    return const Text("Tidak ada data");
                                  }

                                  return UILoading.loading();
                                },
                              ),
                            ),
                            // origin city
                            Container(
                              width: 150,
                              child: FutureBuilder<List<City>>(
                                future: originCityData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedOriginCity,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedOriginCity == null
                                            ? const Text("Pilih kota")
                                            : Text(selectedOriginCity.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOriginCity = newValue;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return const Text("Tidak ada data.");
                                  }

                                  return const Text("Pilih provinsi dulu");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // destination
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Destination",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // destination provinces
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // origin provinces
                            Container(
                              width: 150,
                              child: FutureBuilder<List<Province>>(
                                future: originProvData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedDestProv,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedDestProv == null
                                            ? const Text("Pilih provinsi")
                                            : Text(selectedDestProv.province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.province.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDestProv = newValue;
                                            destProvId =
                                                selectedDestProv.provinceId;
                                          });
                                          selectedDestCity = null;
                                          destCityData = getCities(destProvId);
                                        });
                                  } else if (snapshot.hasError) {
                                    return const Text("Tidak ada data");
                                  }

                                  return UILoading.loading();
                                },
                              ),
                            ),
                            // origin city
                            Container(
                              width: 150,
                              child: FutureBuilder<List<City>>(
                                future: destCityData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedDestCity,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        hint: selectedDestCity == null
                                            ? const Text("Pilih kota")
                                            : Text(selectedDestCity.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedDestCity = newValue;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return const Text("Tidak ada data.");
                                  }

                                  return const Text("Pilih provinsi dulu");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.center, child: const Text("data")),
                )
              ],
            ),
          ),
          isLoading == true ? UILoading.loading() : Container()
        ],
      ),
    );
  }
}
