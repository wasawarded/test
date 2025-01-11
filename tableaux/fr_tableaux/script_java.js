// Textes de contexte simulés
const contextData = {
    logique_français-1-context.txt:
};

// Fonction pour surligner les mots dans le texte
function highlightText(text, words) {
    const regex = new RegExp(`\\b(${words.join('|')})\\b`, 'gi');
    return text.replace(regex, '<mark>$1</mark>');
}

// Gestion des clics sur les liens "Contexte"
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.context-link').forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            const contextKey = link.dataset.context;
            const contextText = contextData[contextKey] || 'Aucun contexte trouvé.';

            // Mots à surligner
            const wordsToHighlight = ['logique', 'Logique', 'logiques', 'Logiques'];

            // Surligner les mots dans le texte
            const highlightedText = highlightText(contextText, wordsToHighlight);

            // Afficher le texte avec surlignage
            const contextDisplay = document.getElementById('context-display');
            const contextTextDiv = document.getElementById('context-text');
            contextTextDiv.innerHTML = highlightedText;
            contextDisplay.style.display = 'block';
        });
    });
});
