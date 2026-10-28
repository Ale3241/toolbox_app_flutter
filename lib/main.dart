import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MiAppMultiusos());
}

class MiAppMultiusos extends StatelessWidget {
  const MiAppMultiusos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tool Box App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _indiceSeleccionado = 0;

  final List<Widget> _vistas = const [
    VistaInicio(),
    VistaPrediccionGenero(),
    VistaUsuarioAleatorio(),
    VistaUniversidades(),
    VistaClima(),
    VistaPokemon(),
    VistaNoticiasWordpress(),
    VistaAcercaDe(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool Box App'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Solin Mordan'),
              accountEmail: Text('alexacosta3241@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/mi_foto.jpg'),
              ),
              decoration: BoxDecoration(color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('1. Inicio (Herramientas)'),
              onTap: () => _seleccionarVista(0),
            ),
            ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text('2. Predecir Género'),
              onTap: () => _seleccionarVista(1),
            ),
            ListTile(
              leading: const Icon(Icons.casino),
              title: const Text('3. Usuario Aleatorio'),
              onTap: () => _seleccionarVista(2),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('4. Universidades'),
              onTap: () => _seleccionarVista(3),
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('5. Clima en RD'),
              onTap: () => _seleccionarVista(4),
            ),
            ListTile(
              leading: const Icon(Icons.catching_pokemon),
              title: const Text('6. Pokémon'),
              onTap: () => _seleccionarVista(5),
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('7. Noticias WordPress'),
              onTap: () => _seleccionarVista(6),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('8. Acerca de'),
              onTap: () => _seleccionarVista(7),
            ),
          ],
        ),
      ),
      body: _vistas[_indiceSeleccionado],
    );
  }

  void _seleccionarVista(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
    Navigator.pop(context);
  }
}

// ==========================================
// 1. VISTA INICIO - CAJA DE HERRAMIENTAS
// ==========================================
class VistaInicio extends StatelessWidget {
  const VistaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido a la Caja de Herramientas!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/toolbox.png',
              height: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.build_circle,
                size: 150,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Utiliza el menú lateral para navegar entre las diferentes utilidades de la aplicación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. VISTA PREDECIR GÉNERO
// ==========================================
class VistaPrediccionGenero extends StatefulWidget {
  const VistaPrediccionGenero({super.key});

  @override
  State<VistaPrediccionGenero> createState() => _VistaPrediccionGeneroState();
}

class _VistaPrediccionGeneroState extends State<VistaPrediccionGenero> {
  final TextEditingController _controller = TextEditingController();
  String? _gender;
  bool _loading = false;

  Future<void> _predictGender() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() => _loading = true);
    final response = await http.get(
      Uri.parse('https://api.genderize.io/?name=$name'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _gender = data['gender'];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bg = _gender == 'male'
        ? Colors.blue.shade100
        : (_gender == 'female' ? Colors.pink.shade100 : Colors.white);

    return Container(
      color: bg,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Predecir Género por Nombre',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Ingresa un nombre',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _predictGender,
            child: const Text('Predecir'),
          ),
          const SizedBox(height: 20),
          if (_loading) const CircularProgressIndicator(),
          if (_gender != null && !_loading)
            Text(
              'Resultado: ${_gender == 'male' ? 'Masculino ♂' : 'Femenino ♀'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _gender == 'male' ? Colors.blue : Colors.pink,
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. VISTA USUARIO ALEATORIO
// ==========================================
class VistaUsuarioAleatorio extends StatefulWidget {
  const VistaUsuarioAleatorio({super.key});

  @override
  State<VistaUsuarioAleatorio> createState() => _VistaUsuarioAleatorioState();
}

class _VistaUsuarioAleatorioState extends State<VistaUsuarioAleatorio> {
  Map<String, dynamic>? _userData;
  bool _loading = false;

  Future<void> _fetchUser() async {
    setState(() => _loading = true);
    final response = await http.get(
      Uri.parse('https://randomuser.me/api/?results=1'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _userData = data['results'][0];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading
          ? const CircularProgressIndicator()
          : _userData == null
              ? ElevatedButton(
                  onPressed: _fetchUser,
                  child: const Text('Cargar Usuario'),
                )
              : Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            _userData!['picture']['large'],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${_userData!['name']['first']} ${_userData!['name']['last']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Fecha Nacimiento: ${_userData!['dob']['date'].toString().substring(0, 10)}',
                        ),
                        Text('Edad: ${_userData!['dob']['age']} años'),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _fetchUser,
                          child: const Text('Generar Otro'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

// ==========================================
// 4. VISTA UNIVERSIDADES
// ==========================================
class VistaUniversidades extends StatefulWidget {
  const VistaUniversidades({super.key});

  @override
  State<VistaUniversidades> createState() => _VistaUniversidadesState();
}

class _VistaUniversidadesState extends State<VistaUniversidades> {
  final TextEditingController _controller = TextEditingController();
  List _universities = [];
  bool _loading = false;

  Future<void> _fetchUniversities() async {
    final country = _controller.text.trim();
    if (country.isEmpty) return;

    setState(() => _loading = true);
    final response = await http.get(
      Uri.parse('https://adamix.net/proxy.php?country=$country'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _universities = json.decode(response.body);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'País en inglés (Ej: Dominican Republic)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchUniversities,
            child: const Text('Buscar Universidades'),
          ),
          const SizedBox(height: 10),
          if (_loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _universities.length,
              itemBuilder: (context, index) {
                final uni = _universities[index];
                final webPage = (uni['web_pages'] as List).isNotEmpty
                    ? uni['web_pages'][0]
                    : '';
                return Card(
                  child: ListTile(
                    title: Text(uni['name'] ?? ''),
                    subtitle: Text('Dominio: ${uni['domains']?.join(", ")}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => _launchURL(webPage),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No se pudo abrir $urlString')));
    }
  }
}

// ==========================================
// 5. VISTA CLIMA EN RD (CON DESCRIPCIÓN E ICONO)
// ==========================================
class VistaClima extends StatefulWidget {
  const VistaClima({super.key});

  @override
  State<VistaClima> createState() => _VistaClimaState();
}

class _VistaClimaState extends State<VistaClima> {
  Map<String, dynamic>? _weatherData;
  bool _loading = false;

  Future<void> _fetchWeather() async {
    setState(() => _loading = true);
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312&current_weather=true';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherData = data['current_weather'];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Map<String, dynamic> _getWeatherCondition(int code) {
    switch (code) {
      case 0:
        return {
          'text': 'Despejado / Soleado ☀️',
          'icon': Icons.wb_sunny,
          'color': Colors.orange
        };
      case 1:
      case 2:
        return {
          'text': 'Parcialmente Nublado ⛅',
          'icon': Icons.cloud_queue,
          'color': Colors.amber
        };
      case 3:
        return {
          'text': 'Nublado ☁️',
          'icon': Icons.cloud,
          'color': Colors.blueGrey
        };
      case 45:
      case 48:
        return {
          'text': 'Niebla 🌫️',
          'icon': Icons.blur_on,
          'color': Colors.grey
        };
      case 51:
      case 53:
      case 55:
        return {
          'text': 'Llovizna 🌧️',
          'icon': Icons.grain,
          'color': Colors.lightBlue
        };
      case 61:
      case 63:
      case 65:
        return {
          'text': 'Lluvia 🌧️',
          'icon': Icons.umbrella,
          'color': Colors.blue
        };
      case 80:
      case 81:
      case 82:
        return {
          'text': 'Chubascos / Aguaceros 🌦️',
          'icon': Icons.water_drop,
          'color': Colors.blueAccent
        };
      case 95:
      case 96:
      case 99:
        return {
          'text': 'Tormenta Eléctrica ⛈️',
          'icon': Icons.thunderstorm,
          'color': Colors.deepPurple
        };
      default:
        return {
          'text': 'Clima Variable 🌤️',
          'icon': Icons.wb_cloudy,
          'color': Colors.indigo
        };
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_weatherData == null) {
      return const Center(child: Text('Error al obtener el clima'));
    }

    final int code = _weatherData!['weathercode'] ?? 0;
    final condition = _getWeatherCondition(code);

    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                condition['icon'] as IconData,
                size: 80,
                color: condition['color'] as Color,
              ),
              const SizedBox(height: 10),
              const Text(
                'Santo Domingo, RD',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                condition['text'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: condition['color'] as Color,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Temperatura: ${_weatherData!['temperature']} °C',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                'Viento: ${_weatherData!['windspeed']} km/h',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. VISTA POKÉMON (CORREGIDA)
// ==========================================
class VistaPokemon extends StatefulWidget {
  const VistaPokemon({super.key});

  @override
  State<VistaPokemon> createState() => _VistaPokemonState();
}

class _VistaPokemonState extends State<VistaPokemon> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _pokemon;
  bool _loading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _fetchPokemon() async {
    final name = _controller.text.trim().toLowerCase();
    if (name.isEmpty) return;

    setState(() => _loading = true);
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));

    if (response.statusCode == 200) {
      setState(() {
        _pokemon = json.decode(response.body);
        _loading = false;
      });
    } else {
      setState(() {
        _pokemon = null;
        _loading = false;
      });
    }
  }

  void _playSound(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Nombre del Pokémon (Ej: pikachu)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchPokemon,
            child: const Text('Buscar Pokémon'),
          ),
          const SizedBox(height: 10),
          if (_loading) const CircularProgressIndicator(),
          if (_pokemon != null && !_loading) ...[
            Image.network(_pokemon!['sprites']['front_default'], height: 150),
            Text(
              _pokemon!['name'].toString().toUpperCase(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('Experiencia Base: ${_pokemon!['base_experience']}'),
            const SizedBox(height: 10),
            const Text('Habilidades:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...(_pokemon!['abilities'] as List)
                .map((a) => Text(a['ability']['name'])),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text('Reproducir Sonido'),
              onPressed: () {
                final soundUrl = _pokemon!['cries']['latest'];
                if (soundUrl != null) _playSound(soundUrl);
              },
            )
          ]
        ],
      ),
    );
  }
}

// ==========================================
// 7. VISTA NOTICIAS WORDPRESS
// ==========================================
class VistaNoticiasWordpress extends StatefulWidget {
  const VistaNoticiasWordpress({super.key});

  @override
  State<VistaNoticiasWordpress> createState() => _VistaNoticiasWordpressState();
}

class _VistaNoticiasWordpressState extends State<VistaNoticiasWordpress> {
  List _posts = [];
  bool _loading = false;

  Future<void> _fetchPosts() async {
    setState(() => _loading = true);
    // API de TechCrunch (WordPress REST API)
    final response = await http.get(
      Uri.parse('https://techcrunch.com/wp-json/wp/v2/posts?per_page=3'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _posts = json.decode(response.body);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.network(
            'https://techcrunch.com/wp-content/uploads/2015/02/cropped-cropped-techcrunch-logo.png',
            height: 60,
            errorBuilder: (context, error, stackTrace) => const Text(
              'TechCrunch News',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          if (_loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                final title = post['title']['rendered'];
                final excerpt = post['excerpt']['rendered'].replaceAll(
                  RegExp(r'<[^>]*>'),
                  '',
                );
                final link = post['link'];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          excerpt,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: const Text('Visitar Noticia'),
                            onPressed: () => launchUrl(
                              Uri.parse(link),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 8. VISTA ACERCA DE (NOMBRE CENTRADO)
// ==========================================
class VistaAcercaDe extends StatelessWidget {
  const VistaAcercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/mi_foto.jpg'),
              ),
              const SizedBox(height: 15),
              const Text(
                'Solin Alexander Mordan Acosta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'Desarrollador de Software',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              const ListTile(
                leading: Icon(Icons.email),
                title: Text('alexacosta3241@gmail.com'),
              ),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1 (939) 732-1796'),
              ),
              const ListTile(
                leading: Icon(Icons.work),
                title: Text(
                    'Disponible para contrataciones e itinerarios de trabajo.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
