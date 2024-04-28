from django.urls import path
from . import views

urlpatterns = [
    # URLs for authentication
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('register/', views.register_view, name='register'),

    # Dashboard URL
    path('', views.dashboard_view, name='dashboard'),

    # Playlist URL
    path('playlist/', views.playlist_view, name='playlist'),
    # Playlist Detail URL
    path('playlist/details/', views.playlist_detail_view, name='playlist_detail'),

    # Now Playing URL
    path('now_playing', views.now_playing_view, name='now_playing'),

    # # URLs for managing downloaded songs and podcasts 
    # path('manage_downloaded_songs/', views.manage_downloaded_songs_view, name='manage_downloaded_songs'),
    # path('manage_podcast/', views.manage_podcast_view, name='manage_podcast'),

    # # URLs for managing albums and songs
    # path('manage_album_and_songs/', views.manage_album_and_songs_view, name='manage_album_and_songs'),

    # # URL for checking royalty
    # path('check_royalty/', views.check_royalty_view, name='check_royalty'),

    # # URL for chart
    # path('chart/', views.chart_view, name='chart'),

    # # URL for searching
    # path('search/', views.search_view, name='search'),

    # # URL for managing playlists
    # path('manage_playlist/', views.manage_playlist_view, name='manage_playlist'),

    # # URL for subscription
    # path('subscription/', views.subscription_view, name='subscription'),

    # Add more URLs as needed...
]
