# TP — CRUD Simulé avec Flutter : Gestion de la liste d'amis

> **Projet support :** `myfriends`
> **Niveau :** Intermédiaire — après widgets, navigation, routes, Drawer, StatefulWidget
> **Durée estimée :** 3 à 4 heures

---

## Objectifs pédagogiques

À l'issue de ce TP, l'étudiant sera capable de :

- Modéliser une donnée métier avec une **classe Dart**
- Créer un **jeu de données simulé** (liste en mémoire)
- Afficher une liste dynamique avec **ListView.builder**
- Naviguer vers un écran de **détail** en passant des arguments
- Créer un formulaire **TextField** pour **ajouter** et **modifier** une fiche
- Implémenter la **suppression** avec une boîte de dialogue de confirmation
- Gérer l'état global de la liste avec **setState** dans un StatefulWidget

---

## Prérequis — Ce que vous avez déjà vu

| Notion | Utilisée dans ce TP |
|---|---|
| `StatelessWidget` / `StatefulWidget` | Structure de chaque écran |
| `TextField` + `TextEditingController` | Formulaires ajout / modification |
| `Navigator.push` / `pop` | Navigation entre écrans |
| Routes nommées | Accès via le Drawer |
| `Drawer` + `ListTile` | Menu de navigation |
| `setState()` | Mise à jour de la liste |
| `Scaffold`, `AppBar`, `Column`, `Card` | Mise en page |

---

## Architecture du projet

```
lib/
├── data/
│   └── friends_data.dart       ← jeu de données + modèle Friend
├── screens/
│   ├── liste_amis_screen.dart  ← liste (Read)
│   ├── details_ami_screen.dart ← détail (Read)
│   ├── ajouter_ami_screen.dart ← formulaire ajout (Create)
│   └── modifier_ami_screen.dart← formulaire modification (Update)
├── widgets/
│   ├── drawer.dart
│   └── friend_card.dart        ← carte ami réutilisable
└── main.dart
```

---

## Étape 1 — Modéliser la donnée : la classe `Friend`

Avant de coder les écrans, il faut définir **ce qu'est un ami** dans notre application.

### Concept clé : la classe modèle

Une classe modèle représente une entité métier. Elle regroupe ses attributs et peut fournir des méthodes utilitaires (`copyWith`, `toString`…).

### Fichier : `lib/data/friends_data.dart`

```dart
// ── Modèle ──────────────────────────────────────────────────────────────────

class Friend {
  final int id;
  String nom;
  String prenom;
  String telephone;
  String email;
  bool isBestFriend;

  Friend({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    this.isBestFriend = false,
  });

  // Crée une copie de l'objet avec certains champs modifiés
  Friend copyWith({
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
    bool? isBestFriend,
  }) {
    return Friend(
      id: id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      isBestFriend: isBestFriend ?? this.isBestFriend,
    );
  }
}

// ── Jeu de données simulé ───────────────────────────────────────────────────

List<Friend> friendsData = [
  Friend(
    id: 1,
    nom: 'Dupont',
    prenom: 'Alice',
    telephone: '0601020304',
    email: 'alice.dupont@mail.com',
    isBestFriend: true,
  ),
  Friend(
    id: 2,
    nom: 'Martin',
    prenom: 'Bob',
    telephone: '0611223344',
    email: 'bob.martin@mail.com',
  ),
  Friend(
    id: 3,
    nom: 'Leroy',
    prenom: 'Carla',
    telephone: '0622334455',
    email: 'carla.leroy@mail.com',
    isBestFriend: true,
  ),
  Friend(
    id: 4,
    nom: 'Petit',
    prenom: 'Dylan',
    telephone: '0633445566',
    email: 'dylan.petit@mail.com',
  ),
  Friend(
    id: 5,
    nom: 'Moreau',
    prenom: 'Emma',
    telephone: '0644556677',
    email: 'emma.moreau@mail.com',
  ),
];
```

> **Points à retenir**
> - `final int id` : l'identifiant ne change jamais, on le déclare `final`.
> - Les autres champs sont mutables (pas de `final`) car on pourra les modifier.
> - `copyWith` est un pattern courant en Flutter : il évite de modifier l'objet directement et retourne une nouvelle instance avec les valeurs mises à jour.

---

## Étape 2 — La liste des amis (Read / List)

### Concept clé : `ListView.builder`

`ListView.builder` construit les éléments **à la demande** : seuls les éléments visibles sont rendus. C'est la bonne pratique pour les listes longues.

### Fichier : `lib/screens/liste_amis_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:myfriends/data/friends_data.dart';
import 'package:myfriends/main.dart';
import 'package:myfriends/widgets/drawer.dart';

class ListeAmisScreen extends StatefulWidget {
  const ListeAmisScreen({super.key});

  @override
  State<ListeAmisScreen> createState() => _ListeAmisScreenState();
}

class _ListeAmisScreenState extends State<ListeAmisScreen> {
  // On travaille sur une copie locale de la liste globale
  List<Friend> _amis = List.from(friendsData);

  void _supprimerAmi(Friend ami) async {
    // Boîte de dialogue de confirmation (voir Étape 5)
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer ${ami.prenom} ${ami.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _amis.removeWhere((a) => a.id == ami.id);
        friendsData.removeWhere((a) => a.id == ami.id);
      });
    }
  }

  void _ajouterAmi() async {
    // On navigue vers le formulaire et on attend le retour
    final nouvelAmi = await Navigator.pushNamed(context, '/ajouter_ami');
    if (nouvelAmi != null && nouvelAmi is Friend) {
      setState(() {
        _amis.add(nouvelAmi);
      });
    }
  }

  void _modifierAmi(Friend ami) async {
    final amiModifie = await Navigator.pushNamed(
      context,
      '/modifier_ami',
      arguments: ami,
    );
    if (amiModifie != null && amiModifie is Friend) {
      setState(() {
        final index = _amis.indexWhere((a) => a.id == amiModifie.id);
        if (index != -1) _amis[index] = amiModifie;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Amis'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text('${_amis.length}',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: AppColors.teal,
            ),
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterAmi,
        backgroundColor: AppColors.pink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _amis.isEmpty
          ? const Center(child: Text('Aucun ami pour le moment.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _amis.length,
              itemBuilder: (context, index) {
                final ami = _amis[index];
                return _buildAmiCard(ami);
              },
            ),
    );
  }

  Widget _buildAmiCard(Friend ami) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ami.isBestFriend ? AppColors.pink : AppColors.teal,
          child: Text(
            ami.prenom[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('${ami.prenom} ${ami.nom}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(ami.telephone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ami.isBestFriend)
              const Icon(Icons.star, color: Colors.amber, size: 18),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _modifierAmi(ami),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _supprimerAmi(ami),
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, '/detail_ami', arguments: ami),
      ),
    );
  }
}
```

> **Points à retenir**
> - `StatefulWidget` car la liste peut changer (ajout, suppression, modification).
> - `List.from(friendsData)` : on copie la liste pour ne pas modifier directement la source.
> - `await Navigator.pushNamed(...)` : on attend le **résultat retourné** par l'écran suivant grâce à `pop(result)`.
> - `FloatingActionButton` : le bouton "+" en bas à droite, idiomatique Flutter pour l'ajout.

---

## Étape 3 — Le détail d'un ami (Read / Detail)

### Concept clé : passer des arguments à une route

Avec les routes nommées, on passe des données via `arguments` et on les récupère avec `ModalRoute.of(context)!.settings.arguments`.

### Fichier : `lib/screens/details_ami_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:myfriends/data/friends_data.dart';
import 'package:myfriends/main.dart';

class DetailsAmiScreen extends StatelessWidget {
  const DetailsAmiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ami = ModalRoute.of(context)!.settings.arguments as Friend;

    return Scaffold(
      appBar: AppBar(
        title: Text('${ami.prenom} ${ami.nom}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor:
                    ami.isBestFriend ? AppColors.pink : AppColors.teal,
                child: Text(
                  ami.prenom[0].toUpperCase(),
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (ami.isBestFriend)
              const Center(
                child: Chip(
                  label: Text('Meilleur ami'),
                  avatar: Icon(Icons.star, color: Colors.amber),
                ),
              ),
            const SizedBox(height: 16),
            _infoTile(Icons.person, 'Prénom', ami.prenom),
            _infoTile(Icons.person_outline, 'Nom', ami.nom),
            _infoTile(Icons.phone, 'Téléphone', ami.telephone),
            _infoTile(Icons.email, 'Email', ami.email),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Étape 4 — Formulaire d'ajout (Create)

### Concept clé : formulaire avec validation

Un formulaire Flutter utilise `Form` + `GlobalKey<FormState>` + `TextFormField`. La clé permet d'appeler `_formKey.currentState!.validate()` pour déclencher toutes les validations d'un coup.

### Fichier : `lib/screens/ajouter_ami_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:myfriends/data/friends_data.dart';
import 'package:myfriends/main.dart';

class AjouterAmiScreen extends StatefulWidget {
  const AjouterAmiScreen({super.key});

  @override
  State<AjouterAmiScreen> createState() => _AjouterAmiScreenState();
}

class _AjouterAmiScreenState extends State<AjouterAmiScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl       = TextEditingController();
  final _prenomCtrl    = TextEditingController();
  final _telCtrl       = TextEditingController();
  final _emailCtrl     = TextEditingController();
  bool  _isBestFriend  = false;

  @override
  void dispose() {
    // Toujours libérer les contrôleurs pour éviter les fuites mémoire
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _sauvegarder() {
    if (!_formKey.currentState!.validate()) return;

    // Générer un id unique simple
    final newId = friendsData.isEmpty
        ? 1
        : friendsData.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;

    final nouvelAmi = Friend(
      id: newId,
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      telephone: _telCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      isBestFriend: _isBestFriend,
    );

    // Mettre à jour le jeu de données global
    friendsData.add(nouvelAmi);

    // Retourner le nouvel ami à l'écran appelant
    Navigator.pop(context, nouvelAmi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un ami')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildChamp(
                controller: _prenomCtrl,
                label: 'Prénom',
                icon: Icons.person,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Prénom requis' : null,
              ),
              const SizedBox(height: 14),
              _buildChamp(
                controller: _nomCtrl,
                label: 'Nom',
                icon: Icons.person_outline,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 14),
              _buildChamp(
                controller: _telCtrl,
                label: 'Téléphone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Téléphone requis' : null,
              ),
              const SizedBox(height: 14),
              _buildChamp(
                controller: _emailCtrl,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email requis';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                title: const Text('Meilleur ami'),
                secondary: Icon(Icons.star,
                    color: _isBestFriend ? Colors.amber : Colors.grey),
                value: _isBestFriend,
                onChanged: (val) => setState(() => _isBestFriend = val),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _sauvegarder,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Enregistrer',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChamp({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
      ),
    );
  }
}
```

> **Points à retenir**
> - `GlobalKey<FormState>` : la clé du formulaire permet de déclencher `validate()` sur tous les champs en une seule ligne.
> - `validator` : chaque champ peut avoir sa propre règle de validation. Retourner `null` = valide, retourner une chaîne = message d'erreur.
> - `dispose()` : **obligatoire** pour libérer les `TextEditingController` quand l'écran est détruit.
> - `Navigator.pop(context, nouvelAmi)` : on **retourne** l'objet créé à l'écran précédent.

---

## Étape 5 — Formulaire de modification (Update)

Le formulaire de modification est **identique** au formulaire d'ajout, sauf que les champs sont **pré-remplis** avec les données de l'ami à modifier.

### Fichier : `lib/screens/modifier_ami_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:myfriends/data/friends_data.dart';
import 'package:myfriends/main.dart';

class ModifierAmiScreen extends StatefulWidget {
  const ModifierAmiScreen({super.key});

  @override
  State<ModifierAmiScreen> createState() => _ModifierAmiScreenState();
}

class _ModifierAmiScreenState extends State<ModifierAmiScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _emailCtrl;
  late bool _isBestFriend;
  late Friend _ami;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Récupérer l'ami passé en argument et pré-remplir les champs
    _ami         = ModalRoute.of(context)!.settings.arguments as Friend;
    _nomCtrl     = TextEditingController(text: _ami.nom);
    _prenomCtrl  = TextEditingController(text: _ami.prenom);
    _telCtrl     = TextEditingController(text: _ami.telephone);
    _emailCtrl   = TextEditingController(text: _ami.email);
    _isBestFriend = _ami.isBestFriend;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _sauvegarder() {
    if (!_formKey.currentState!.validate()) return;

    final amiModifie = _ami.copyWith(
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      telephone: _telCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      isBestFriend: _isBestFriend,
    );

    // Mettre à jour le jeu de données global
    final index = friendsData.indexWhere((a) => a.id == _ami.id);
    if (index != -1) friendsData[index] = amiModifie;

    Navigator.pop(context, amiModifie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier ${_ami.prenom}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildChamp(controller: _prenomCtrl, label: 'Prénom', icon: Icons.person),
              const SizedBox(height: 14),
              _buildChamp(controller: _nomCtrl, label: 'Nom', icon: Icons.person_outline),
              const SizedBox(height: 14),
              _buildChamp(
                  controller: _telCtrl,
                  label: 'Téléphone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              _buildChamp(
                  controller: _emailCtrl,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              SwitchListTile(
                title: const Text('Meilleur ami'),
                secondary: Icon(Icons.star,
                    color: _isBestFriend ? Colors.amber : Colors.grey),
                value: _isBestFriend,
                onChanged: (val) => setState(() => _isBestFriend = val),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _sauvegarder,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Mettre à jour',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChamp({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? '$label requis' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
      ),
    );
  }
}
```

> **Points à retenir**
> - `didChangeDependencies()` : utilisé ici à la place de `initState()` car on a besoin du `context` pour récupérer les arguments de route. `initState()` n'a pas encore accès au `context`.
> - `late` : mot-clé Dart qui promet que la variable sera initialisée avant son premier accès. Pratique ici car on ne peut pas initialiser dans `initState()`.
> - `copyWith(...)` : on ne modifie pas l'objet original, on en crée un **nouveau** avec les champs mis à jour. C'est le pattern `immutabilité`.

---

## Étape 6 — Brancher les routes dans `main.dart`

Ajouter les deux nouvelles routes dans `MaterialApp` :

```dart
// Dans main.dart, dans la map routes:
routes: {
  '/home':         (context) => const HomePage(),
  '/list_amis':    (context) => const ListeAmisScreen(),
  '/detail_ami':   (context) => const DetailsAmiScreen(),
  '/ajouter_ami':  (context) => const AjouterAmiScreen(),
  '/modifier_ami': (context) => const ModifierAmiScreen(),
  '/best':         (context) => BestFriendScreen(),
  '/compteur':     (context) => const CompteurScreen(),
  '/like':         (context) => const LikeScreen(),
  '/pass':         (context) => const PassScreen(),
  '/container':    (context) => const ContainerScreen(),
},
```

Et mettre à jour le Drawer pour ajouter un lien vers la liste :

```dart
// Dans widgets/drawer.dart, le ListTile pour la liste est déjà présent
// Vérifier que le onTap pointe bien vers '/list_amis'
ListTile(
  leading: Icon(Icons.people, color: AppColors.pink),
  title: Text('Mes Amis', style: TextStyle(color: AppColors.dark)),
  onTap: () => Navigator.pushNamed(context, '/list_amis'),
),
```

---

## Récapitulatif du flux CRUD

```
┌─────────────────────────────────────────────────────────┐
│                   ListeAmisScreen                       │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Card ami 1  [edit] [delete]  → onTap → Détail    │ │
│  │  Card ami 2  [edit] [delete]  → onTap → Détail    │ │
│  │  ...                                               │ │
│  └────────────────────────────────────────────────────┘ │
│                                          [FAB +]        │
└─────────────────────────────────────────────────────────┘
         │ onTap                │ [edit]          │ [FAB]
         ▼                      ▼                 ▼
  DetailsAmiScreen      ModifierAmiScreen   AjouterAmiScreen
  (lecture seule)       (pré-rempli)        (champs vides)
                              │                   │
                     pop(amiModifie)        pop(nouvelAmi)
                              │                   │
                              ▼                   ▼
                       setState() → liste mise à jour
```

---

## Exercices complémentaires

### Niveau 1 — Obligatoire
1. **Recherche** : Ajouter une barre de recherche (`TextField`) en haut de `ListeAmisScreen` qui filtre la liste par nom ou prénom en temps réel (utilisez `onChanged`).
2. **Compteur** : Afficher séparément le nombre d'amis normaux et le nombre de "meilleurs amis" dans l'AppBar.

### Niveau 2 — Intermédiaire
3. **Tri** : Ajouter un bouton dans l'AppBar qui trie la liste alphabétiquement (A→Z / Z→A, bascule à chaque tap).
4. **Onglets** : Utiliser `DefaultTabController` + `TabBar` pour séparer "Tous les amis" et "Meilleurs amis" dans deux onglets.

### Niveau 3 — Avancé
5. **Snackbar** : Après une suppression, afficher un `SnackBar` avec un bouton **Annuler** qui remet l'ami dans la liste.
6. **Refacto** : Extraire le formulaire dans un widget `AmiFormWidget` réutilisable par `AjouterAmiScreen` et `ModifierAmiScreen` pour éliminer la duplication de code.

---

## Ce que ce TP vous a appris

| Compétence | Mise en œuvre |
|---|---|
| Modèle de données Dart | Classe `Friend` avec `copyWith` |
| Jeu de données simulé | Liste `friendsData` en mémoire |
| Affichage dynamique | `ListView.builder` |
| Navigation avec données | `arguments` + `await Navigator.pushNamed` |
| Formulaire et validation | `Form` + `GlobalKey` + `TextFormField` + `validator` |
| Retour de résultat | `Navigator.pop(context, result)` |
| Suppression avec confirmation | `showDialog` + `AlertDialog` |
| Pattern immutabilité | `copyWith` au lieu de mutation directe |

---

## Et ensuite : vers les APIs

Ce TP simule un CRUD **en mémoire**. Dans les prochains chapitres, nous allons :

1. **Persistance locale** — remplacer `friendsData` par une base SQLite (`sqflite`) ou un stockage clé-valeur (`shared_preferences`).
2. **API REST** — remplacer les données locales par des appels HTTP (`http` package) vers un serveur.
3. **Gestion d'état avancée** — remplacer le `setState` manuel par un `Provider` ou `Riverpod` pour partager l'état entre écrans sans le passer à la main.

La logique CRUD que vous venez d'implémenter **reste identique** : seule la **source des données** changera.

---

*TP rédigé dans le cadre du cours Développement Mobile — Flutter*