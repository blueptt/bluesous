<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Machine à sous 777</title>
    <style>
        body {
            background-color: #ffccdd; /* Plus rose */
            text-align: center;
            font-family: 'Comic Sans MS', cursive, sans-serif;
        }

        h1 {
            color: #ff69b4;
            margin-bottom: 20px;
        }

        .slot-machine {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .machine-frame {
            display: flex;
            border: 5px solid #ff69b4;
            border-radius: 15px;
            padding: 10px;
            background-color: #fff;
        }

        .reel {
            width: 100px;
            height: 100px;
            background-color: #fff;
            border: 3px solid #ff69b4;
            font-size: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            border-radius: 10px;
            animation: spin 1s ease-in-out infinite;
        }

        .reel.stopped {
            animation: none;
        }

        @keyframes spin {
            0% { transform: rotateX(0deg); }
            100% { transform: rotateX(360deg); }
        }

        button {
            font-size: 18px;
            padding: 10px;
            background-color: #ff69b4;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 8px;
        }

        button:hover {
            background-color: #ff1493;
        }

        .score {
            font-size: 20px;
            margin: 20px;
        }

        .jackpot {
            font-size: 20px;
            margin: 20px;
            color: #ff69b4;
        }

        .message {
            font-size: 24px;
            color: #ff69b4;
            margin-top: 20px;
        }

        #confetti-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            pointer-events: none;
            display: none;
        }

        .confetti {
            position: absolute;
            width: 20px;
            height: 20px;
            font-size: 30px;
            animation: fall linear infinite;
        }

        @keyframes fall {
            0% { transform: translateY(-100vh); }
            100% { transform: translateY(100vh); }
        }
    </style>
</head>
<body>
    <h1>Machine à sous 777</h1>
    <div class="slot-machine">
        <div class="machine-frame">
            <div id="reel1" class="reel">?</div>
            <div id="reel2" class="reel">?</div>
            <div id="reel3" class="reel">?</div>
        </div>
    </div>
    <button id="spinButton">Tourner</button>
    <div class="score">
        <span>Score: <span id="score">0</span></span>
    </div>
    <div id="message" class="message"></div>
    <button onclick="restartGame()">Recommencer</button>
    <div id="confetti-container"></div>
    <div class="jackpot">Cagnotte: <span id="jackpot">0.00</span> €</div>
    <script>
        const reel1 = document.getElementById('reel1');
        const reel2 = document.getElementById('reel2');
        const reel3 = document.getElementById('reel3');
        const spinButton = document.getElementById('spinButton');
        const scoreElement = document.getElementById('score');
        const messageElement = document.getElementById('message');
        const confettiContainer = document.getElementById('confetti-container');
        const jackpotElement = document.getElementById('jackpot');

        let score = 0;
        let jackpot = parseFloat(localStorage.getItem('jackpot')) || 0; // Cagnotte persistante
        let isSpinning = false;
        let spinsCount = 0; // Compteur de tours
        const symbols = ['7️⃣', '🍒', '⭐', '🍋', '🍇', '🍍']; // Symboles de la machine

        spinButton.addEventListener('click', () => {
            if (!isSpinning) {
                isSpinning = true;
                messageElement.textContent = '';
                reel1.classList.remove('stopped');
                reel2.classList.remove('stopped');
                reel3.classList.remove('stopped');

                // Démarrer les animations de rotation
                setTimeout(() => stopReel(reel1), 1000);
                setTimeout(() => stopReel(reel2), 2000);
                setTimeout(() => {
                    stopReel(reel3);
                    isSpinning = false;
                    spinsCount++;
                    checkWin(reel1.textContent, reel2.textContent, reel3.textContent);
                }, 3000);
            }
        });

        function stopReel(reel) {
            let result;
            // Déterminer le résultat
            const winChance = Math.random(); // Tirage aléatoire pour déterminer si c'est une victoire
            if (winChance < 0.3) { // 30% de chances de gagner
                result = '7️⃣'; // Gagner "777"
            } else if (winChance < 0.6) { // 30% de chances de gagner un fruit
                result = symbols[Math.floor(Math.random() * symbols.length - 1) + 1]; // Choisir un fruit aléatoire
            } else {
                result = symbols[Math.floor(Math.random() * symbols.length)];
            }
            reel.textContent = result;
            reel.classList.add('stopped');
        }

        function restartGame() {
            score = 0; // Réinitialiser le score
            spinsCount = 0; // Réinitialiser le compteur de tours
            reel1.textContent = '?';
            reel2.textContent = '?';
            reel3.textContent = '?';
            scoreElement.textContent = score;
            jackpotElement.textContent = jackpot.toFixed(2);
            messageElement.textContent = '';
            confettiContainer.style.display = 'none'; // Cacher les confettis
        }

        function checkWin(symbol1, symbol2, symbol3) {
            // Vérifier si tous les symboles sont identiques
            if (symbol1 === symbol2 && symbol2 === symbol3) {
                if (symbol1 === '7️⃣') {
                    jackpot += 0.10; // Ajouter 10 centimes à la cagnotte
                    messageElement.innerHTML = '<span style="font-size: 36px; font-weight: bold;">Bravo ma pepette ! 🎉</span>';
                    launchConfetti();
                } else {
                    jackpot += 0.05; // Ajouter 5 centimes à la cagnotte
                    messageElement.innerHTML = '<span style="font-size: 36px; font-weight: bold;">Gagné ! 🎉</span>';
                    launchConfetti();
                }
            } else {
                messageElement.textContent = 'Dommage bb, réessaie !';
            }

            // Sauvegarder la cagnotte
            localStorage.setItem('jackpot', jackpot);

            // Ajouter la cagnotte au score
            jackpotElement.textContent = jackpot.toFixed(2);
            scoreElement.textContent = (score + jackpot).toFixed(2);
        }

        function launchConfetti() {
            confettiContainer.innerHTML = ''; // Effacer les confettis précédents
            confettiContainer.style.display = 'block';
            for (let i = 0; i < 100; i++) {
                const confetti = document.createElement('div');
                confetti.classList.add('confetti');
                confetti.textContent = '🎉';
                confetti.style.left = `${Math.random() * 100}vw`;
                confetti.style.animationDuration = `${Math.random() * 3 + 2}s`;
                confettiContainer.appendChild(confetti);
            }

            setTimeout(() => {
                confettiContainer.style.display = 'none';
            }, 4000); // Les confettis disparaissent après 4 secondes
        }
    </script>
</body>
</html>
