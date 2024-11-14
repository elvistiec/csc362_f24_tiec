DROP DATABASE IF EXISTS pokemon_league;
CREATE DATABASE pokemon_league;
USE pokemon_league;

CREATE TABLE trainers (
    trainer_id          INT AUTO_INCREMENT,
    trainer_name        VARCHAR(32),
    trainer_hometown    VARCHAR(32),
    PRIMARY KEY (trainer_id)
);


CREATE TABLE pokemon (
    pokemon_id          INT AUTO_INCREMENT,
    pokemon_species     VARCHAR(32),
    pokemon_level       INT,
    trainer_id          INT,
    pokemon_is_in_party BOOLEAN,
    PRIMARY KEY (pokemon_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
    CONSTRAINT minimum_pokemon_level CHECK (pokemon_level >= 1),
    CONSTRAINT maximum_pokemon_level CHECK (pokemon_level <= 100)
);


INSERT INTO trainers (trainer_name, trainer_hometown)
 VALUES ("Ash",     "Pallet Town"),
        ("Misty",   "Cerulean City"),
        ("Brock",   "Pewter City");


INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
 VALUES ("Pikachu", "58", 1, TRUE),
        ("Staryu",  "44", 2, TRUE),
        ("Onyx",    "52", 3, TRUE),
        ("Magicarp","12", 1, FALSE);

DELIMITER //

--before an insert it checks if the trainer's party has 6 or more pokemon
--if so, it'll throw the error
CREATE TRIGGER pokemon_party_limit
BEFORE INSERT ON pokemon
FOR EACH ROW
BEGIN
    DECLARE party_count INT;

    IF NEW.pokemon_is_in_party = TRUE THEN
        SELECT COUNT(*) INTO party_count
        FROM pokemon
        WHERE trainer_id = NEW.trainer_id
        AND pokemon_is_in_party = TRUE;

        IF party_count >= 6 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'cannot have over 6 pokemon in party';
        END IF;
    END IF;
END;
//

DELIMITER ;


DELIMITER //

--before an update it checks if the trainer's party has less than 1 pokemon
--if so, it'll throw the error
CREATE TRIGGER pokemon_party_minimum
BEFORE UPDATE ON pokemon
FOR EACH ROW
BEGIN
    DECLARE party_count INT;

    IF OLD.pokemon_is_in_party = TRUE THEN
        SELECT COUNT(*) INTO party_count
        FROM pokemon
        WHERE trainer_id = OLD.trainer_id
        AND pokemon_is_in_party = TRUE;

        IF party_count <= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'must have 1 pokemon in party';
        END IF;
    END IF;
END;
//

DELIMITER ;

DELIMITER //

--before a delete it checks if the trainer's party has less than 1 pokemon
--if so, it'll throw the error
CREATE TRIGGER pokemon_delete
BEFORE DELETE ON pokemon
FOR EACH ROW
BEGIN
    DECLARE party_count INT;

    IF OLD.pokemon_is_in_party = TRUE THEN
        SELECT COUNT(*) INTO party_count
        FROM pokemon
        WHERE trainer_id = OLD.trainer_id
        AND pokemon_is_in_party = TRUE;

        IF party_count <= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'must have 1 pokemon in party';
        END IF;
    END IF;
END;
//

DELIMITER ;

DELIMITER //

--check if the pokemon is in the party of the trainer
CREATE PROCEDURE trade_pokemon(
    IN trainer1_id INT,
    IN pokemon1_id INT,
    IN trainer2_id INT,
    IN pokemon2_id INT
)
BEGIN

    START TRANSACTION;

    IF (SELECT COUNT(*) FROM pokemon WHERE pokemon_id = pokemon1_id AND trainer_id = trainer1_id AND pokemon_is_in_party = TRUE) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'pokemon is not in party of trainer 1';
    ELSEIF (SELECT COUNT(*) FROM pokemon WHERE pokemon_id = pokemon2_id AND trainer_id = trainer2_id AND pokemon_is_in_party = TRUE) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'pokemon is not in party of trainer 2';
    END IF;

    UPDATE pokemon SET trainer_id = trainer2_id WHERE pokemon_id = pokemon1_id;
    UPDATE pokemon SET trainer_id = trainer1_id WHERE pokemon_id = pokemon2_id;

    COMMIT;
END;
//

DELIMITER ;


--TESTING

--removing all pokemon from party
UPDATE pokemon SET pokemon_is_in_party = 0 WHERE trainer_id = 1;

--testing max party limit
INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
 VALUES ("ditto", "1", 1, TRUE),
        ("ditto", "1", 1, TRUE),
        ("ditto", "1", 1, TRUE),
        ("ditto", "1", 1, TRUE),
        ("ditto", "1", 1, TRUE);

INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
 VALUES ("shiny ditto", "1", 1, TRUE);

 --trading pokemon
CALL trade_pokemon(1, 4, 3, 3);