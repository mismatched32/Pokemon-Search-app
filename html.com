<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pokémon Search App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        #search-input {
            width: 50%;
            height: 30px;
            font-size: 18px;
            padding: 10px;
            margin: 20px;
        }
        #search-button {
            width: 20%;
            height: 30px;
            font-size: 18px;
            padding: 10px;
            margin: 20px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        #search-button:hover {
            background-color: #3e8e41;
        }
        #pokemon-info {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        #pokemon-info > * {
            margin: 10px;
        }
        #sprite {
            width: 100px;
            height: 100px;
        }
        #types {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        #types > * {
            margin: 5px;
            padding: 5px;
            border-radius: 5px;
            background-color: #4CAF50;
            color: #fff;
        }
    </style>
</head>
<body>
    <h1>Pokémon Search App</h1>
    <input id="search-input" type="text" placeholder="Search by name or ID">
    <button id="search-button">Search</button>
    <div id="pokemon-info">
        <h2 id="pokemon-name"></h2>
        <p id="pokemon-id"></p>
        <p id="weight"></p>
        <p id="height"></p>
        <p id="hp"></p>
        <p id="attack"></p>
        <p id="defense"></p>
        <p id="special-attack"></p>
        <p id="special-defense"></p>
        <p id="speed"></p>
        <div id="types"></div>
        <img id="sprite" src="" alt="Pokémon sprite">
    </div>

    <script>
        const searchInput = document.getElementById('search-input');
        const searchButton = document.getElementById('search-button');
        const pokemonName = document.getElementById('pokemon-name');
        const pokemonId = document.getElementById('pokemon-id');
        const weight = document.getElementById('weight');
        const height = document.getElementById('height');
        const hp = document.getElementById('hp');
        const attack = document.getElementById('attack');
        const defense = document.getElementById('defense');
        const specialAttack = document.getElementById('special-attack');
        const specialDefense = document.getElementById('special-defense');
        const speed = document.getElementById('speed');
        const types = document.getElementById('types');
        const sprite = document.getElementById('sprite');

        searchButton.addEventListener('click', async () => {
            const searchValue = searchInput.value.trim();
            if (!searchValue) return;

            try {
                const response = await fetch(`https://pokeapi.co/api/v2/pokemon/${searchValue.toLowerCase()}`);
                const data = await response.json();

                pokemonName.textContent = data.name.toUpperCase();
                pokemonId.textContent = `ID: #${data.id}`;
                weight.textContent = `Weight: ${data.weight}`;
                height.textContent = `Height: ${data.height}`;
                hp.textContent = `HP: ${data.stats[0].base_stat}`;
                attack.textContent = `Attack: ${data.stats[1].base_stat}`;
                defense.textContent = `Defense: ${data.stats[2].base_stat}`;
                specialAttack.textContent = `Special Attack: ${data.stats[3].base_stat}`;
                specialDefense.textContent = `Special Defense: ${data.stats[4].base_stat}`;
                speed.textContent = `Speed: ${data.stats[5].base_stat}`;

                types.innerHTML = '';
                data.types.forEach(type => {
                    const typeElement = document.createElement('div');
                    typeElement.textContent = type.type.name.toUpperCase();
                    types.appendChild(typeElement);
                });

                sprite.src = data.sprites.front_default;
                sprite.alt = `Pokémon sprite of ${data.name}`;
            } catch (error) {
                alert('Pokémon not found');
            }
        });
    </script>
</body>
</html>
