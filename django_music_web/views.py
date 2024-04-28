from django.shortcuts import render

def login_view(request):
    return render(request, 'login.html')

def logout_view(request):
    return render(request, 'logout.html')

def register_view(request):
    return render(request, 'register.html')

def dashboard_view(request):
    return render(request, 'dashboard.html')

def playlist_view(request):
    return render(request, 'playlist.html')

def playlist_detail_view(request):
    return render(request, 'playlist_detail.html')

def now_playing_view(request):
    return render(request, 'now_playing.html')