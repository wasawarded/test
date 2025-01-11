# Ce fichier est consacré aux suivis du projet
## 18/12/2024
### text anglais
- Transformer les textes dumps non utf-8 en utf-8 : curl permet de récupérer à la fois les métadonnées et les textes, avec l'option -o on peut les enregistrer dans notre ordinateur, puis utiliser lynx to récupérer les informations qui nous intéressent avec les html récupérés, au lieu de naviguer encore une fois avec les urls
- la fonction de lynx avec option -o. syntave lynx -f xx -t xx path -o path pas à mélanger avec les `< >`
- la fonction de curl avec l'option -o, cette option va sauvegarder tout ce que le curl a récupéré au début, si par exemple, on veut les entếtes l'expression soit curl -i -o path, si on ne veut pas, curl -o path
- Création des folders et les textes vides
- n'oublie pas de mettre les suffixes après les file html, sinon navigateur comme lynx ne peut pas reconnaitre qu'il s'agit d'un fichier html
- pour 18/12/2024 : fini de script pour lire les url, récupère les codes http  et enregistre les dump files en anglais
- en dump 80, ce fichier est en forma pdf
## 24/12/2024
### anglais
- Pour le tableau, j'ai pas compris quelle sera sa structure 
- commence le comptage du mot logic pour chaque page. fini le script comptage 
- attention à la syntaxe de grep : `grep -e pattern path`, après -e ce qui suit doit être le pattern, si on écrit `grep -e -o pattern path`, on aura une erreur
- pour chercher les lignes : `grep -x`, -x signifie line regexp. Option `-A=` permet de délimiter combien de lignes arpès notre pattern, et `-B=` signigie avant. 
- pour 24/12/2024 fini de contexte script et de comptage script, pour construire les concordances, il faut suivre le pals exercice
## 26/12/2024
### anglais
- création des contextes en html
- création de script pour générer les concordance en html, pour le sed, j'ai pas très bien compris sa fonction
- création de tableaux mais pour les liens contexte et les liens Concordances, ce sont les liens locaux, les autres ne peuvent pas y avoir access

## Du 23/12/2024 au 28/12/2024
### Arabe et Français

    - Récupération des URLs et uniformisation des contenus des pages en arabe et en français.
    - Création de scripts Bash pour le traitement des deux langues.
    - Analyse textométrique des fichiers dumps à l'aide de Voyant Tools (génération de nuages de mots, graphes, collocations, etc.), avec tentative d'intégration de ces résultats dans les sections dédiées à l'arabe et au français.
    - Développement du script make_pals_corpus.sh pour la tokenisation des fichiers dumps et des fichiers contextuels. Cependant, un doute subsiste car les instructions de l'exercice semblent indiquer l'utilisation de fichiers Python, tandis que mon script génère des fichiers au format TXT.
    - Création d'un fichier HTML pour intégrer les données partagées, sous réserve de validation par les autres membres du groupe.
    - Réflexion sur la présentation du site afin de concilier ergonomie, utilité et esthétique.

## Du 28/12/2024 au 29/12/2024
### Arabe et Français

- Réogranisatioin du dépôt afin de respecter l'aoborescence demandé dans les exercices;
- Verification de l'exactitude de mon travail;
- Gestion de conflis git; ce que je trouve le plus dificile à faire algré la simplicité de la tâche; 

## 30/12/2024
### anglais
- la tokenization de dump et de contexte, création du script make pals
- problèmes : au début j'ai récupéré plus de 50 url et j'ai fais les dumps et les contextes mais sur le tableaux je n'utilise que 50, il faut que je modifie les dumps et les contextes ainsi que leur html

## Du 25/12/2024 au 31/12/2024
### chinois
- Création de scripts shell pour sauvegarder le contenu des URL en chinois sous forme de dump-text et d’aspiration 
- Extraction d’informations (comme les codes HTTP) à partir des scripts, sauvegarde dans un fichier CSV et conversion en tableau HTML 
- Modification d’un script Python fourni par le professeur pour effectuer la segmentation des textes chinois et segmentation de tout le contenu 
- Analyse des textes segmentés pour calculer la fréquence des mots et créer un document de contexte 
- Développement d’un script pour établir des concordances 
- Implémentation d’un script pour la PALS (Pattern Analysis and Linguistic Search) 

## 07/01/2025
### anglais
- Réunion de groupe pour résoudre les problèmes de structure et discuter sur la philosophie de notre page groupe, les possible d'outils d'analyse de textométrie comme worldcloud.
- Réger les liens absolus en relatifs. **attention** Pour utiliser les liens relatifs `..`, il faut assurer que le fichier ne se situe pas dans un sous dossier d'un dossier. Sinon il faut ajouter des `.`

## 08/01/2025
### anglais
- Création du dossier sites_groupe pour mettre les html et les css pour la page groupe

## 11/01/2025
### anglais
- fini des html ainsi les redirections. Pour notre page chaque langue a un index.html qui propose de naviguer dans les langues différentes à travers la navigation langues, et si l'utilisateur clique Acceuil, il va être redirigé vers la page de la langue correspondante, par défaut, notre site affiche la langue française. Cette séparation de langue a le but de faciliter les travaux et d'éviter des conflits de chemins.
