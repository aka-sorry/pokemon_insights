/* 
***************************
MASTER POKEMON DATASET
    https://github.com/lgreski/pokemonData/blob/master/Pokemon.csv

Repository containing generations 1 - 9 of basic Pokémon stats, courtesy of pokemondb.net.

***************************
LICENSE: CC0 1.0 Universal

***************************
NOTES:
-	This project uses the master Pokémon dataset to analyze stat distributions across generations and types, classify Pokémon into archetypes (e.g., glass cannons, tanks), and build a balanced six-member team. For the sake of exploration, only base stats will be used. 
-	Multiple pokemon have different regional or form variations that share the same pokedex number. In order to avoid confusion when referencing the data, unique pokemon IDs will be generated.
-	Resources:
		https://bulbapedia.bulbagarden.net/wiki/Main_Page
-   Archetypes:
		https://tvtropes.org/pmwiki/pmwiki.php/Main/FightingGameTropes
		https://www.reddit.com/r/rpg/comments/1byk5u3/are_there_any_archetypelike_terms_like_glass/
		https://pokemonpets.fandom.com/wiki/Walls/tanks/sweepers
*/


/*** CREATING DATABASE ***/
-- CREATE DATABASE IF NOT EXISTS pokemon;
USE pokemon;

-- DESCRIBE pokemon.pokedex;

-- SELECT COUNT(*)
-- FROM pokedex;

-- ALTER TABLE pokedex
-- RENAME COLUMN release_num TO pokemon_id; # new PRIMARY key

# Replacing blank to NULL

/**********************************************************************/ 
/*** EXPLORATORY DATA ***/


SELECT
	COUNT(*)
FROM pokedex;

# Count pokemon by type
SELECT
	type_1,
    type_2,
    COUNT(*)
FROM pokemon.pokedex
GROUP BY type_1, type_2
ORDER BY type_1, type_2;

    
# Counting different forms of pokemon by generation
SELECT
    pokemon_id,
    poke_name,
    form,
    generation
FROM pokedex
WHERE form IS NOT NULL AND form <> ' ';

SELECT
COUNT(*)
FROM pokedex
WHERE type_2 <> " ";
/**********************************************************************/ 
/*** COUNT POKEMON BY STAT ***/
# hp count - 525 (43.21%)
WITH avg_stats AS(
	SELECT
        AVG(hp) AS avg_hp
	FROM pokemon.pokedex
),
abv_hp_cte AS (
	SELECT COUNT(*) AS abv_hp
	FROM pokedex p
	CROSS JOIN avg_stats a
	WHERE
		p.hp > a.avg_hp
)
SELECT 
	abv_hp, 
    (abv_hp/ (SELECT COUNT(*) FROM pokemon.pokedex)) * 100 AS perc_abv_hp
FROM abv_hp_cte;



# attack count - 554 (45.60%)
WITH avg_stats AS(
	SELECT
		AVG(attack) AS avg_attack
	FROM pokemon.pokedex
),
abv_atk_cte AS (
	SELECT COUNT(*) AS abv_atk
	FROM pokedex p
	CROSS JOIN avg_stats a
	WHERE
		p.attack > a.avg_attack
)
SELECT 
	abv_atk, 
    (abv_atk/ (SELECT COUNT(*) FROM pokemon.pokedex)) * 100 AS perc_abv_atk
FROM abv_atk_cte;



# defense count - 516 (42.47%)
WITH avg_stats AS(
	SELECT
		AVG(defense) AS avg_defense
	FROM pokemon.pokedex
),
abv_def_cte AS (
	SELECT COUNT(*) AS abv_def
	FROM pokedex p
	CROSS JOIN avg_stats a
	WHERE
		p.defense > a.avg_defense
)
SELECT 
	abv_def, 
    (abv_def/ (SELECT COUNT(*) FROM pokemon.pokedex)) * 100 AS perc_abv_def
FROM abv_def_cte;
        
	
    
# sp_attack count - 526 (43.29%)
WITH avg_stats AS(
	SELECT
		AVG(sp_attack) AS avg_sp_attack
	FROM pokemon.pokedex
),
abv_spatk_cte AS (
	SELECT COUNT(*) AS abv_spatk
	FROM pokedex p
	CROSS JOIN avg_stats a
	WHERE
		p.sp_attack > a.avg_sp_attack
)
SELECT 
	abv_spatk, 
    (abv_spatk/ (SELECT COUNT(*) FROM pokemon.pokedex)) * 100 AS perc_abv_spatk
FROM abv_spatk_cte;
    
	
    
# sp_defense count - 556 (45.76%)
WITH avg_stats AS(
	SELECT
		AVG(sp_defense) AS avg_sp_defense
	FROM pokemon.pokedex
),
abv_spdef_cte AS (
	SELECT COUNT(*) AS abv_spdef
	FROM pokedex p
	CROSS JOIN avg_stats a
	WHERE
		p.sp_defense > a.avg_sp_defense
)
SELECT 
	abv_spdef, 
    (abv_spdef/ (SELECT COUNT(*) FROM pokemon.pokedex)) * 100 AS perc_abv_spdef
FROM abv_spdef_cte;



# speed count - 550 (45.27%)
WITH avg_stats AS(
	SELECT
		AVG(speed) AS avg_speed
	FROM pokemon.pokedex
),
abv_speed_cte AS (
	SELECT COUNT(*) AS abv_speed
	FROM pokedex p
	CROSS JOIN avg_stats a
	WHERE
		p.speed > a.avg_speed
)
SELECT 
	abv_speed, 
    (abv_speed/ (SELECT COUNT(*) FROM pokemon.pokedex)) * 100 AS perc_abv_speed
FROM abv_speed_cte;



# Pokemon with stats above average stats    
WITH avg_stats AS(
	SELECT
		AVG(hp) AS avg_hp,
		AVG(attack) AS avg_attack,
		AVG(defense) AS avg_defense,
		AVG(sp_attack) AS avg_sp_attack,
		AVG(sp_defense) AS avg_sp_defense,
		AVG(speed) AS avg_speed
	FROM pokemon.pokedex
)
SELECT
	p.pokemon_id,
	p.poke_name,
    p.form,
	p.hp, a.avg_hp,
	p.attack, a.avg_attack,
	p.defense, a.avg_defense,
	p.sp_attack, a.avg_sp_attack,
	p.sp_defense, a.avg_sp_defense,
	p.speed, a.avg_speed
FROM pokedex p
CROSS JOIN avg_stats a
WHERE
	p.hp > a.avg_hp
	OR p.attack > a.avg_attack
	OR p.defense > a.avg_defense
	OR p.sp_attack > a.avg_sp_attack
	OR p.sp_defense > a.avg_sp_defense
	OR p.speed > a.avg_speed
ORDER BY p.pokemon_id;


/**********************************************************************/ 
# Average stats by type 1
SELECT
	type_1,
    AVG(hp) AS avg_hp,
	AVG(attack) AS avg_attack,
	AVG(defense) AS avg_defense,
	AVG(sp_attack) AS avg_sp_attack,
	AVG(sp_defense) AS avg_sp_defense,
	AVG(speed) AS avg_speed
FROM pokemon.pokedex
GROUP BY type_1
ORDER BY avg_hp;


# Average stats by type 2
SELECT COUNT(*)
FROM pokemon.pokedex
WHERE type_2 IS NOT NULL; # 1215

SELECT
	type_2,
    AVG(hp) AS avg_hp,
	AVG(attack) AS avg_attack,
	AVG(defense) AS avg_defense,
	AVG(sp_attack) AS avg_sp_attack,
	AVG(sp_defense) AS avg_sp_defense,
	AVG(speed) AS avg_speed
FROM pokemon.pokedex
GROUP BY type_2;


# Range of stats
SELECT
	type_1,
    MIN(hp) AS min_hp, MAX(hp) AS max_hp, AVG(hp) AS avg_hp,
    MIN(attack) AS min_atk, MAX(attack) AS max_atk, AVG(attack) AS avg_attack,
    MIN(defense) AS min_def, MAX(defense) AS max_def, AVG(defense) AS avg_defense,
    MIN(sp_attack) AS min_sp_atk, MAX(sp_attack) AS max_sp_atk, AVG(sp_attack) AS avg_sp_attack,
    MIN(sp_defense) AS min_sp_def, MAX(sp_defense) AS max_sp_def, AVG(sp_defense) AS avg_sp_defense,
    MIN(speed) AS min_speed, MAX(speed) AS max_speed, AVG(speed) AS avg_speed
FROM pokemon.pokedex
GROUP BY type_1;

# Average stats by type that exceed overall average stats
WITH 
avg_stats AS (
    SELECT
        AVG(hp) AS avg_hp,
        AVG(attack) AS avg_attack,
        AVG(defense) AS avg_defense,
        AVG(sp_attack) AS avg_sp_attack,
        AVG(sp_defense) AS avg_sp_defense,
        AVG(speed) AS avg_speed
    FROM pokemon.pokedex
),
type_stats AS (
    SELECT
        type_1,
        AVG(hp) AS avg_stat_hp,
        AVG(attack) AS avg_stat_attack,
        AVG(defense) AS avg_stat_defense,
        AVG(sp_attack) AS avg_stat_sp_attack,
        AVG(sp_defense) AS avg_stat_sp_defense,
        AVG(speed) AS avg_stat_speed
    FROM pokemon.pokedex
    GROUP BY type_1
),
compare_stats AS (
    SELECT
        t.type_1,
        a.avg_hp, t.avg_stat_hp,
        a.avg_attack, t.avg_stat_attack,
        a.avg_defense, t.avg_stat_defense,
        a.avg_sp_attack, t.avg_stat_sp_attack,
        a.avg_sp_defense, t.avg_stat_sp_defense,
        a.avg_speed, t.avg_stat_speed
    FROM type_stats t
    CROSS JOIN avg_stats a
)
SELECT *
FROM compare_stats
WHERE
    avg_stat_hp > avg_hp
    OR avg_stat_attack > avg_attack
    OR avg_stat_defense > avg_defense
    OR avg_stat_sp_attack > avg_sp_attack
    OR avg_stat_sp_defense > avg_sp_defense
    OR avg_stat_speed > avg_speed
ORDER BY type_1;    

/**********************************************************************/ 

# Highest Pokemon per Stat

# Highest HP
SELECT
	pokemon_id,
	poke_name,
	generation,
	type_1, type_2,
	hp AS max_hp
FROM pokedex
WHERE hp = (SELECT MAX(hp) FROM pokedex);

# Highest Attack
SELECT
	pokemon_id,
	poke_name,
	generation,
	type_1, type_2,
	attack AS max_attack
FROM pokedex
WHERE attack = (SELECT MAX(attack) FROM pokedex);

# Highest Defense 
SELECT
	pokemon_id,
	poke_name,
	generation,
	type_1, type_2,
	defense AS max_defense
FROM pokedex
WHERE defense = (SELECT MAX(defense) FROM pokedex);	

# Highest Sp Attack
SELECT
	pokemon_id,
	poke_name,
	generation,
	type_1, type_2,
	sp_attack AS max_sp_attack
FROM pokedex
WHERE sp_attack = (SELECT MAX(sp_attack) FROM pokedex);

# Highest Sp Defense
SELECT
	pokemon_id,
	poke_name,
	generation,
	type_1, type_2,
	sp_defense AS max_sp_defense
FROM pokedex
WHERE sp_defense = (SELECT MAX(sp_defense) FROM pokedex);

# Highest Speed
SELECT
	pokemon_id,
	poke_name,
	generation,
	type_1, type_2,
	speed AS max_speed
FROM pokedex
WHERE speed = (SELECT MAX(speed) FROM pokedex);    

/**********************************************************************/ 

# Highest Stat by Generation
WITH ranked AS (
	SELECT
		pokemon_id,
        poke_name,
        generation,
        type_1,
        type_2,
        hp, attack, defense, sp_attack, sp_defense, speed,
        RANK() OVER (PARTITION BY generation ORDER BY hp DESC) AS r_hp,
        RANK() OVER (PARTITION BY generation ORDER BY attack DESC) AS r_attack,
        RANK() OVER (PARTITION BY generation ORDER BY defense DESC) AS r_defense,
        RANK() OVER (PARTITION BY generation ORDER BY sp_attack DESC) AS r_sp_attack,
        RANK() OVER (PARTITION BY generation ORDER BY sp_defense DESC) AS r_sp_defense,
        RANK() OVER (PARTITION BY generation ORDER BY speed DESC) AS r_speed
	FROM pokedex
)
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'hp' AS stat, hp AS value FROM ranked WHERE r_hp = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'attack' AS stat, attack AS value FROM ranked WHERE r_attack = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'defense' AS stat, defense AS value FROM ranked WHERE r_defense = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'sp_attack' AS stat, sp_attack AS value FROM ranked WHERE r_sp_attack = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'sp_defense' AS stat, sp_defense AS value FROM ranked WHERE r_sp_defense = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'speed' AS stat, speed AS value FROM ranked WHERE r_speed = 1;


# Highest Stat by Types
WITH ranked AS (
	SELECT
		pokemon_id,
        poke_name,
        generation,
        type_1,
        type_2,
        hp, attack, defense, sp_attack, sp_defense, speed,
        RANK() OVER (PARTITION BY type_1 ORDER BY hp DESC) AS r_hp,
        RANK() OVER (PARTITION BY type_1 ORDER BY attack DESC) AS r_attack,
        RANK() OVER (PARTITION BY type_1 ORDER BY defense DESC) AS r_defense,
        RANK() OVER (PARTITION BY type_1 ORDER BY sp_attack DESC) AS r_sp_attack,
        RANK() OVER (PARTITION BY type_1 ORDER BY sp_defense DESC) AS r_sp_defense,
        RANK() OVER (PARTITION BY type_1 ORDER BY speed DESC) AS r_speed
	FROM pokedex
)
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'hp' AS stat, hp AS value FROM ranked WHERE r_hp = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'attack' AS stat, attack AS value FROM ranked WHERE r_attack = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'defense' AS stat, defense AS value FROM ranked WHERE r_defense = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'sp_attack' AS stat, sp_attack AS value FROM ranked WHERE r_sp_attack = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'sp_defense' AS stat, sp_defense AS value FROM ranked WHERE r_sp_defense = 1
UNION ALL
SELECT generation, pokemon_id, poke_name, type_1, type_2, 'speed' AS stat, speed AS value FROM ranked WHERE r_speed = 1;

/**********************************************************************/ 
/* 
CHARACTER ARCHETYPES:
https://pokemonpets.fandom.com/wiki/Walls/tanks/sweepers

Offensive Archetypes:
	Sweepers (Glass Cannons - high damage and speed):
		Physical Sweeper: high attack, high speed
		Special Sweeper: high sp attack, high speed

Defensive Archetypes:
	Tanks (high attack with high survivability):
		Physical Tank: high attack, high defense
		Special Tank: high sp attack, high sp defense
        Allround Tank: high defense, high sp defense
	
    Wall (specialized defense):
		Physical Wall: high defense, high hp
        Special Wall: high sp defense, high hp
*/
