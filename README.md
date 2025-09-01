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

Prérequis : Xcode.

Installer **Flutter** en suivant le [tutoriel officiel](https://docs.flutter.dev/install)

**Important: pensez à ajouter Flutter au PATH de votre système.**

Vérifier que l'installation est correcte : 

```bash
flutter doctor
```

Corriger les éventuelles erreurs affichées.

### Récupération du projet

Cloner le repository :

```bash
git clone URL
cd repo
```

### Installation des dépendances

Cela se fait automatiquement au lancement du fichier `main.dart`, cependant il est possible de le faire manuellement :

```bash
flutter pub get 
```

### Lancement du projet

Sur Visual Studio Code, en bas à droite de l'écran, vous pouvez sélectionner sur quel appareil vous souhaitez démarrer l'application.

Sélectionner `Start IOS simulator`.

Ensuite, en exécutant le fichier `main.dart`, l'application sera démarrée sur l'appareil sélectionné précédemment.
