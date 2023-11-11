library(tidyverse)
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '6d7f3e6171c149a6b365504f76e3755c')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'c653ee4f4dc647668c44d5e8d4671091')
Sys.setenv(SPOTIFY_REDIRECT_URI = 'http://localhost:1410/')

access_token <- get_spotify_access_token()

search_string <- 'Tyler, The Creator'

search_results <- 
  search_spotify(
    q = search_string,
    type = c("artist"),
    authorization = get_spotify_access_token()
)

artist_id <-
  search_results %>%
  arrange(-popularity) %>%
  slice_head(n = 1) %>%
  # select(id, name, uri, popularity, followers.total) %>%
  pull(id)

tyler_album_songs <- 
  get_artist_audio_features(
    artist = artist_id,
    include_groups = 'album',
    return_closest_artist = TRUE,
    dedupe_albums = TRUE,
    market = NULL,
    authorization = get_spotify_access_token()
  )

tyler_album_songs %>%
  select(
    track = track_name,
    artist = artist_name,
    album = album_name,
    liveness,
    valence,
    energy,
    acousticness,
    speechiness,
    tempo,
    danceability,
    instrumentalness,
    tempo,
    loudness,
    album_release_year,
    duration_ms,
    key_mode) %>%
  write_csv('data/tyler_album_songs.csv')
