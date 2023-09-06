--1. Number of rows after doing a right join, with the track data being on the left table.
--392,000 rows returned
SELECT COUNT(*)
FROM spotify_daily_charts_tracks
RIGHT JOIN spotify_daily_charts
ON spotify_daily_charts_tracks.track_id=spotify_daily_charts.track_id;

--4,175 rows returned
SELECT COUNT(*)
FROM spotify_daily_charts_tracks
RIGHT JOIN spotify_daily_charts_artists
ON spotify_daily_charts_tracks.artist_id = spotify_daily_charts_artists.artist_id;

--2. Use Spotify daily charts that shows the least to highest played songs by these Filipino artists:
SELECT artist, track_name, SUM(streams) AS sum_streams
FROM spotify_daily_charts
WHERE artist IN ('Up Dharma Down', 'Callalily', 'Gloc 9', 'Silent Sanctuary', 'Moonstar88')
GROUP BY artist, track_name
ORDER BY SUM(streams);

--3. Join artists and track tables. Group to determine artist's average tempo
SELECT spotify_daily_charts_artists.artist_name AS artist,
ROUND(AVG(spotify_daily_charts_tracks.tempo),2) AS average_tempo
FROM spotify_daily_charts_artists
LEFT JOIN spotify_daily_charts_tracks
ON spotify_daily_charts_artists.artist_id = spotify_daily_charts_tracks.artist_id
GROUP BY spotify_daily_charts_artists.artist_name
ORDER by artist_name;

--4. Top 5 artists whose songs are frequently included in the PH Top 200 Daily Charts
SELECT artist, COUNT (artist) AS frequency_in_ph_top_200_daily_charts
FROM spotify_daily_charts
GROUP BY artist
ORDER BY COUNT (artist) DESC
LIMIT 5;

--5 Join of artist and daily charts. Determine track's avg number of streams and include artist popularity
SELECT 
 spotify_daily_charts.track_name, 
 spotify_daily_charts.artist,
 spotify_daily_charts_artists.popularity,
 ROUND(AVG(spotify_daily_charts.streams),2) AS average_streams
FROM spotify_daily_charts_artists
LEFT JOIN spotify_daily_charts
ON spotify_daily_charts_artists.artist_name = spotify_daily_charts.artist
GROUP BY spotify_daily_charts.track_name, spotify_daily_charts.artist, spotify_daily_charts_artists.popularity
HAVING track_name IS NOT NULL
ORDER BY average_streams DESC;