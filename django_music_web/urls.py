from django.urls import path
from . import views
from .views import shuffle_play, play_song, play_song2

urlpatterns = [
    # URLs for authentication
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('register/', views.register_view, name='register'),

    # Dashboard URL
    path('', views.dashboard_view, name='dashboard'),

    # Playlist URL
    path('playlist/', views.playlist_view, name='playlist'),
    path('playlist/details/', views.playlist_detail_view, name='playlist_detail'),

    # URLs for CRUD Playlist
    path('playlist/add/', views.add_playlist, name='add_playlist'),
    path('playlist/update/<uuid:id>/', views.update_playlist, name='update_playlist'),
    path('playlist/delete/<uuid:id>/', views.delete_playlist, name='delete_playlist'),

    # URL for adding and removing songs from playlist
    path('playlist/<uuid:id_user_playlist>/add_song/', views.add_song_to_playlist, name='add_song_to_playlist'),
    path('playlist/<uuid:id_user_playlist>/remove_song/<uuid:id_song>/', views.remove_song_from_playlist, name='remove_song_from_playlist'),

    # URL for song detail
    path('song/<uuid:song_id>/', views.song_detail_view, name='song_detail'),
    path('playlist/shuffle_play/', shuffle_play, name='shuffle_play'),
    path('song/play_song/', play_song, name='play_song'),
    path('song/play_song2/', play_song2, name='play_song2'),
    # URL to download song
    path('song/download/<uuid:song_id>/', views.download_song, name='download_song'),
    # URLs for managing albums
    path('list_album/', views.list_album, name='list_album'),
    path('create_album/', views.create_album, name='create_album'),
    path('remove_album/<str:id>', views.remove_album, name='remove_album'),

    # URLs for managing songs
    path('list_song/<str:id>', views.list_song, name='list_song'),
    path('create_song/<str:album_id>', views.create_song, name='create_song'),
    path('remove_song/<str:id_album>/<str:id_song>', views.remove_song, name='remove_song'),

    # URL for checking royalty
    path('check_royalty/', views.check_royalty, name='check_royalty'),

    # URL for chart
    path('chart/', views.chart_view, name='chart'),
    path('chart_details/', views.chart_details, name='chart_details'),

    path('play_podcast/', views.play_podcast, name='play_podcast'),
    path('kelola_podcast/', views.kelola_podcast, name='kelola_podcast'),
    path('create_podcast/', views.create_podcast, name='create_podcast'),
    path('list_podcast/', views.list_podcast, name='list_podcast'),
    path('create_episode/', views.create_episode, name='create_episode'),
    path('daftar_episode/', views.daftar_episode, name='daftar_episode'),
    path('delete_podcast/', views.delete_podcast, name='delete_podcast'),
    path('delete_episode/', views.delete_episode, name='delete_episode'),
    path('play_podcast/', views.play_podcast, name='play_podcast'),
    path('all_podcasts/', views.all_podcasts, name='all_podcasts'),
]
