DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO films (name, year_of_production, slogan, budget, world_fees, world_primiere, primiere_in_russia, duration)
    VALUES (
        'Star Wars: Episode ' || i,
        1999 + i - 1,
        'May the ' || i || ' be with you',
        (100000000 * (1 + random()))::NUMERIC::MONEY,
        (1000000000 * (1 + random()))::NUMERIC::MONEY,
        ((1999 + i - 1) || '-05-04')::DATE,
        ((1999 + i - 1) || '-07-04')::DATE,
        TIME '02:00:00' + random() * TIME '01:00:00'
    );
    i := i + 1;
END LOOP;
END $$;