#!/bin/bash

# Get the system language
lang=$(locale | grep LANG= | cut -d= -f2 | cut -d_ -f1)

# Define the path to the .nemo_action file
action_file="./remove_bg.nemo_action"
script_file="./remove_bg.sh"

# Check the system language and modify the .nemo_action file accordingly
if [ "$lang" == "de" ]; then
	# German translations
	name="Hintergrund entfernen"
	comment="Entfernt den Hintergrund eines Bildes"
	notify_s="Hintergrund erfolgreich entfernt"
	notify_u="Fehler beim Entfernen des Hintergrunds"
	proceed_prompt="Dieses Skript wird jetzt rembg und seine Abhängigkeiten installieren. \nPakete: rembg, filetype, watchdog, aiohttp, gradio, asyncer \nFortfahren? (ja/nein)"
	no_response_error="\nFehler: Keine Eingabe erkannt"
	invalid_response="Ungültige Eingabe"
	proceeding="Installation wird fortgesetzt..."
	exiting="Beenden..."
	already_installed="ist bereits installiert"
	not_installed="ist nicht installiert. Installation..."
elif [ "$lang" == "fr" ]; then
	# French translations
	name="Supprimer l'arrière-plan"
	comment="Supprime l'arrière-plan d'une image"
	notify_s="Arrière-plan supprimé avec succès"
	notify_u="Erreur lors de la suppression de l'arrière-plan"
	proceed_prompt="Ce script va maintenant installer rembg et ses dépendances. \nPaquets: rembg, filetype, watchdog, aiohttp, gradio, asyncer \nContinuer? (oui/non)"
	no_response_error="\nErreur: aucune réponse détectée"
	invalid_response="Réponse invalide"
	proceeding="Ok, on continue..."
	exiting="Sortie..."
	already_installed="est déjà installé"
	not_installed="n'est pas installé. Installation..."
else
	# Default to English
	name="Remove Background"
	comment="Removes the background of an image"
	notify_s="Background successfully removed"
	notify_u="Error removing background"
	proceed_prompt="This script will now install rembg and its dependecies. \nPackages: rembg, filetype, watchdog, aiohttp, gradio, asyncer \nProceed? (yes/no)"
	no_response_error="\nerror: no response detected"
	invalid_response="invalid response"
	proceeding="ok, proceeding"
	exiting="exiting..."
	already_installed="is already installed"
	not_installed="is not installed. Installing..."
fi

# Update the .nemo_action file
sed -i "s/^Name=.*/Name=$name/" $action_file
sed -i "s/^Comment=.*/Comment=$comment/" $action_file

# Update the script
sed -i "s/SUCCESS/$notify_s/" $script_file
sed -i "s/ERROR/$notify_u/" $script_file

# Prompt for the User before installing anyting. Timeout 10s
echo -e "$proceed_prompt"
read -t 10 yn

# If an empty response is detected, exit
if [ -z "$yn" ]; then
	echo -e "$no_response_error"
	exit 1
fi

# If a response is detected, proceed if the response was yes, otherwise exit
case $yn in 
	yes|ja|oui) echo $proceeding;;
	no|nein|non) echo $exiting;
		exit;;
	*) echo $invalid_response;
		exit 1;;
esac

# List of packages to check and install
packages=("rembg" "filetype" "watchdog" "aiohttp" "gradio" "asyncer")

for package in "${packages[@]}"
do
	if python3 -c "import $package" &> /dev/null; then
		echo "$package $already_installed"
	else
		echo "$package $not_installed"
		pip3 install --user $package
	fi
done

# Copy the necessary files to ~/.local/share/nemo/actions
cp ./remove_bg.sh ~/.local/share/nemo/actions/
cp ./remove_bg.nemo_action ~/.local/share/nemo/actions/

# make the script executable
chmod +x ~/.local/share/nemo/actions/remove_bg.sh
