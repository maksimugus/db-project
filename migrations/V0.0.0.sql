DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'genre') THEN
        CREATE TYPE genre AS ENUM (
            'action',
            'adventure',
            'animation',
            'comedy',
            'crime',
            'documentary',
            'drama',
            'family',
            'fantasy',
            'historical',
            'horror',
            'musical',
            'mystery',
            'romance',
            'science',
            'thriller',
            'war',
            'western'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'review_type') THEN
        CREATE TYPE review_type AS ENUM (
            'positive',
            'negative',
            'neutral'
        );
    END IF;
END
$$;