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

CREATE TYPE review_type AS ENUM (
    'positive',
    'negative',
    'neutral'
);