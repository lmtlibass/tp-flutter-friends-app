# TP Flutter — MySquad 👥

**Une app fun pour présenter mes amis**

> **Cours** : Introduction au Développement Mobile
> **Niveau** : L3 Informatique
> **Prérequis** : Chapitres 1, 2 et 3 terminés
> **Durée estimée** : 4h00
> **Encadrant** : Libasse THIAM — lmtlibasse@gmail.com
> **Organisme** : Wommate Technology — [www.wommate.tech](https://www.wommate.tech)

---

## 🎉 Le concept

Vous allez construire une application Flutter qui présente votre cercle d'amis de manière fun et personnelle. Chaque ami a une fiche complète avec photo, prénom, âge, téléphone, description, souvenirs partagés et traits de caractère. Et en bonus : la page **« Who is my Best Friend »** qui révèle votre meilleur ami avec une mise en avant spéciale ⭐.

### 🎨 Choisir le nom de votre app

Avant de commencer, choisissez un nom qui vous parle. Voici 5 propositions :

| Nom | Vibe |
|-----|------|
| **MySquad** 👥 | Moderne, branché, court |
| **Bestie** 💖 | Mignon, joue avec « best friend » |
| **FriendZone** 😄 | Humoristique |
| **MyTribe** 🌟 | Chaleureux, familial |
| **PalsApp** 🤝 | Simple, amical |

> 👉 **Dans ce guide, on utilisera MySquad** — adaptez librement à votre choix.

---

## 🎯 Objectifs pédagogiques

À la fin de ce TP, vous saurez :

- Structurer une application Flutter en **4 écrans** reliés par des routes nommées
- Stocker des données structurées avec des **Map** et des **List**
- Intégrer et afficher des **images locales** via `assets` + `pubspec.yaml` + `flutter pub get`
- Concevoir des **cartes (Card)** stylisées avec photo, badges et boutons
- Tronquer du texte à 100 caractères proprement
- Filtrer une liste pour ne garder qu'un seul élément (le best friend)
- Utiliser `setState()` pour des interactions dynamiques (favoris)
- Créer un **design fun et cohérent** avec une palette de couleurs

---

## 🗺 Architecture de l'app

```
┌──────────────────────┐
│   🏠 PAGE D'ACCUEIL  │
│                      │
│   « Bienvenue »      │
│                      │
│  [Découvrir mes amis]│──┐
│  [Who is my Bestie?] │──┼──┐
└──────────────────────┘  │  │
                          ▼  │
              ┌──────────────────────┐
              │  👥 LISTE DES AMIS    │
              │                      │
              │  📷 Aminata          │
              │  📷 Moussa     [→]   │──┐
              │  📷 Fatou            │  │
              │  📷 Ibrahima         │  │
              └──────────────────────┘  │
                                        ▼
                            ┌──────────────────────┐
                            │   🔍 DÉTAIL D'UN AMI  │
                            │                      │
                            │   Grande photo       │
                            │   Toutes les infos   │
                            │   Souvenirs · Traits │
                            └──────────────────────┘
                                        ▲
                                        │
              ┌──────────────────────┐  │
              │  ⭐ BEST FRIEND       │──┘
              │                      │
              │  Mise en avant       │
              │  Photo + bio fun     │
              └──────────────────────┘
```

---

## 🎨 Notre palette de couleurs

On va utiliser une palette **claire, fun et cohérente** :

| Rôle | Couleur | Hex | Usage |
|------|---------|-----|-------|
| **Principale** | Teal | `#0097A7` | AppBar, boutons principaux |
| **Accent fun** | Rose vif | `#DC2C8C` | Badges, boutons secondaires |
| **Or (best friend)** | Doré | `#FBBF24` | Mise en avant du meilleur ami |
| **Fond** | Blanc cassé | `#FAFAFA` | Fond des pages |
| **Texte foncé** | Noir doux | `#1F2937` | Titres et corps |
| **Texte secondaire** | Gris | `#6B7280` | Sous-titres, légendes |

---

## 🛠 Étape 1 — Créer le projet

Ouvrez votre terminal :

```bash
flutter create mysquad
cd mysquad
code .
```

Lancez une première fois pour vérifier que tout fonctionne :

```bash
flutter run -d chrome
```

L'application de compteur par défaut s'ouvre. Parfait — on va tout réécrire.

---

## 📦 Étape 2 — Organiser les dossiers

Un projet bien organisé = un projet maintenable. Dans `lib/`, créez la structure suivante :

```
lib/
├── main.dart
├── data/
│   └── friends_data.dart      ← la liste de tes amis
├── screens/
│   ├── accueil_screen.dart
│   ├── liste_amis_screen.dart
│   ├── detail_ami_screen.dart
│   └── best_friend_screen.dart
└── widgets/
    └── friend_card.dart        ← carte réutilisable
```

> 💡 **Pourquoi cette organisation ?**
> Séparer les écrans (`screens`), les composants réutilisables (`widgets`) et les données (`data`) rend votre code prévisible. Quand vous cherchez un écran, vous savez exactement où regarder.

À la racine du projet, créez aussi le dossier qui contiendra les photos :

```bash
mkdir -p assets/images
```

---

## 🖼 Étape 3 — Préparer les images (le workflow complet)

C'est l'étape la plus importante du TP : **comprendre comment Flutter charge des images locales**.

### 3.1 Récupérer 5 photos

Vous avez **3 options** pour vos photos d'amis :

**Option A — Photos de vos vrais amis** (le plus fun !)
Demandez leur permission, récupérez 5 photos en `.jpg` ou `.png`.

**Option B — Avatars générés**
Allez sur [https://www.dicebear.com/playground](https://www.dicebear.com/playground), choisissez un style (avataaars, fun-emoji, big-smile…), générez 5 avatars différents, téléchargez-les en PNG.

**Option C — Photos libres de droits**
[https://unsplash.com/s/photos/portrait](https://unsplash.com/s/photos/portrait) — téléchargez 5 portraits.

### 3.2 Renommer et placer les images

Mettez vos 5 images dans `assets/images/` avec ces noms **exactement** :

```
assets/
└── images/
    ├── aminata.jpg
    ├── moussa.jpg
    ├── fatou.jpg
    ├── ibrahima.jpg
    └── mariama.jpg
```

> ⚠️ **Important** : Flutter est **sensible à la casse**. `Aminata.jpg` et `aminata.jpg` sont deux fichiers différents pour lui. Restez en minuscules sans accents pour éviter les bugs.

### 3.3 Déclarer les images dans `pubspec.yaml`

Ouvrez le fichier `pubspec.yaml` à la racine du projet. Cherchez la section `flutter:` (déjà présente, environ ligne 55). Il y a un bloc commenté qui ressemble à ça :

```yaml
flutter:
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
```

**Remplacez** cette section par :

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
```

> ⚠️ **Attention à l'indentation** : YAML est très strict. Utilisez **uniquement des espaces** (pas de tabulations), avec exactement **2 espaces** d'indentation. Une mauvaise indentation = erreur au build.

### 3.4 Faire `flutter pub get`

Dans le terminal :

```bash
flutter pub get
```

**À quoi ça sert ?** Cette commande dit à Flutter : « relis `pubspec.yaml`, télécharge les dépendances si besoin, et prépare les assets pour qu'ils soient inclus dans l'app ». Sans cette commande, vos images ne seront **pas trouvées** au runtime.

> 🔁 **Règle d'or** : à chaque fois que vous modifiez `pubspec.yaml`, vous **devez** refaire `flutter pub get`. VS Code le propose souvent automatiquement en haut de l'écran — acceptez.

### 3.5 Tester un affichage rapide

Pour vérifier que tout fonctionne, ouvrez `lib/main.dart` et remplacez-le **temporairement** par :

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: TestImage()));

class TestImage extends StatelessWidget {
  const TestImage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/aminata.jpg')),
    );
  }
}
```

Lancez avec `flutter run -d chrome`. Si l'image d'Aminata s'affiche, **bravo**, votre workflow images fonctionne. Si vous voyez une icône cassée 🖼❌ :

- Vérifiez le chemin exact du fichier
- Vérifiez l'indentation dans `pubspec.yaml`
- Refaites `flutter pub get`
- Faites un **arrêt complet + redémarrage** de l'app (pas juste hot reload)

---

## 📋 Étape 4 — Créer les données des amis

Créez le fichier `lib/data/friends_data.dart` :

```dart
// Liste de tous mes amis sous forme de Maps.
// Chaque Map représente un ami avec ses informations.

final List<Map<String, dynamic>> friends = [
  {
    'prenom': 'Aminata',
    'nom': 'Diallo',
    'age': 22,
    'ville': 'Dakar',
    'telephone': '+221 77 123 45 67',
    'photo': 'assets/images/aminata.jpg',
    'description':
        "Aminata est ma camarade de fac. Toujours souriante, elle aide tout le monde "
        "pendant les TP. Passionnée d'intelligence artificielle, elle veut devenir "
        "data scientist. Le café est son carburant officiel.",
    'souvenir':
        "Notre marathon de révisions à la veille de l'examen d'algorithmique — "
        "trois nuits blanches et beaucoup de thiéboudienne.",
    'traits': ['Drôle', 'Curieuse', 'Loyale', 'Tête en l\'air'],
    'isBestFriend': true,  // ⭐ Voici la best friend
  },
  {
    'prenom': 'Moussa',
    'nom': 'Sow',
    'age': 24,
    'ville': 'Thiès',
    'telephone': '+221 76 987 65 43',
    'photo': 'assets/images/moussa.jpg',
    'description':
        "Moussa est le geek absolu du groupe. Il connaît tous les raccourcis "
        "clavier de VS Code par cœur et corrige nos bugs en 30 secondes.",
    'souvenir': "La nuit où il a refait notre projet web en 4 heures, à la place de l'équipe entière.",
    'traits': ['Génie', 'Discret', 'Patient'],
    'isBestFriend': false,
  },
  {
    'prenom': 'Fatou',
    'nom': 'Ndiaye',
    'age': 21,
    'ville': 'Saint-Louis',
    'telephone': '+221 78 555 12 34',
    'photo': 'assets/images/fatou.jpg',
    'description':
        "Fatou est notre rayon de soleil. Toujours partante pour un Yassa et une "
        "soirée karaoké. Elle danse mieux que nous tous réunis.",
    'souvenir': "Notre virée à Saly l'été dernier — on y a juré de devenir tous millionnaires avant 30 ans.",
    'traits': ['Énergique', 'Sociable', 'Optimiste'],
    'isBestFriend': false,
  },
  {
    'prenom': 'Ibrahima',
    'nom': 'Ba',
    'age': 23,
    'ville': 'Dakar',
    'telephone': '+221 70 444 77 88',
    'photo': 'assets/images/ibrahima.jpg',
    'description':
        "Ibrahima est notre philosophe. Il a toujours une citation pour chaque "
        "situation et peut débattre 3 heures sur n'importe quel sujet.",
    'souvenir': "Notre débat enflammé sur Sartre vs Confucius à 2h du matin.",
    'traits': ['Réfléchi', 'Éloquent', 'Têtu'],
    'isBestFriend': false,
  },
  {
    'prenom': 'Mariama',
    'nom': 'Faye',
    'age': 22,
    'ville': 'Mbour',
    'telephone': '+221 77 333 22 11',
    'photo': 'assets/images/mariama.jpg',
    'description':
        "Mariama est l'artiste du groupe. Peinture, photo, vidéo — elle touche à "
        "tout avec un goût impeccable. C'est elle qui a fait notre logo de promo.",
    'souvenir': "L'expo qu'elle a organisée pour ses 20 ans, où on a tous joué les serveurs.",
    'traits': ['Créative', 'Sensible', 'Perfectionniste'],
    'isBestFriend': false,
  },
];
```

> 💡 **Pourquoi `Map<String, dynamic>` ?**
> `dynamic` permet de mélanger des types différents dans une même Map : `int`, `String`, `bool`, `List`. C'est pratique pour démarrer. Quand votre projet grandit, vous remplacerez ces Maps par une **classe** `Friend` plus rigoureuse — on verra ça au chapitre 4.

---

## 🎨 Étape 5 — Le thème de l'app

Créez un thème centralisé qu'on appliquera à toute l'app. Cela évite de répéter les couleurs partout.

Modifiez `lib/main.dart` (vidons le test précédent) :

```dart
import 'package:flutter/material.dart';
import 'screens/accueil_screen.dart';
import 'screens/liste_amis_screen.dart';
import 'screens/best_friend_screen.dart';

void main() => runApp(const MySquadApp());

// Constantes de couleurs accessibles partout
class AppColors {
  static const teal      = Color(0xFF0097A7);
  static const pink      = Color(0xFFDC2C8C);
  static const gold      = Color(0xFFFBBF24);
  static const bg        = Color(0xFFFAFAFA);
  static const dark      = Color(0xFF1F2937);
  static const gray      = Color(0xFF6B7280);
}

class MySquadApp extends StatelessWidget {
  const MySquadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySquad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':       (_) => const AccueilScreen(),
        '/liste':  (_) => const ListeAmisScreen(),
        '/best':   (_) => const BestFriendScreen(),
      },
    );
  }
}
```

> ⚠️ **VS Code va souligner en rouge** `AccueilScreen`, `ListeAmisScreen` et `BestFriendScreen` parce qu'on ne les a pas encore créés. C'est normal — on s'en occupe juste après.
>
> Note aussi qu'on ne déclare PAS de route pour le détail d'un ami : on le poussera directement avec `Navigator.push(...)` en passant les données de l'ami en paramètre.

---

## 🏠 Étape 6 — Page d'accueil (intro)

C'est la première page que l'utilisateur voit. Elle doit donner envie d'explorer. On utilise un **dégradé teal → rose** pour la rendre attrayante.

Créez `lib/screens/accueil_screen.dart` :

```dart
import 'package:flutter/material.dart';
import '../main.dart';  // pour AppColors

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le body remplit tout, sans AppBar pour un effet immersif
      body: Container(
        // Dégradé d'arrière-plan teal → rose
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.teal, AppColors.pink],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Emoji géant en haut
                const Text('👥', style: TextStyle(fontSize: 100)),
                const SizedBox(height: 20),

                // Titre principal
                const Text(
                  'Bienvenue sur MySquad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Paragraphe explicatif
                const Text(
                  "MySquad est mon espace pour présenter les personnes qui comptent "
                  "le plus pour moi. Chaque ami a sa propre fiche avec son histoire, "
                  "ses traits de caractère et nos meilleurs souvenirs partagés. "
                  "Découvrez ma bande !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,  // hauteur de ligne plus aérée
                  ),
                ),
                const SizedBox(height: 50),

                // Bouton principal blanc — "Découvrir mes amis"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.group, color: AppColors.teal),
                    label: const Text(
                      'Découvrir mes amis',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/liste');
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Bouton secondaire transparent — "Who is my Bestie?"
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.star, color: AppColors.gold),
                    label: const Text(
                      'Who is my Best Friend?',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/best');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### 🔍 Ce qu'on a utilisé ici

| Concept | À quoi ça sert |
|---------|----------------|
| `LinearGradient` | Créer un dégradé de couleurs pour le fond |
| `SafeArea` | Éviter que le contenu chevauche les barres système (haut et bas) |
| `ElevatedButton.icon` | Bouton avec une icône + texte |
| `OutlinedButton.icon` | Bouton « contour seulement » pour une hiérarchie visuelle |
| `borderRadius: 30` | Coins très arrondis → effet « pilule » moderne |
| `height: 1.5` | Espacement vertical entre les lignes de texte (plus lisible) |

---

## 👥 Étape 7 — Page liste des amis

C'est ici qu'on affiche toutes les cartes scrollables. On va d'abord créer un **widget réutilisable** `FriendCard`, puis la liste qui l'utilise.

### 7.1 Le widget Card réutilisable

Créez `lib/widgets/friend_card.dart` :

```dart
import 'package:flutter/material.dart';
import '../main.dart';

class FriendCard extends StatelessWidget {
  final Map<String, dynamic> friend;
  final VoidCallback onTap;

  const FriendCard({
    super.key,
    required this.friend,
    required this.onTap,
  });

  // Tronque la description à 100 caractères avec "..." à la fin
  String _descriptionTronquee() {
    final desc = friend['description'] as String;
    if (desc.length <= 100) return desc;
    return '${desc.substring(0, 100)}...';
  }

  @override
  Widget build(BuildContext context) {
    final bestFriend = friend['isBestFriend'] == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo circulaire (avec un cadre doré si best friend)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: bestFriend
                    ? Border.all(color: AppColors.gold, width: 3)
                    : null,
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(friend['photo']),
              ),
            ),
            const SizedBox(width: 16),

            // Texte (prend tout l'espace restant)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prénom + nom + éventuelle étoile dorée
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${friend['prenom']} ${friend['nom']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (bestFriend)
                        const Icon(Icons.star, color: AppColors.gold, size: 22),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Description tronquée
                  Text(
                    _descriptionTronquee(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bouton "Découvrir"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Découvrir'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 🔍 Décortiquons les nouveautés

| Élément | Rôle |
|---------|------|
| `VoidCallback onTap` | Une fonction sans paramètre, passée par le parent. La carte ne sait pas où elle mène — c'est le parent qui décide. |
| `_descriptionTronquee()` | Méthode privée qui coupe le texte à 100 caractères. Le `substring(0, 100)` est sûr car on a déjà vérifié la longueur. |
| `Container` avec `Border.all` autour du `CircleAvatar` | Effet de cadre doré pour la best friend |
| `if (bestFriend) ...` dans la `Row` | Affiche l'étoile **seulement** si l'ami est best friend |
| `overflow: TextOverflow.ellipsis` | Si le nom est trop long, il ajoute « … » à la fin |
| `Expanded` | Fait prendre tout l'espace restant à un widget |

### 7.2 La page liste

Créez `lib/screens/liste_amis_screen.dart` :

```dart
import 'package:flutter/material.dart';
import '../data/friends_data.dart';
import '../widgets/friend_card.dart';
import 'detail_ami_screen.dart';

class ListeAmisScreen extends StatelessWidget {
  const ListeAmisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma bande 👥'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return FriendCard(
            friend: friend,
            onTap: () {
              // Navigation vers la page détail en passant l'ami complet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailAmiScreen(friend: friend),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

> 💡 **Pourquoi `ListView.builder` plutôt que `ListView` simple ?**
> `ListView.builder` ne construit que les éléments visibles à l'écran (lazy loading). Pour 5 amis, peu importe. Mais si vous en aviez 500, ça ferait la différence entre une app fluide et une app qui rame. Prenez la bonne habitude dès maintenant.

---

## 🔍 Étape 8 — Page détail d'un ami

C'est l'écran le plus riche : photo en grand, toutes les infos, les traits sous forme de **chips** (petites pastilles), et un bloc souvenirs.

Créez `lib/screens/detail_ami_screen.dart` :

```dart
import 'package:flutter/material.dart';
import '../main.dart';

class DetailAmiScreen extends StatelessWidget {
  final Map<String, dynamic> friend;
  const DetailAmiScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final bestFriend = friend['isBestFriend'] == true;
    final traits = friend['traits'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('${friend['prenom']} ${friend['nom']}'),
      ),
      body: SingleChildScrollView(  // au cas où le contenu déborde
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BLOC TOP : photo + dégradé en arrière-plan
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.teal, AppColors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: bestFriend
                          ? Border.all(color: AppColors.gold, width: 4)
                          : Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(friend['photo']),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${friend['prenom']} ${friend['nom']}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (bestFriend) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'BEST FRIEND',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // BLOC INFOS RAPIDES
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LigneInfo(icon: Icons.cake, label: 'Âge', valeur: '${friend['age']} ans'),
                  _LigneInfo(icon: Icons.location_on, label: 'Ville', valeur: friend['ville']),
                  _LigneInfo(icon: Icons.phone, label: 'Téléphone', valeur: friend['telephone']),

                  const SizedBox(height: 20),
                  const _SectionTitle(emoji: '👋', titre: 'Qui est cet ami ?'),
                  Text(
                    friend['description'],
                    style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.dark),
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle(emoji: '💭', titre: 'Notre meilleur souvenir'),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: AppColors.pink, width: 4),
                      ),
                    ),
                    child: Text(
                      friend['souvenir'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.dark,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle(emoji: '✨', titre: 'Traits de caractère'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: traits.map<Widget>((trait) {
                      return Chip(
                        label: Text(trait, style: const TextStyle(color: Colors.white)),
                        backgroundColor: AppColors.teal,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sous-widget privé pour une ligne d'info (icône + label + valeur)
class _LigneInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valeur;
  const _LigneInfo({required this.icon, required this.label, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal, size: 22),
          const SizedBox(width: 12),
          Text('$label : ', style: const TextStyle(color: AppColors.gray, fontSize: 14)),
          Text(valeur, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.dark)),
        ],
      ),
    );
  }
}

// Sous-widget privé pour un titre de section avec emoji
class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String titre;
  const _SectionTitle({required this.emoji, required this.titre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            titre,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 🔍 Les techniques nouvelles utilisées

| Technique | Effet |
|-----------|-------|
| `Wrap` | Comme `Row`, mais passe à la ligne quand l'espace manque → parfait pour les chips |
| `Chip` | Petite pastille avec du texte, prête à l'emploi |
| `withValues(alpha: 0.08)` | Couleur avec transparence très légère → fond doux |
| `Border(left: BorderSide(...))` | Barre verticale colorée à gauche du bloc souvenirs |
| `BoxShadow` | Ombre douce sous la photo |
| Sous-widgets privés `_LigneInfo`, `_SectionTitle` | Découper le code en petits widgets réutilisables localement |
| `if (bestFriend) ...[` (spread) | Insérer **plusieurs** widgets conditionnellement dans une liste |

---

## ⭐ Étape 9 — Page Best Friend

Cette page filtre la liste pour ne garder que l'ami marqué `isBestFriend: true` et lui réserve un design encore plus festif.

Créez `lib/screens/best_friend_screen.dart` :

```dart
import 'package:flutter/material.dart';
import '../data/friends_data.dart';
import '../main.dart';

class BestFriendScreen extends StatelessWidget {
  const BestFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // On cherche le best friend dans la liste avec firstWhere
    final bestie = friends.firstWhere(
      (f) => f['isBestFriend'] == true,
      orElse: () => <String, dynamic>{},  // Map vide si aucun
    );

    // Sécurité : si aucun best friend trouvé
    if (bestie.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Best Friend')),
        body: const Center(
          child: Text(
            "Aucun best friend défini 😢",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        // Dégradé doré pour donner un côté solennel/fête
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gold, AppColors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Bouton retour custom
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bandeau "MY BEST FRIEND"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: AppColors.gold),
                    SizedBox(width: 8),
                    Text(
                      'MY BEST FRIEND',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.star, color: AppColors.gold),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Photo géante avec cadre doré
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 6),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 20),
                  ],
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage(bestie['photo']),
                ),
              ),

              const SizedBox(height: 20),

              // Nom
              Text(
                '${bestie['prenom']} ${bestie['nom']}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Text(
                '${bestie['age']} ans · ${bestie['ville']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 30),

              // Petit message dédié
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text('💛', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        bestie['description'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.dark,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 🔍 Pourquoi `firstWhere` ?

`friends.firstWhere((f) => f['isBestFriend'] == true)` parcourt la liste et retourne **le premier** ami pour qui la condition est vraie. C'est la méthode idiomatique en Dart pour chercher un élément. Le paramètre `orElse` est une sécurité au cas où aucun ami n'est marqué best friend (sinon ça crashe).

---

## 🚀 Étape 10 — Tester l'application

Lancez votre app :

```bash
flutter run -d chrome
```

### Checklist de vérification

| Action | Résultat attendu |
|--------|------------------|
| Au démarrage | Page d'accueil avec dégradé teal→rose, emoji 👥 géant, 2 boutons |
| Cliquer « Découvrir mes amis » | Arrivée sur la liste avec 5 cartes |
| Sur chaque carte | Photo, nom, description tronquée à ~100 caractères, bouton « Découvrir » |
| Aminata a un cadre doré et une étoile | ⭐ (parce qu'elle est best friend) |
| Cliquer « Découvrir » sur une carte | Arrivée sur la page détail avec toutes les infos |
| Cliquer la flèche retour | Retour à la liste |
| Cliquer « Who is my Best Friend? » sur l'accueil | Arrivée sur la page dorée d'Aminata |

> 🐛 **Bugs fréquents**
>
> - **Image non trouvée** → vérifier `pubspec.yaml` (indentation + le `flutter pub get`) et le nom exact du fichier (sensible à la casse)
> - **« Class not found »** → vérifier les `import` en haut de chaque fichier
> - **Layout cassé sur la page détail** → s'assurer que `SingleChildScrollView` enveloppe bien la `Column`
> - **Hot reload ne reflète pas un changement de `pubspec.yaml`** → faire un **arrêt complet** (Ctrl+C) puis `flutter run -d chrome` à nouveau

---

## 🎁 Étape 11 — Défis bonus

Une fois la base fonctionnelle, choisissez un ou plusieurs défis :

### Défi 1 — Compteur d'amis sur l'accueil ⭐

Sur la page d'accueil, ajoutez un petit texte dynamique du type : « Tu as 5 ami(e)s formidables ». Importez `friends_data.dart` et utilisez `friends.length`.

### Défi 2 — Système de favoris avec `setState()` ⭐⭐

Transformez `ListeAmisScreen` en `StatefulWidget`. Ajoutez un cœur 💗 sur chaque carte qui se remplit quand on clique dessus. Stockez les favoris dans une `Set<int>` (les index des amis aimés) et utilisez `setState()` pour rafraîchir.

```dart
final Set<int> _favoris = {};

// Dans le onTap du cœur :
setState(() {
  if (_favoris.contains(index)) {
    _favoris.remove(index);
  } else {
    _favoris.add(index);
  }
});
```

### Défi 3 — Barre de recherche ⭐⭐⭐

Au-dessus de la liste, ajoutez un `TextField` qui filtre les amis en temps réel selon ce qu'on tape (filtrer sur prénom + nom). Utilisez un `TextEditingController` + `setState()`.

### Défi 4 — Tri par âge ⭐⭐

Ajoutez un bouton dans l'AppBar de la liste qui trie les amis du plus jeune au plus vieux (ou l'inverse).

```dart
friends.sort((a, b) => a['age'].compareTo(b['age']));
```

### Défi 5 — Page « ajouter un ami » ⭐⭐⭐⭐

Ajoutez un `FloatingActionButton` sur la liste qui ouvre un formulaire pour ajouter un nouvel ami. Au retour du formulaire, ajoutez l'ami à la liste et appelez `setState()`. (Ce défi mobilise tout ce qu'on verra au chapitre 4 — formulaires & validation).

---

## ✅ Checklist finale avant de rendre

- [ ] Les 5 images sont bien présentes dans `assets/images/` et déclarées dans `pubspec.yaml`
- [ ] `flutter pub get` a été exécuté après modification de `pubspec.yaml`
- [ ] La page d'accueil affiche le dégradé et les 2 boutons
- [ ] Le bouton « Découvrir mes amis » mène à la liste
- [ ] La liste affiche 5 cartes avec photo, nom, description tronquée, bouton
- [ ] Le clic sur « Découvrir » d'une carte mène à la page détail correspondante
- [ ] La page détail affiche photo, infos, description, souvenir, traits
- [ ] Le best friend est mis en évidence (cadre doré + étoile + badge)
- [ ] Le bouton « Who is my Best Friend? » mène à la page dorée
- [ ] Aucune erreur ni warning dans la console
- [ ] Le code est bien organisé dans `screens/`, `widgets/`, `data/`

---

## 📚 Récapitulatif des concepts vus

| Concept | Où dans le TP |
|---------|---------------|
| **Organisation en dossiers** | `lib/screens`, `lib/widgets`, `lib/data` |
| **Assets et `pubspec.yaml`** | Étape 3 — déclaration des images |
| **`flutter pub get`** | Commande à relancer après tout changement de `pubspec.yaml` |
| **`Image.asset` / `AssetImage`** | Affichage des photos |
| **List + Map** | `friends_data.dart` |
| **Thème global (`ThemeData`)** | `main.dart` |
| **Routes nommées** | `MaterialApp(routes: {...})` |
| **Navigation avec données** | `Navigator.push(MaterialPageRoute(...))` vers DetailAmiScreen |
| **`LinearGradient`** | Fond de l'accueil et de la page best friend |
| **`Card` + `BorderRadius` + `elevation`** | Cartes de la liste |
| **`Chip` + `Wrap`** | Traits de caractère sur la page détail |
| **`ListView.builder`** | Liste performante des amis |
| **`firstWhere`** | Trouver le best friend dans la liste |
| **`substring(0, 100)`** | Tronquer la description |
| **Widget privé `_LigneInfo`** | Découper le code en sous-widgets locaux |
| **Constantes `AppColors`** | Centraliser les couleurs |

---

## 🔮 Et après ?

Ce TP vous a fait toucher du doigt le `StatefulWidget` (juste effleuré dans les défis bonus). Le **chapitre 4** va l'approfondir en profondeur :

- Le cycle de vie complet avec ses 7 méthodes
- La gestion correcte des `TextEditingController`, `ScrollController`, `AnimationController`
- Le pattern `Form` + `GlobalKey<FormState>` pour valider plusieurs champs
- Le **lifting state up** pour faire communiquer parent et enfants

Vous pourrez alors revenir sur ce TP et implémenter sereinement les défis bonus 3 et 5.

Bon TP, et amusez-vous bien avec votre crew ! 🎉

---

*Document rédigé par Libasse THIAM pour Wommate Technology — Reproductible sous licence pédagogique.*