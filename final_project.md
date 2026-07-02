# Projet d'Évaluation — Application Flutter de Rédaction de PV de Réunion
## Flutter + SQLite + SharedPreferences + Reconnaissance Vocale

> **Type :** Projet d'évaluation autonome
> **Prérequis :** Chapitres 4 (Stateful), 5 (Formulaires), 6 (Persistance locale) maîtrisés. Avoir réalisé les TPs (compteur, formulaires, contacts SQLite, MySquad).
> **Durée estimée :** 5 à 7 jours
> **Style de code imposé :** Flutter pur — pas de Provider, pas de Riverpod, pas de Bloc. Uniquement `setState()`, `StatefulWidget` et les patterns vus en cours.
> **Objectif final :** Une vraie application mobile qui permet à un secrétaire de réunion de générer des procès-verbaux, avec capture vocale et transcription automatique sur l'appareil.

---

## Compréhension de base

Les TPs des chapitres 4, 5 et 6 étaient des **projets guidés** : on te donnait chaque ligne de code, chaque écran, chaque opération CRUD.

**Ce projet-ci est une évaluation.** On ne te donne **PAS** les écrans Flutter.. on ne te donne **PAS** les Widget composés.. c'est à **toi** de les coder proprement..

Ressources clés :
- Un **énoncé fonctionnel** très détaillé (ce que l'app doit faire)
- Le **schéma SQLite** complet et prêt à l'emploi
- Le **code du widget audio** (capture vocale + transcription) — entièrement fourni
- La **stratégie de stockage** (quelles données dans SQLite, lesquelles dans SharedPreferences)
- Des **aides** : conseils sur la structuration, sur les écrans à créer, sur la démarche

Tu dois produire :
- Tous les **écrans Flutter** (`screens/`)
- Tous les **widgets réutilisables** (`widgets/`) sauf le widget audio
- Le **DbHelper** complet avec ses méthodes CRUD
- Le **PrefService** pour les préférences
- La **navigation** entre les écrans (routes nommées)
- La **logique de validation** des formulaires
- La **logique métier** (statuts, jointures pour le PV)

> Si tu as compris les TPs des chapitres 4, 5 et 6.. tu as **déjà tous les outils** pour réussir celui-ci.. C'est exactement les mêmes briques : `StatefulWidget`, `setState`, `TextFormField`, `Form` + `GlobalKey`, `Navigator.pushNamed`, `db.insert`, `db.query`, `db.update`, `await prefs.setBool`.. assemblées différemment.. C'est précisément ce qu'on veut vérifier..

---

## Contexte — Pourquoi cette application ?

Tu travailles maintenant pour une **association de quartier à Dakar**.

À chaque réunion (assemblée générale, réunion de bureau, comité..), c'est le **secrétaire général** qui doit rédiger le **procès-verbal** — le fameux **« PV »**.

Le PV, c'est le document officiel qui garde la trace de **qui a dit quoi** pendant la réunion. C'est important : en cas de litige, de vote contesté, ou simplement pour les absents.. le PV fait foi.

Aujourd'hui le secrétaire écrit tout **à la main** pendant la réunion.. il n'arrive pas à suivre.. il rate des passages.. son écriture est illisible.. et après il passe 2 heures à recopier au propre..

Le bureau te demande une **application mobile** qui va lui permettre de :

1. **Créer une nouvelle réunion** en saisissant les informations de base
2. **Enregistrer la liste des présents** (les participants à la réunion)
3. Pendant la réunion : **à chaque fois que quelqu'un prend la parole**, le secrétaire sélectionne le nom de la personne dans la liste, **appuie sur le bouton micro**, et la **transcription du vocal se remplit automatiquement** dans une zone de texte. Le secrétaire peut corriger le texte si besoin, puis appuie sur **« Enregistrer »** pour sauvegarder cette intervention.
4. Quand la réunion est finie, appuyer sur **« Réunion terminée »**
5. **Afficher / exporter le PV** complet, propre, prêt à être diffusé

> **Pourquoi une app mobile et pas une web ?** Le secrétaire est en réunion, parfois dans des zones sans réseau (sous-sol, village). L'app doit fonctionner **100 % hors-ligne** (SQLite + SharedPreferences en local). Aucune connexion internet requise pour le fonctionnement de base.

---

## Compétences à valider dans ce projet

| Compétence | Comment elle est testée ici |
|---|---|
| Architecture Flutter en couches | Tu dois séparer `screens/`, `widgets/`, `data/`, `models/` |
| StatefulWidget + setState | Au moins 3 écrans avec état (séance, formulaires) |
| Formulaires avec Form + validators | Formulaire de création de réunion avec 5+ champs validés |
| TextEditingController + dispose() | Plusieurs champs avec contrôleurs correctement libérés |
| Navigation entre écrans | 4 écrans reliés avec passage d'arguments (id de réunion) |
| SQLite (sqflite) | 3 tables avec clés étrangères + 4 opérations CRUD |
| Jointures SQL (JOIN) | Le PV doit afficher les interventions **avec le nom du participant** |
| SharedPreferences | Pour les paramètres et préférences (thème, valeurs par défaut) |
| Choix stratégique de stockage | Savoir décider : SQLite ou SharedPreferences pour chaque donnée |
| Intégration de code fourni | Tu dois savoir **lire, comprendre et brancher** le widget audio donné |
| Gestion async/await | Toutes les opérations BDD et audio sont asynchrones |
| Logique métier | Gérer le statut d'une réunion (`en_cours` → `terminée`), désactiver des actions |

---

## L'arborescence du projet — à reproduire

C'est la même logique que les TPs.. avec une vraie séparation en couches.

```
pv_reunion/
│
├── pubspec.yaml                ← dépendances (À COMPLÉTER)
│
├── lib/
│   ├── main.dart                       ← MaterialApp + routes (À TOI DE L'ÉCRIRE)
│   │
│   ├── data/
│   │   ├── db_helper.dart              ← SQLite, classe singleton (À TOI)
│   │   └── prefs_service.dart          ← SharedPreferences (À TOI)
│   │
│   ├── models/                         ← classes Dart représentant les données
│   │   ├── reunion.dart                ← (À TOI, optionnel)
│   │   ├── participant.dart            ← (À TOI, optionnel)
│   │   └── intervention.dart           ← (À TOI, optionnel)
│   │
│   ├── screens/                        ← un fichier par écran
│   │   ├── accueil_screen.dart         ← liste des réunions (À TOI)
│   │   ├── nouvelle_reunion_screen.dart← formulaire création (À TOI)
│   │   ├── seance_screen.dart          ← la grande page (À TOI)
│   │   ├── pv_screen.dart              ← affichage PV final (À TOI)
│   │   └── parametres_screen.dart      ← optionnel/bonus (À TOI)
│   │
│   └── widgets/                        ← composants réutilisables
│       ├── reunion_card.dart           ← carte d'une réunion dans la liste (À TOI)
│       ├── ajout_participant.dart      ← mini-formulaire d'ajout (À TOI)
│       └── widget_audio.dart           ← capture + transcription (FOURNI)
│
└── android/
    └── app/src/main/AndroidManifest.xml ← permissions micro (À COMPLÉTER)
```

> **Rappel important** — Flutter cherche les widgets dans le dossier `lib/`. Toute classe doit être importée explicitement depuis son chemin (`import 'screens/accueil_screen.dart';`). Pas de magie comme avec les templates Flask.

> **Pourquoi `models/` est optionnel ?** Tu peux représenter une réunion par une `Map<String, dynamic>` (comme dans le chapitre 6) ou par une classe `Reunion`. La classe est plus propre mais demande plus de code. Pour ce projet d'évaluation, **les Maps suffisent**. Si tu te sens à l'aise, passe aux classes.

---

## ÉTAPE 0 — Préparer l'environnement

### 0.1 Créer le projet Flutter

```bash
# Créer le projet
flutter create pv_reunion
cd pv_reunion

# Ouvrir dans VS Code
code .
```

### 0.2 Ajouter les dépendances dans `pubspec.yaml`

Ouvre `pubspec.yaml`, trouve la section `dependencies:` et ajoute les packages suivants :

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6

  # Persistance locale
  sqflite: ^2.3.0              # base SQLite
  path: ^1.8.3                 # gestion des chemins de fichiers
  shared_preferences: ^2.2.2   # préférences clé-valeur

  # Reconnaissance vocale
  speech_to_text: ^7.0.0       # transcription audio → texte
  permission_handler: ^11.3.1  # permissions runtime (micro)

  # Formatage des dates en français
  intl: ^0.20.2

  # Optionnel (BONUS) — export PDF du PV
  # pdf: ^3.10.4
  # printing: ^5.11.0
```

Puis dans le terminal :

```bash
flutter pub get
```

### 0.3 Ajouter les permissions micro

**Android** — Ouvre `android/app/src/main/AndroidManifest.xml` et ajoute juste après la balise `<manifest>` ouvrante :

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

**iOS** (si tu testes sur iPhone) — Ouvre `ios/Runner/Info.plist` et ajoute avant la fermeture `</dict>` :

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Cette application a besoin du micro pour enregistrer les interventions de la réunion.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Cette application a besoin de la reconnaissance vocale pour transcrire les interventions.</string>
```

### 0.4 Vérifier que tout démarre

```bash
flutter run
```

L'app de démonstration par défaut s'ouvre. Parfait — on va tout réécrire.

---

## BESOINS FONCTIONNELS DÉTAILLÉS — ce que l'application doit faire exactement

Tu dois lire cette section **très attentivement**. C'est elle qui décrit le comportement attendu. Tu seras obligé de la relire pendant la réalisation.

### A. Les informations de base d'une réunion

Quand le secrétaire crée une nouvelle réunion, il doit pouvoir saisir :

| Information | Type widget | Obligatoire ? | Exemple |
|---|---|---|---|
| **Titre / objet de la réunion** | `TextFormField` | Oui | « Assemblée Générale Ordinaire 2026 » |
| **Date de la réunion** | `showDatePicker` | Oui | 12/06/2026 |
| **Heure de début** | `showTimePicker` | Optionnel | 18:30 |
| **Lieu** | `TextFormField` | Optionnel | « Salle polyvalente, Mairie de Yoff » |
| **Type de réunion** | `DropdownButtonFormField` | Oui | « Ordinaire » ou « Extraordinaire » |
| **Ordre du jour** | `TextFormField` (multiline) | Optionnel | « 1. Bilan financier 2. Élections 3. Divers » |
| **Nom du président de séance** | `TextFormField` | Optionnel | « Mme Fatou Diop » |
| **Nom du secrétaire** | `TextFormField` | Oui | « M. Moussa Sow » |

À la création, la réunion a automatiquement le **statut `en_cours`**.

> **Astuce SharedPreferences** — Le secrétaire est très souvent la **même personne** d'une réunion à l'autre. Au premier lancement, on lui demande son nom, et on le sauvegarde dans `SharedPreferences`. Lors des prochaines créations de réunion, le champ « Nom du secrétaire » est **pré-rempli automatiquement**. UX +1.

### B. La liste des présents (les participants)

Pour chaque réunion, le secrétaire enregistre les personnes présentes. Pour chaque présent :

| Information | Obligatoire ? | Exemple |
|---|---|---|
| **Nom** | Oui | « Diop » |
| **Prénom** | Oui | « Fatou » |
| **Fonction / rôle** | Optionnel | « Présidente », « Trésorier », « Membre » |

> **Conseil de structuration (UX)** — N'essaie PAS de faire un formulaire géant qui ajoute 15 présents d'un coup. Le plus simple et le plus propre : **les présents s'ajoutent un par un**, avec un petit formulaire dédié sur l'écran de la séance (un `Row` avec 3 `TextField` + un bouton « + »). Chaque ajout = un `INSERT` SQL + un `setState()` qui recharge la liste. C'est exactement le pattern « ajouter une tâche » que tu as vu au TP 3 du chapitre 6.

### C. Le cœur du projet — enregistrer une intervention

C'est **la fonctionnalité centrale**. Pendant la réunion, sur l'écran de la séance :

1. Le secrétaire voit la **liste des présents** déjà enregistrés.
2. Il y a un **menu déroulant** (`DropdownButton<int>`) qui contient **tous les présents** de cette réunion. Le secrétaire **sélectionne la personne qui prend la parole**.
3. À côté, il y a le **widget audio** (fourni dans cet énoncé) : un bouton micro pour **démarrer l'enregistrement** et un autre pour **arrêter**.
4. Quand l'enregistrement démarre, **la transcription se remplit progressivement dans un `TextField`** au fur et à mesure que la personne parle.
5. Le secrétaire **relit / corrige** le texte transcrit si besoin (la transcription n'est jamais parfaite à 100 %).
6. Il appuie sur **« Enregistrer »** → l'intervention (qui a parlé + ce qui a été dit) est **enregistrée dans SQLite**.
7. La liste des interventions se met à jour avec `setState()` : la nouvelle intervention apparaît en bas, et le `TextField` est vidé pour la prochaine prise de parole.

> **Le point clé à comprendre** — une « intervention » c'est juste un lien entre **une réunion**, **un participant** et **un contenu texte**. C'est du CRUD pur. La seule nouveauté, c'est que le texte arrive d'une transcription vocale au lieu d'être tapé au clavier — mais une fois dans le `TextEditingController`, **pour SQLite c'est exactement un `String` classique**.

### D. Terminer la réunion

Sur l'écran de la séance, un bouton **« Réunion terminée »**.

Quand le secrétaire appuie dessus :
- Un dialogue de confirmation s'affiche (« Êtes-vous sûr ? »)
- Si OUI : le **statut** de la réunion passe de `en_cours` à `terminée` (un simple `db.update`)
- Une fois terminée, on **ne peut plus ajouter d'interventions ni de présents** → tu masques ou désactives les formulaires si le statut est `terminée`

### E. Afficher le PV

Depuis la liste des réunions ou l'écran de la séance, le secrétaire peut **afficher le procès-verbal**.

Le PV est un écran **propre, lisible, scrollable** qui contient :
- Un **en-tête formel** : titre, type, date, heure, lieu, président, secrétaire
- L'**ordre du jour** (si renseigné)
- La **liste des présents** (avec leur fonction)
- Le **déroulé des interventions**, dans l'ordre chronologique, sous la forme :
  > **Prénom Nom** *(Fonction)* : « contenu de l'intervention.. »
- Le **statut** de la réunion (badge coloré)

> Pour afficher chaque intervention avec le **nom du participant**, tu auras besoin d'une **jointure SQL** (`JOIN`) entre la table des interventions et la table des participants. C'est expliqué plus bas dans la section base de données.

> **Bonus** — Ajouter un bouton « Exporter en PDF » qui utilise le package `pdf` + `printing` pour générer un vrai document PDF imprimable ou partageable via WhatsApp/email.

---

## STRATÉGIE DE STOCKAGE — SQLite ou SharedPreferences ?

C'est la grande question de ce projet. Tu dois savoir **où ranger chaque donnée**. Voici la règle :

> **SQLite** = pour les **données structurées** : tables, relations, listes, requêtes
> **SharedPreferences** = pour les **paramètres simples et uniques** : 1 valeur par clé, pas de relations

| Donnée | Où la stocker | Justification |
|---|---|---|
| Liste des réunions | **SQLite** | Plusieurs réunions, données structurées |
| Participants d'une réunion | **SQLite** | Relation N-1 avec une réunion |
| Interventions | **SQLite** | Relation avec réunion ET participant |
| Statut d'une réunion | **SQLite** | Attribut d'une réunion (donc dans la table) |
| Nom par défaut du secrétaire | **SharedPreferences** | 1 valeur unique, sert à pré-remplir |
| Type de réunion préféré | **SharedPreferences** | 1 valeur unique pour pré-sélection |
| Thème de l'app (clair/sombre) | **SharedPreferences** | Préférence utilisateur globale |
| Drapeau « première ouverture » | **SharedPreferences** | Booléen unique |
| Nom de l'association | **SharedPreferences** | Texte fixe, configuration |

> **Le test mental** — pose-toi cette question : *« Est-ce que cette donnée a des relations avec d'autres données ? Est-ce qu'il y en a plusieurs ? Faut-il pouvoir la filtrer, trier, joindre ? »*
> — Si OUI → **SQLite**
> — Si NON, juste un paramètre simple → **SharedPreferences**

---

## LES ÉCRANS À CRÉER — aide sur l'UX

Voici les **écrans** que ton application doit avoir. Pour chacun, on te dit **ce qu'il doit contenir** — mais c'est à toi de coder le widget Flutter correspondant.

### Écran 1 — Accueil : liste des réunions  →  route `/`

```
┌─────────────────────────────────────────────┐
│ 📋  Mes PV de Réunion          ⚙          │  ← AppBar avec titre + icône réglages
├─────────────────────────────────────────────┤
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │ AG Ordinaire 2026                       │ │  ← Card cliquable
│ │ 📅 12/06/2026 · Ordinaire               │ │
│ │ 📍 Salle Mairie Yoff                    │ │
│ │              [🟢 en cours]      ▶       │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │ Réunion bureau Mai                      │ │
│ │ 📅 03/05/2026 · Ordinaire               │ │
│ │ 📍 Maison des associations              │ │
│ │              [🔵 terminée]   📄         │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│                                             │
│                              ┌────────┐     │
│                              │   +    │     │  ← FloatingActionButton
│                              └────────┘     │
└─────────────────────────────────────────────┘
```

Doit contenir :
- Un `ListView.builder` qui affiche toutes les réunions
- Une `Card` par réunion avec : titre, date formatée, lieu, type, badge de statut coloré
- Un `FloatingActionButton` « + » qui mène à l'écran de création
- Au tap sur une carte : si statut `en_cours` → ouvrir l'écran de séance ; si `terminée` → ouvrir directement le PV (avec un long-press pour rouvrir la séance en lecture seule)
- Gérer le cas **« aucune réunion »** : afficher un message centré « Aucune réunion. Appuyez sur + pour créer la première. »

> **Données** : `db.query("reunions", orderBy: "date_reunion DESC")` au `initState()`.

### Écran 2 — Créer une réunion  →  route `/nouvelle`

Un `Form` avec **tous les champs de la section A**. Pense à :
- Utiliser `Form` + `GlobalKey<FormState>` (chapitre 5)
- `TextFormField` pour les textes, avec `validator` qui vérifie le requis
- `DropdownButtonFormField<String>` pour le type (Ordinaire / Extraordinaire)
- Un widget personnalisé pour la date qui ouvre `showDatePicker` au tap
- Idem pour l'heure avec `showTimePicker`
- `TextFormField(maxLines: 5)` pour l'ordre du jour (multi-lignes)
- **Pré-remplir** le champ « Nom du secrétaire » depuis SharedPreferences si une valeur existe
- À la soumission : valider le form, insérer dans SQLite, **sauvegarder le nom du secrétaire dans SharedPreferences** pour la prochaine fois, puis `Navigator.pushReplacementNamed` vers l'écran de séance

> **Pourquoi `pushReplacementNamed` ?** Pour que le bouton retour ne ramène pas au formulaire vide. On va directement au séance, et un retour ramène à l'accueil.

### Écran 3 — Séance en cours  →  route `/seance` (l'écran le plus riche)

C'est l'écran de travail du secrétaire pendant la réunion. Il a **plusieurs zones** :

```
┌──────────────────────────────────────────────┐
│ ←  AG Ordinaire 2026          [🟢 en cours]  │  ← AppBar
├──────────────────────────────────────────────┤
│ 📅 12/06/2026  🕐 18:30  📍 Salle Mairie    │  ← Header info
│                                              │
│ ── PRÉSENTS (4) ──                          │
│ ┌──────────────────────────────────────────┐ │
│ │ A│ Fatou Diop · Présidente              │ │
│ │ M│ Moussa Sow · Trésorier               │ │
│ │ I│ Ibrahima Ba · Membre                 │ │
│ │ A│ Aminata Diallo · Membre              │ │
│ └──────────────────────────────────────────┘ │
│                                              │
│ ── Ajouter un présent ──                    │
│ [Nom...]  [Prénom...]  [Fonction...]  [ + ] │
│                                              │
│ ── NOUVELLE INTERVENTION ──                 │
│ Qui parle ?  [ ▼ Sélectionner un présent ] │
│                                              │
│ ┌──────────────────────────────────────────┐ │
│ │  🎤 Démarrer    ⏹ Arrêter   ● 0:12    │ │
│ └──────────────────────────────────────────┘ │
│                                              │
│ Transcription :                              │
│ ┌──────────────────────────────────────────┐ │
│ │ Texte transcrit auto-rempli, modifiable  │ │
│ │                                          │ │
│ │                                          │ │
│ └──────────────────────────────────────────┘ │
│                          [ Enregistrer ]    │
│                                              │
│ ── DÉROULÉ (2 interventions) ──             │
│  1. Fatou Diop : « Je déclare la séance.. »│
│  2. Moussa Sow : « Le bilan financier.. »   │
│                                              │
│  [ 🏁 Réunion terminée ]  [ 📄 Voir le PV ] │
└──────────────────────────────────────────────┘
```

Cet écran doit contenir :

**Zone 1 — Header** : titre + date + heure + lieu + badge de statut

**Zone 2 — Présents** :
- `ListView` (ou `Column`) des participants avec leur fonction
- Un mini-formulaire d'ajout : 3 `TextField` + bouton « + »
- Si statut = `terminée` → masquer le mini-formulaire

**Zone 3 — Nouvelle intervention** :
- `DropdownButton<int>` qui liste tous les présents (`value` = `id` du participant)
- Le **widget audio fourni** (que tu intègres avec un callback)
- `TextField` (avec `controller`) qui affiche/permet de modifier la transcription
- Bouton « Enregistrer l'intervention »
- Si statut = `terminée` → masquer toute cette zone

**Zone 4 — Déroulé** :
- Liste chronologique des interventions
- Pour chaque intervention : nom + prénom + (fonction) + contenu
- Issue de la **requête avec JOIN** (voir section BDD)

**Zone 5 — Actions** :
- Bouton « 🏁 Réunion terminée » → dialogue de confirmation → `db.update` du statut
- Bouton « 📄 Voir le PV » → `Navigator.pushNamed('/pv', arguments: reunionId)`

> Le widget audio remplit le `TextEditingController` du champ transcription via un callback. Tu lui passes le contrôleur en paramètre. Quand le secrétaire appuie sur « Enregistrer », tu fais simplement `_contenuCtrl.text` pour récupérer le contenu — exactement comme un `TextField` classique.

> **Conseil performance** — Cet écran est complexe. Découpe-le en **sous-widgets privés** : `_HeaderReunion`, `_ListePresents`, `_AjoutPresent`, `_NouvelleIntervention`, `_DerouleInterventions`. Sinon ton `build()` va faire 300 lignes et devenir illisible.

### Écran 4 — Le procès-verbal  →  route `/pv`

L'affichage final, propre et lisible. Voir la section **E** des besoins fonctionnels.

Mets-le en forme comme un vrai document officiel :
- En-tête centré avec le nom de l'association (depuis SharedPreferences)
- Section « Informations de la réunion »
- Section « Ordre du jour » (si renseigné)
- Section « Présents » (avec puces)
- Section « Déroulé des débats » (le plus important)
- Pied : « Fait à Dakar, le [date]. Le secrétaire : [nom] »

Boutons en haut :
- 🖨️ Partager le PV (texte brut via `Share.share()`, optionnel bonus)
- 📄 Exporter en PDF (bonus avancé avec packages `pdf` + `printing`)

### Écran 5 — Paramètres  →  route `/parametres` (bonus mais recommandé)

Écran simple où l'utilisateur peut configurer :
- **Nom du secrétaire par défaut** → `SharedPreferences`
- **Nom de l'association** → `SharedPreferences`
- **Thème** : clair / sombre → `SharedPreferences`
- **Type de réunion par défaut** → `SharedPreferences`
- Un bouton « Réinitialiser » qui supprime toutes les préférences (`prefs.clear()`)

### Récapitulatif des routes que tu dois créer

| Route | Argument | Rôle |
|---|---|---|
| `/` | aucun | Accueil — liste des réunions |
| `/nouvelle` | aucun | Formulaire de création |
| `/seance` | `reunionId: int` | Écran de séance |
| `/pv` | `reunionId: int` | Affichage du PV |
| `/parametres` | aucun | Paramètres (bonus) |

> **Passage d'arguments** — Utilise `Navigator.pushNamed(context, '/seance', arguments: 5)` puis dans l'écran cible : `final id = ModalRoute.of(context)!.settings.arguments as int;`. C'est le pattern Flutter standard.

---

## LA BASE DE DONNÉES SQLite — fournie, prête à l'emploi

Cette partie t'est **donnée entièrement**. Le modèle de données est le squelette de toute l'application : prends le temps de bien le comprendre **avant** d'écrire le moindre écran.

### Comprendre le modèle relationnel

Contrairement au TP « Contacts » du chapitre 6 (une seule table), ici on a **3 tables liées entre elles**. C'est la grande nouveauté de ce projet.

```
┌─────────────────┐
│    reunions     │   UNE réunion
│─────────────────│
│ id (PK)         │
│ titre           │
│ date_reunion    │
│ ...             │
│ statut          │
└────────┬────────┘
         │ 1
         │
         │ possède plusieurs (N)
         │
    ┌────┴──────────────────────┐
    │ N                         │ N
┌───┴──────────────┐   ┌────────┴───────────┐
│  participants    │   │   interventions    │
│──────────────────│   │────────────────────│
│ id (PK)          │   │ id (PK)            │
│ reunion_id (FK)──┼─→ │ reunion_id (FK) ───┼─→ vers reunions
│ nom              │   │ participant_id(FK)─┼─→ vers participants
│ prenom           │   │ contenu            │
│ fonction         │   │ date_intervention  │
└──────────────────┘   └────────────────────┘
```

Ce qu'il faut comprendre :
- **Une réunion** a **plusieurs participants** et **plusieurs interventions** → relation **« un à plusieurs »**
- **Une intervention** appartient à **une réunion** ET est faite par **un participant**
- Le lien se fait grâce aux **clés étrangères** (`FOREIGN KEY`)

> **Clé étrangère (`FOREIGN KEY`)** — c'est une colonne qui contient l'`id` d'une ligne d'une **autre table**. Ça crée un lien officiel entre les tables. SQLite vérifie ce lien : impossible de créer une intervention avec un `reunion_id` qui n'existe pas (à condition d'activer `PRAGMA foreign_keys = ON;`).

> **`ON DELETE CASCADE`** — si on supprime une réunion, SQLite supprime **automatiquement** tous ses participants et toutes ses interventions. Sans ça, on aurait des « orphelins ».

### Le code Dart complet du `DbHelper` — à mettre dans `lib/data/db_helper.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton pour gérer la base SQLite de l'application PV.
/// Une seule instance dans toute l'application.
class DbHelper {
  // Pattern Singleton
  static final DbHelper _instance = DbHelper._();
  factory DbHelper() => _instance;
  DbHelper._();

  // La base, ouverte une seule fois et réutilisée
  Database? _db;

  /// Getter asynchrone : retourne la base, l'ouvre si nécessaire
  Future<Database> get db async => _db ??= await _ouvrirBase();

  /// Ouvre (et crée si besoin) la base de données
  Future<Database> _ouvrirBase() async {
    final chemin = join(await getDatabasesPath(), "pv_reunion.db");
    return await openDatabase(
      chemin,
      version: 1,
      onConfigure: (db) async {
        // Active les clés étrangères (par défaut désactivées dans SQLite !)
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        // ──────────────────────────────────────────────────────
        // TABLE 1 : reunions (la table "parent")
        // ──────────────────────────────────────────────────────
        await db.execute('''
          CREATE TABLE reunions (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            titre           TEXT NOT NULL,
            date_reunion    TEXT NOT NULL,
            heure_debut     TEXT,
            lieu            TEXT,
            type_reunion    TEXT NOT NULL DEFAULT 'Ordinaire',
            ordre_du_jour   TEXT,
            president       TEXT,
            secretaire      TEXT NOT NULL,
            statut          TEXT NOT NULL DEFAULT 'en_cours',
            date_creation   TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        // ──────────────────────────────────────────────────────
        // TABLE 2 : participants (les présents)
        // ──────────────────────────────────────────────────────
        await db.execute('''
          CREATE TABLE participants (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            reunion_id  INTEGER NOT NULL,
            nom         TEXT NOT NULL,
            prenom      TEXT NOT NULL,
            fonction    TEXT,
            FOREIGN KEY (reunion_id) REFERENCES reunions(id)
              ON DELETE CASCADE
          )
        ''');

        // ──────────────────────────────────────────────────────
        // TABLE 3 : interventions (les prises de parole)
        // ──────────────────────────────────────────────────────
        await db.execute('''
          CREATE TABLE interventions (
            id                INTEGER PRIMARY KEY AUTOINCREMENT,
            reunion_id        INTEGER NOT NULL,
            participant_id    INTEGER NOT NULL,
            contenu           TEXT NOT NULL,
            date_intervention TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (reunion_id) REFERENCES reunions(id)
              ON DELETE CASCADE,
            FOREIGN KEY (participant_id) REFERENCES participants(id)
              ON DELETE CASCADE
          )
        ''');

        // ──────────────────────────────────────────────────────
        // DONNÉES DE TEST (pour ne pas démarrer avec une base vide)
        // ──────────────────────────────────────────────────────
        await db.insert("reunions", {
          "titre": "Réunion du bureau — Mai 2026",
          "date_reunion": "2026-05-15",
          "heure_debut": "18:30",
          "lieu": "Maison des associations, Yoff",
          "type_reunion": "Ordinaire",
          "ordre_du_jour":
              "1. Bilan des activités\n2. Préparation de la fête de quartier\n3. Questions diverses",
          "president": "Fatou Diop",
          "secretaire": "Moussa Sow",
          "statut": "en_cours",
        });

        // Participants de la réunion 1
        for (final p in [
          {"nom": "DIOP", "prenom": "Fatou", "fonction": "Présidente"},
          {"nom": "SOW", "prenom": "Moussa", "fonction": "Secrétaire général"},
          {"nom": "BA", "prenom": "Ibrahima", "fonction": "Trésorier"},
          {"nom": "DIALLO", "prenom": "Aminata", "fonction": "Membre"},
        ]) {
          await db.insert("participants", {"reunion_id": 1, ...p});
        }

        // Deux interventions d'exemple
        await db.insert("interventions", {
          "reunion_id": 1,
          "participant_id": 1,
          "contenu":
              "Je déclare la séance ouverte et je vous remercie de votre présence.",
        });
        await db.insert("interventions", {
          "reunion_id": 1,
          "participant_id": 3,
          "contenu":
              "Le solde du compte est positif, nous avons un excédent de 420 000 FCFA ce trimestre.",
        });
      },
    );
  }

  // ════════════════════════════════════════════════════════════
  // À TOI D'ÉCRIRE TOUTES LES MÉTHODES CRUD CI-DESSOUS
  // (signatures données pour t'aider à structurer)
  // ════════════════════════════════════════════════════════════

  // ── RÉUNIONS ──
  Future<int> ajouterReunion(Map<String, Object?> reunion) async {
    // TODO : insert dans la table reunions
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> listerReunions() async {
    // TODO : query toutes les réunions, triées par date DESC
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>?> getReunion(int id) async {
    // TODO : query une réunion par son id (ou null si introuvable)
    throw UnimplementedError();
  }

  Future<int> terminerReunion(int id) async {
    // TODO : update statut = 'terminée' WHERE id = ?
    throw UnimplementedError();
  }

  // ── PARTICIPANTS ──
  Future<int> ajouterParticipant(int reunionId, String nom, String prenom, String? fonction) async {
    // TODO : insert dans participants
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> listerParticipants(int reunionId) async {
    // TODO : query WHERE reunion_id = ?
    throw UnimplementedError();
  }

  // ── INTERVENTIONS ──
  Future<int> ajouterIntervention(int reunionId, int participantId, String contenu) async {
    // TODO : insert dans interventions
    throw UnimplementedError();
  }

  /// LA REQUÊTE LA PLUS IMPORTANTE — jointure pour le PV
  Future<List<Map<String, dynamic>>> listerInterventionsAvecParticipant(int reunionId) async {
    // TODO : rawQuery avec JOIN (voir explication ci-dessous)
    throw UnimplementedError();
  }
}
```

### La requête la PLUS importante du projet — la jointure pour le PV

Pour afficher le PV, tu dois afficher chaque intervention **avec le nom de la personne qui a parlé**. Or la table `interventions` ne contient que `participant_id` (un nombre), pas le nom..

La solution : une **jointure** (`JOIN`) qui va chercher le nom dans la table `participants`.

Avec sqflite, on utilise `rawQuery` pour les requêtes complexes :

```dart
Future<List<Map<String, dynamic>>> listerInterventionsAvecParticipant(int reunionId) async {
  final base = await db;
  return await base.rawQuery('''
    SELECT  interventions.id,
            interventions.contenu,
            interventions.date_intervention,
            participants.nom,
            participants.prenom,
            participants.fonction
    FROM    interventions
    JOIN    participants ON interventions.participant_id = participants.id
    WHERE   interventions.reunion_id = ?
    ORDER BY interventions.date_intervention ASC
  ''', [reunionId]);
}
```

> **Comment lire ce `JOIN`** — « Prends la table `interventions`, et pour chaque ligne, va chercher dans `participants` la ligne dont l'`id` correspond au `participant_id` de l'intervention, puis colle les colonnes ensemble. » Résultat : chaque ligne contient à la fois le `contenu` de l'intervention ET le `nom`/`prenom`/`fonction` du participant. Exactement ce qu'il te faut pour le PV.

> **Les `?` et le second argument** — comme avec `where: "id = ?", whereArgs: [id]` que tu as vu au chapitre 6. C'est la protection contre l'injection SQL. **Jamais** de concaténation de chaînes.

### Aide — quelles requêtes pour quel écran

| Écran / action | Méthode du DbHelper à appeler |
|---|---|
| Liste des réunions (Accueil) | `listerReunions()` |
| Créer une réunion | `ajouterReunion(map)` |
| Page séance (chargement) | `getReunion(id)` + `listerParticipants(id)` + `listerInterventionsAvecParticipant(id)` |
| Ajouter un présent | `ajouterParticipant(...)` |
| Enregistrer intervention | `ajouterIntervention(reunionId, participantId, contenu)` |
| Terminer la réunion | `terminerReunion(id)` |
| Afficher le PV | `getReunion(id)` + `listerParticipants(id)` + `listerInterventionsAvecParticipant(id)` (idem séance) |

> **Sécurité — toujours les `?`** — comme dans le chapitre 6 : **jamais** de concaténation de chaînes. Toujours les `whereArgs: [valeur]` ou les `?` dans le rawQuery. C'est la protection contre l'injection SQL.

---

## LE SERVICE DE PRÉFÉRENCES — `lib/data/prefs_service.dart`

C'est le pendant léger de `DbHelper`, pour SharedPreferences.

### Code à compléter

```dart
import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer les préférences utilisateur (paramètres simples).
/// Toutes les méthodes sont statiques pour simplifier l'usage.
class PrefService {
  // ── CLÉS (constantes pour éviter les fautes de frappe) ──
  static const _kSecretaireDefaut = "secretaire_defaut";
  static const _kAssociationNom   = "association_nom";
  static const _kThemeSombre      = "theme_sombre";
  static const _kTypeDefaut       = "type_defaut";
  static const _kPremiereOuverture = "premiere_ouverture";

  // ── SECRÉTAIRE PAR DÉFAUT ──
  static Future<String?> getSecretaireDefaut() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSecretaireDefaut);
  }

  static Future<void> setSecretaireDefaut(String nom) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSecretaireDefaut, nom);
  }

  // ── À TOI DE COMPLÉTER LES AUTRES ──
  // getAssociationNom() / setAssociationNom(String)
  // getThemeSombre() / setThemeSombre(bool)
  // getTypeDefaut() / setTypeDefaut(String)
  // getPremiereOuverture() / setPremiereOuverture(bool)
  // clearAll()  ← réinitialisation complète
}
```

> **Pourquoi des méthodes statiques ?** Parce qu'on n'a pas d'état à conserver entre les appels. À chaque appel, on récupère l'instance de `SharedPreferences`. C'est légèrement moins performant qu'un singleton (le `getInstance()` est rapide mais pas gratuit), mais c'est plus simple à utiliser depuis n'importe où.

> **Bonus pour les pros** : si tu veux optimiser, transforme `PrefService` en singleton qui garde l'instance `_prefs` en cache après le premier appel. Comme le DbHelper.

---

## LA PARTIE AUDIO — code fourni, à intégrer

Voici la partie qu'on te **donne entièrement**. La capture du micro et la transcription sont gérées par le package `speech_to_text`. **Ton travail, c'est de comprendre le widget et de le brancher** sur ton `TextEditingController`.

### Principe de fonctionnement

```
Micro de l'appareil
    ↓ (en continu pendant l'enregistrement)
Service de reconnaissance vocale du téléphone
  (Google Speech sur Android, Siri sur iOS)
    ↓ (résultats partiels au fur et à mesure)
Callback Dart `onResult(words)`
    ↓
TextEditingController du <TextField>
    ↓
SQLite (au clic du bouton "Enregistrer")
```

**Avantages de cette approche** :
- Tout se passe sur l'appareil (ou via le service Google, transparemment)
- Pas de fichier audio à gérer
- Transcription en quasi-temps réel
- Marche en français, wolof bientôt (limites du service Google)

### Le widget audio — à mettre dans `lib/widgets/widget_audio.dart`

```dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

/// Widget réutilisable de capture vocale.
/// Remplit le TextEditingController qu'on lui passe.
///
/// Utilisation :
/// ```
/// WidgetAudio(controller: _contenuCtrl)
/// ```
class WidgetAudio extends StatefulWidget {
  /// Le contrôleur qui sera rempli par la transcription
  final TextEditingController controller;

  /// Optionnel : appelé à chaque mot reconnu (pour scroll auto, etc.)
  final void Function(String texte)? onTexteChange;

  const WidgetAudio({
    super.key,
    required this.controller,
    this.onTexteChange,
  });

  @override
  State<WidgetAudio> createState() => _WidgetAudioState();
}

class _WidgetAudioState extends State<WidgetAudio> {
  final SpeechToText _speech = SpeechToText();
  bool _initialise = false;
  bool _enregistrement = false;
  String _statut = "Appuyez sur le micro pour démarrer";

  // Texte déjà confirmé (les phrases terminées)
  String _texteFinal = "";

  @override
  void initState() {
    super.initState();
    _initialiser();
  }

  /// Demande la permission micro et initialise le moteur
  Future<void> _initialiser() async {
    // 1) Demander la permission micro à l'utilisateur
    final permission = await Permission.microphone.request();
    if (permission != PermissionStatus.granted) {
      setState(() => _statut = "❌ Permission micro refusée");
      return;
    }

    // 2) Initialiser le service de reconnaissance vocale
    _initialise = await _speech.initialize(
      onError: (err) {
        setState(() => _statut = "Erreur : ${err.errorMsg}");
      },
      onStatus: (s) {
        // Quand le service revient en "notListening", on s'assure que l'UI suit
        if (s == "notListening" && _enregistrement) {
          setState(() => _enregistrement = false);
        }
      },
    );

    if (!_initialise) {
      setState(() => _statut = "❌ Reconnaissance vocale indisponible");
    } else {
      setState(() => _statut = "Prêt — appuyez sur le micro");
    }
  }

  /// Démarre l'écoute
  Future<void> _demarrer() async {
    if (!_initialise) return;

    // On garde le texte déjà présent dans le textarea
    _texteFinal = widget.controller.text.isNotEmpty
        ? "${widget.controller.text} "
        : "";

    setState(() {
      _enregistrement = true;
      _statut = "🎤 Enregistrement... parlez";
    });

    await _speech.listen(
      localeId: "fr_FR",                       // langue : français
      listenFor: const Duration(minutes: 5),   // durée max d'une session
      pauseFor: const Duration(seconds: 5),    // s'arrête après 5s de silence
      listenOptions: SpeechListenOptions(
        partialResults: true,                  // résultats au fur et à mesure
        cancelOnError: true,
      ),
      onResult: (result) {
        final reconnu = result.recognizedWords;
        // Met à jour le contrôleur avec : texte précédent + texte reconnu
        widget.controller.text = _texteFinal + reconnu;
        // Place le curseur à la fin
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
        widget.onTexteChange?.call(widget.controller.text);

        // Si c'est un résultat final, on le confirme dans _texteFinal
        if (result.finalResult) {
          _texteFinal = "${widget.controller.text} ";
        }
      },
    );
  }

  /// Arrête l'écoute
  Future<void> _arreter() async {
    await _speech.stop();
    setState(() {
      _enregistrement = false;
      _statut = "✓ Terminé — vous pouvez corriger le texte";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Bouton micro principal
              ElevatedButton.icon(
                onPressed: _initialise && !_enregistrement ? _demarrer : null,
                icon: const Icon(Icons.mic),
                label: const Text("Démarrer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),

              // Bouton stop
              ElevatedButton.icon(
                onPressed: _enregistrement ? _arreter : null,
                icon: const Icon(Icons.stop),
                label: const Text("Arrêter"),
              ),
              const SizedBox(width: 12),

              // Indicateur visuel pendant l'enregistrement
              if (_enregistrement)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _statut,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Comment l'utiliser dans ton écran séance

C'est le **seul point d'intégration**. Tu crées un `TextEditingController` dans ton State, tu le passes au widget audio, et tu lis sa valeur au moment d'enregistrer l'intervention :

```dart
class _SeanceScreenState extends State<SeanceScreen> {
  final TextEditingController _contenuCtrl = TextEditingController();
  int? _participantSelectionneId;

  @override
  void dispose() {
    _contenuCtrl.dispose();   // ← N'OUBLIE PAS (chapitre 4 !)
    super.dispose();
  }

  Future<void> _enregistrerIntervention() async {
    // 1. Vérifier la sélection
    if (_participantSelectionneId == null) return;
    if (_contenuCtrl.text.trim().isEmpty) return;

    // 2. Insérer en base
    await DbHelper().ajouterIntervention(
      widget.reunionId,
      _participantSelectionneId!,
      _contenuCtrl.text.trim(),
    );

    // 3. Vider et recharger
    setState(() {
      _contenuCtrl.clear();
      _participantSelectionneId = null;
    });
    _rechargerInterventions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: Column(
        children: [
          // ...
          DropdownButton<int>(
            value: _participantSelectionneId,
            hint: const Text("Qui prend la parole ?"),
            items: /* ... liste des présents ... */,
            onChanged: (val) => setState(() => _participantSelectionneId = val),
          ),

          // 👇 LE WIDGET AUDIO — on lui passe juste le controller
          WidgetAudio(controller: _contenuCtrl),

          // 👇 Le textarea, lié au même controller
          TextField(
            controller: _contenuCtrl,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Transcription",
              hintText: "Le texte dicté apparaîtra ici",
              border: OutlineInputBorder(),
            ),
          ),

          ElevatedButton.icon(
            onPressed: _enregistrerIntervention,
            icon: const Icon(Icons.send),
            label: const Text("Enregistrer l'intervention"),
          ),
        ],
      ),
    );
  }
}
```

> **L'idée clé** : le widget audio **ne sait rien de SQLite**. Il remplit juste un `TextEditingController`. Quand tu cliques sur « Enregistrer », tu lis `_contenuCtrl.text` exactement comme s'il avait été tapé au clavier. **Pour SQLite, peu importe d'où vient le texte** — micro ou clavier — c'est un `String` comme un autre.

### Permissions runtime (déjà géré dans le widget)

Le widget gère lui-même la demande de permission micro à la première utilisation, via `permission_handler`. L'utilisateur verra le pop-up système Android/iOS « Cette app souhaite accéder au micro ».

> **Si la permission est refusée**, le widget affiche un message d'erreur. À toi de gérer ce cas (par exemple, en proposant un `TextField` classique sans micro).

---

## LA DÉMARCHE CONSEILLÉE — dans quel ordre travailler

Ne te jette pas sur le code. Suis cet ordre, et **teste après chaque étape**. Comme dans les TPs du cours, **une étape = un test**.

```
1.  Créer le projet Flutter + ajouter les dépendances dans pubspec.yaml
        ↓
2.  Configurer les permissions Android (et iOS si concerné)
        ↓
3.  Écrire db_helper.dart minimal (singleton + onCreate)
    -> tester en ouvrant la base au démarrage de l'app
    -> ouvrir le fichier .db avec DB Browser pour SQLite (extérieur à l'app)
    -> vérifier que les 3 tables existent
        ↓
4.  Implémenter listerReunions() dans DbHelper
        ↓
5.  Coder AccueilScreen avec ListView + Card statique d'abord
    -> brancher sur listerReunions() avec un FutureBuilder ou initState
        ↓
6.  Coder NouvelleReunionScreen avec Form + GlobalKey + validators
    -> ajouterReunion() dans DbHelper -> Navigator.pushReplacementNamed
    -> tester création et retour vers Accueil
        ↓
7.  Coder SeanceScreen MINIMAL (juste header + liste vide)
    -> getReunion(id) au initState
        ↓
8.  Ajouter la zone "présents" : listerParticipants() + ajouterParticipant()
    -> tester l'ajout d'un présent
        ↓
9.  Intégrer le widget audio (FOURNI) dans seance_screen.dart
    -> vérifier que la transcription se remplit quand on parle
    -> tester sur un VRAI appareil (l'émulateur a parfois des soucis micro)
        ↓
10. Implémenter ajouterIntervention() + l'enregistrement depuis l'écran
    -> tester une prise de parole complète
        ↓
11. Implémenter listerInterventionsAvecParticipant() (JOIN)
    -> afficher le déroulé sur la page séance
        ↓
12. terminerReunion() + bouton "Réunion terminée" + désactivation des formulaires
        ↓
13. Coder PvScreen (le procès-verbal final)
    -> mise en forme propre, sections claires
        ↓
14. Ajouter PrefService et son utilisation :
    -> pré-remplir le nom du secrétaire
    -> nom de l'association sur le PV
    -> écran Paramètres (bonus)
        ↓
15. Finitions UX : badges de statut colorés, animations, message "aucune réunion",
    gestion d'erreurs, page 404 si reunionId invalide
        ↓
16. Tests complets + passer la checklist
```

> **Le piège classique** — vouloir tout faire d'un coup. Si tu écris 5 écrans et le DbHelper complet avant de tester, et que ça plante, tu ne sauras jamais d'où vient l'erreur. **Une étape = un test sur appareil.**

> **Conseil sur la table `interventions`** — c'est la seule qui dépend de DEUX autres tables. Ne t'en occupe qu'à l'étape 10, quand `reunions` et `participants` fonctionnent déjà et que tu as de vraies données à lier.

> **Conseil sur le widget audio** — Teste-le **isolément** d'abord. Crée une page de test avec juste le widget et un `TextField`, vérifie que ça marche, ENSUITE intègre-le dans `seance_screen.dart`. Ça évite d'avoir 3 sources de bug en même temps.

---

## CHECKLIST DE VALIDATION

Coche tout avant de rendre le projet :

```
STRUCTURE
□ Dossier pv_reunion/ créé avec flutter create
□ pubspec.yaml contient sqflite, path, shared_preferences, speech_to_text,
  permission_handler, intl
□ AndroidManifest.xml contient RECORD_AUDIO
□ Architecture en couches : data/, models/ (optionnel), screens/, widgets/

BASE DE DONNÉES SQLITE
□ Les 3 tables (reunions, participants, interventions) sont créées au premier
  lancement
□ PRAGMA foreign_keys = ON est activé
□ Les clés étrangères fonctionnent (impossible d'insérer un participant_id
  inexistant)
□ Les données de test apparaissent au premier lancement

PRÉFÉRENCES (SharedPreferences)
□ Le nom du secrétaire est sauvegardé après la 1ère création de réunion
□ Le nom du secrétaire pré-remplit le formulaire des réunions suivantes
□ Le nom de l'association apparaît sur le PV
□ (bonus) écran Paramètres fonctionnel

ÉCRAN ACCUEIL
□ Liste de toutes les réunions affichée
□ Triée par date décroissante
□ Badge de statut coloré (en_cours = vert/orange, terminée = bleu/gris)
□ Cas "aucune réunion" géré (message centré)
□ FAB "+" ouvre l'écran de création

CRÉATION DE RÉUNION
□ Tous les champs (section A) sont présents
□ DatePicker fonctionne pour la date
□ TimePicker fonctionne pour l'heure
□ DropdownButtonFormField pour le type
□ Validation : titre, date, type, secrétaire obligatoires
□ Soumettre sans titre/date/secrétaire -> erreurs sous les champs (validator)
□ Après création -> redirection vers l'écran de séance (pushReplacementNamed)
□ La nouvelle réunion a bien le statut "en_cours"

GESTION DES PRÉSENTS
□ Mini-formulaire d'ajout (nom + prénom + fonction + bouton +)
□ Validation : nom et prénom requis
□ Le présent ajouté apparaît dans la liste ET dans le DropdownButton
□ Les TextEditingController sont disposés

PARTIE AUDIO
□ Le bouton "Démarrer" demande la permission micro au premier usage
□ Quand on parle, le texte apparaît progressivement dans le TextField
□ On peut corriger le texte transcrit manuellement
□ Le bouton "Arrêter" stoppe l'écoute
□ Si on appuie sur "Démarrer" plusieurs fois, le texte précédent est conservé

ENREGISTRER UNE INTERVENTION
□ Validation : participant sélectionné + texte non vide
□ Insertion en base avec les bons IDs
□ L'intervention apparaît immédiatement dans le déroulé (setState)
□ Le DropdownButton et le TextField sont remis à zéro après l'enregistrement
□ Le déroulé est dans l'ordre chronologique (ORDER BY date_intervention)
□ Chaque intervention affiche le BON nom de participant (JOIN qui fonctionne)

CLÔTURE ET PV
□ Bouton "Réunion terminée" demande confirmation (AlertDialog)
□ Une fois terminée, on ne peut plus ajouter d'intervention ni de présent
  (formulaires masqués ou désactivés)
□ Le PV affiche : en-tête, ordre du jour (si présent), présents, déroulé
□ Le statut s'affiche en badge
□ (bonus) Bouton de partage du PV en texte

ROBUSTESSE
□ Toutes les requêtes SQL utilisent ? + whereArgs (pas de concaténation)
□ Chaque TextEditingController est disposé dans dispose()
□ Navigation cohérente : retour fonctionnel partout
□ Pas de plantage si la base est vide
□ Pas de plantage si on tape un id inexistant
□ Pas de FutureBuilder qui clignote (utiliser des indicateurs de chargement)

CODE QUALITÉ
□ Aucun warning rouge dans la console au lancement
□ Aucun "TODO" oublié
□ Constantes de couleur centralisées (au moins teal + pink + couleurs status)
□ Code formaté (dart format .)
□ Pas de imports inutilisés
```

---

## BONUS — pour aller plus loin (optionnel)

| Fonctionnalité | Apprentissage visé |
|---|---|
| **Supprimer une réunion** | `db.delete` + tester que le CASCADE supprime aussi participants et interventions |
| **Modifier une intervention** | Le texte transcrit est imparfait → écran d'édition + `db.update` |
| **Marquer un présent absent/excusé** | Colonne `present BOOLEAN` + UPDATE + affichage différencié |
| **Compter les prises de parole par personne** | `COUNT(*) GROUP BY participant_id` → page « statistiques de la réunion » |
| **Export du PV en PDF** | Packages `pdf` + `printing` → vrai PDF partageable via WhatsApp |
| **Recherche de réunion** | `TextField` + `query` avec `WHERE titre LIKE ?` |
| **Partage texte du PV** | Package `share_plus` + génération d'un String formaté |
| **Thème sombre/clair** | `ThemeData` dynamique + persistance dans SharedPreferences |
| **Page de stats globale** | « 12 réunions tenues cette année · 47 interventions au total » |
| **Affichage de la durée d'enregistrement** | `Timer.periodic` + affichage mm:ss pendant l'enregistrement |
| **Animation d'onde sonore** | Affichage visuel pendant que l'utilisateur parle |
| **Snackbar de confirmation** | « ✓ Intervention enregistrée » après chaque sauvegarde |

---

## Conseils anti-blocage

**Lis l'erreur Flutter en entier** — la console de VS Code affiche le fichier, la ligne et la nature de l'erreur. Ne ferme pas l'erreur, lis-la.

**Erreur `DatabaseException: FOREIGN KEY constraint failed`** — tu essaies d'insérer une intervention avec un `reunion_id` ou un `participant_id` qui n'existe pas. Vérifie les IDs que tu passes. C'est la signe que ton CASCADE fonctionne bien.

**Erreur `LateInitializationError`** — tu utilises une variable `late` avant son initialisation. Souvent un controller qui n'a pas été créé avant le `build()`.

**`MissingPluginException` au lancement** — Tu as ajouté un package au `pubspec.yaml` mais oublié `flutter pub get`. Ou tu n'as pas redémarré l'app à froid (`flutter run` au lieu de hot reload).

**Le widget audio ne marche pas sur l'émulateur Android** — Les émulateurs ont parfois des problèmes avec le micro. **Teste sur un vrai téléphone** branché en USB avec le mode développeur activé.

**Le widget audio se ferme tout seul après quelques secondes** — Le service de reconnaissance s'arrête après une pause longue. C'est normal. Le widget affiche « ✓ Terminé », appuie à nouveau sur démarrer pour continuer.

**Erreur `Bad state: No element` dans le DropdownButton** — Tu as un `value` qui ne correspond à aucun `item`. Soit ta liste de présents est vide, soit le participant sélectionné a été supprimé.

**Le `setState()` ne met pas à jour l'écran** — Vérifie que ton appel `setState` modifie bien une variable du `State` (pas une variable locale). Et qu'il est dans un `StatefulWidget`, pas un `StatelessWidget`.

**`Future<List<Map>>` mais le ListView affiche rien** — Tu as oublié `await` quelque part, donc tu manipules le `Future` au lieu de la liste. Active le linter Dart pour qu'il te le signale.

**Ne copie jamais sans comprendre** — pour le code audio qu'on te donne : lis-le, reformule à voix haute ce que fait chaque bloc. Si tu ne peux pas l'expliquer, tu ne pourras pas le débugger.

---

## Ressources

| Sujet | Lien |
|---|---|
| Documentation Flutter | https://docs.flutter.dev/ |
| Package sqflite | https://pub.dev/packages/sqflite |
| Package shared_preferences | https://pub.dev/packages/shared_preferences |
| Package speech_to_text | https://pub.dev/packages/speech_to_text |
| Package permission_handler | https://pub.dev/packages/permission_handler |
| SQL — les jointures (JOIN) | https://www.w3schools.com/sql/sql_join.asp |
| DB Browser pour SQLite (outil de visualisation) | https://sqlitebrowser.org/ |
| Material 3 — Composants | https://m3.material.io/components |
| Formatage de dates avec intl | https://pub.dev/packages/intl |
| Package pdf (bonus) | https://pub.dev/packages/pdf |

---

## Mémo des patterns utilisés (rappels rapides)

### Singleton (DbHelper)
```dart
class DbHelper {
  static final DbHelper _instance = DbHelper._();
  factory DbHelper() => _instance;
  DbHelper._();
}
// Usage : DbHelper().listerReunions();
```

### FutureBuilder pour afficher des données async
```dart
FutureBuilder<List<Map<String, dynamic>>>(
  future: DbHelper().listerReunions(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text("Aucune réunion");
    }
    final reunions = snapshot.data!;
    return ListView.builder(
      itemCount: reunions.length,
      itemBuilder: (_, i) => /* ... */,
    );
  },
)
```

### Recharger une liste après une action
```dart
// Solution 1 : variable d'état + setState
List<Map<String, dynamic>> _reunions = [];

Future<void> _charger() async {
  final liste = await DbHelper().listerReunions();
  setState(() => _reunions = liste);
}

@override
void initState() {
  super.initState();
  _charger();
}

// Après une action : await _charger();
```

### Navigation avec argument
```dart
// Envoyer
Navigator.pushNamed(context, '/seance', arguments: reunionId);

// Recevoir
final reunionId = ModalRoute.of(context)!.settings.arguments as int;
```

### Dialogue de confirmation
```dart
Future<bool> _confirmer(BuildContext context, String message) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Confirmer"),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(_, false), child: const Text("Annuler")),
        ElevatedButton(onPressed: () => Navigator.pop(_, true), child: const Text("Oui")),
      ],
    ),
  );
  return ok ?? false;
}
```

### Format de date en français
```dart
import 'package:intl/intl.dart';

final maintenant = DateTime.now();
final formate = DateFormat("dd MMMM yyyy", "fr_FR").format(maintenant);
// "27 juin 2026"
```

---

*Projet d'évaluation — Formation Développement Mobile Flutter — fait suite aux chapitres 4 (Stateful), 5 (Formulaires) et 6 (Persistance locale)*
*Technologies : Flutter · SQLite (sqflite) · SharedPreferences · speech_to_text · Material 3*
*Auteur : Libasse THIAM — Wommate Technology — www.wommate.tech*
