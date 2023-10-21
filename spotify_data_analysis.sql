-- 1. **Общее количество стримов по годам:** - Определите общее количество стримов за каждый год и определить год с наибольшим количеством стримов. 
SELECT 
    released_year, SUM(streams) AS total_streams
FROM
    spotify_data
GROUP BY released_year
ORDER BY total_streams DESC;


-- 2. **Самые популярные исполнители:** - Определить топ-10 исполнителей с наибольшим количеством стримов и рассчитать среднее количество стримов на одного исполнителя. 
SELECT 
    artist_name, SUM(streams) AS total_streams
FROM
    spotify_data
GROUP BY artist_name
ORDER BY total_streams DESC
LIMIT 10;


-- 3. **Распределение песен по тональностям:** - Проанализировать распределение песен в мажорных и минорных ладах и рассчитать средний процент танцевальности для каждого лада. 

SELECT 
    mode,
    COUNT(*) AS song_count,
    AVG(danceability_percent) AS avg_danceability
FROM
    spotify_data
GROUP BY mode;


-- 4. **Среднее количество ударов в минуту (BPM) по тональности:** - Рассчитать средний BPM для песен в каждой тональности и определить тональность с наибольшим средним BPM. 
SELECT 
    `key`, AVG(bpm) AS avg_bpm
FROM
    spotify_data
GROUP BY `key`;


-- 5. **Самые популярные песни:** - Определить и ранжировать 10 самых популярных песен в наборе данных.
SELECT 
    track_name, artist_name, streams
FROM
    spotify_data
ORDER BY streams DESC
LIMIT 10;


-- 6. **Популярность и валентность по годам:** - Исследовать взаимосвязь между позитивностью песен (валентность) и их популярностью (стримы) за каждый год. 
SELECT 
    released_year,
    AVG(valence_percent) AS avg_valence,
    SUM(streams) AS total_streams
FROM
    spotify_data
GROUP BY released_year
ORDER BY released_year;

-- 7. **Самые популярные исполнители по месяцам:** - Определить топ-5 артистов с наибольшим количеством стримов за каждый месяц и понаблюдать за изменениями их популярности в течение года. 
WITH MonthlyArtists AS (
   SELECT artist_name, released_month, SUM(streams) AS monthly_streams
   FROM spotify_data
   GROUP BY artist_name, released_month
)
SELECT artist_name, released_month, monthly_streams
FROM (
   SELECT artist_name, released_month, monthly_streams,
          ROW_NUMBER() OVER(PARTITION BY released_month ORDER BY monthly_streams DESC) AS rn
   FROM MonthlyArtists
) ranked
WHERE rn <= 5;


-- 8. **Самые популярные энергичные песни:** - Определить и ранжировать 10 самых популярных песен с высоким уровнем энергии. 
SELECT 
    track_name, energy_percent, streams
FROM
    spotify_data
WHERE
    energy_percent >= 0.8
        AND track_name IN (SELECT 
            track_name
        FROM
            spotify_data
        ORDER BY streams DESC)
ORDER BY streams DESC
LIMIT 10;


-- 9. **Самые популярные песни с высоким процентом живого выступлеения:** - Определить и ранжировать топ-10 самых прослушиваемых песен с высоким процентом живого выступления. 
SELECT 
    track_name, streams, liveness_percent
FROM
    spotify_data
WHERE
    liveness_percent > 0.8
ORDER BY streams DESC;


-- 10. **Рейтинг Shazam Chart:** - Определить песни с рейтингом Shazam в топ-10 и проанализировать средний процент речитатива.
SELECT 
    track_name, in_shazam_charts, speechiness_percent
FROM
    spotify_data
WHERE
    in_shazam_charts BETWEEN 1 AND 10;
