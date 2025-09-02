# Ferum mobile app

## Page accueil

Compteur de nombre de séance pas semaine
Compteur distance effectuée ?
Séances de la semaine
Score d’entrainement 

## Page entrainement

Le calendrier avec la séance du jour sélectionné comme dans Figma

Créer son entrainement :
Sélectionner Sport voir objectif dans docs entrainement.
Mettre jours disponible pour les séances
Sélectionner l’échéance

Page qui va à mesure (avec barre progression)
Sélection sport + distance
Sélection jours
Sélections tranche horaire
Proposition mettre historique (entrée manuelle)



## Page profil

## Getting Started

Ce document explique les étapes nécessaires afin de rejoindre l’équipe de développement mobile et de lancer l’application Flutter localement.

### Git workflow

Dans ce projet, le git workflow utilisé consiste à créer une branche pour chaque nouvelle fonctionnalité implémentée en suivant la nomenclature `feature/XXX`. 

Un fois la fonctionnalité terminée :
1. Créer une **pull request** vers la branche develop.
2. Demander une review avant merge.

### Installation de l'environnement de développement

#### Téléchargement des logiciels prérequis

Installer **Xcode**.

```bash
xcode-select --install
```

Puis, accepter les licences.

```bash
sudo xcodebuild -license
```

Télécharger **Visual Studio Code** et ajouter l'extension **Flutter**.

Installer **CocoaPods** (gestionnaire de dépendances IOS).

```bash
sudo gem install cocoapods
# ou
brew install cocoapods
```

Si vous êtes sur un Mac **Apple Silicon (ARM)**, installer Rosetta.

```bash
sudo softwareupdate --install-rosetta --agree-to-license
```

#### Installation et mise en place de Flutter

Installer **Flutter** en suivant le [tutoriel officiel](https://docs.flutter.dev/install/with-vs-code#install-flutter)

**Important: pensez à ajouter Flutter au PATH de votre système.**

Vérifier l'installation : 

```bash
flutter doctor
```

Corriger les éventuelles erreurs affichées.

### Mise en place de l'environnement de développement IOS

Installer le simulateur IOS.

```bash
xcodebuild -downloadPlatform iOS
```

Documentation : [tutoriel officiel](https://docs.flutter.dev/platform-integration/ios/setup#set-up-tooling).

### Récupération du projet

Cloner le repository et se déplacer dans le dossier.

```bash
git clone URL
cd repo
```

### Installation des dépendances

Cela se fait automatiquement lors du lancement de `main.dart`.
Cependant, vous pouvez le faire manuellement:

```bash
flutter pub get 
```

### Lancement du projet

Depuis VS Code :
- En bas à droite de l'écran, choisir l'appareil cible (Start iOS Simulator).
- Exécuter le fichier main.dart

Depuis le terminal :

```bash
flutter run
```

### Dépannage (tips rapides)

Si le build échoue après modification des dépendances :

```bash
flutter clean
flutter pub get
```

Si CocoaPods manque dans iOS :

```bash
cd ios
pod install
```

Si le simulateur ne démarre pas :

```bash
open -a Simulator
```
