from django.shortcuts import render, redirect
from django.db import connection, IntegrityError, InternalError
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from django.core.serializers.json import DjangoJSONEncoder
from django.http import JsonResponse
import json
import uuid
import datetime
from django.utils.timezone import now
import psycopg2

#=================================================WHITE FUNCTIONS===================================================
#=================================================WHITE FUNCTIONS===================================================
#=================================================WHITE FUNCTIONS===================================================

# View untuk login
def login_view(request):
    if request.method == 'POST':
        email = request.POST['email']
        password = request.POST['password']

        query = """
            SELECT * 
            FROM (
                SELECT email, password
                FROM AKUN
                UNION
                SELECT email, password
                FROM LABEL
            ) AS A
            WHERE A.email = %s 
            AND A.password = %s
        """
        with connection.cursor() as cursor:
            cursor.execute(query, [email, password])
            user = cursor.fetchone()

            if user is None:
                messages.info(request, 'Sorry, incorrect email or password. Please try again.')
                return render(request, 'login.html')

            # Autentikasi dan login user
            auth_user = authenticate(request, username=email, password=password)
            if auth_user is not None:
                login(request, auth_user)
            else:
                auth_user = User.objects.create_user(username=email, password=password)
                login(request, auth_user)

            request.session['email'] = email

            # Cek status user
            role_queries = {
                'is_premium': "SELECT EXISTS (SELECT 1 FROM PREMIUM WHERE email = %s)",
                'is_songwriter': "SELECT EXISTS (SELECT 1 FROM SONGWRITER WHERE email_akun = %s)",
                'is_artist': "SELECT EXISTS (SELECT 1 FROM ARTIST WHERE email_akun = %s)",
                'is_podcaster': "SELECT EXISTS (SELECT 1 FROM PODCASTER WHERE email = %s)",
                'is_label': "SELECT EXISTS (SELECT 1 FROM LABEL WHERE email = %s)"
            }

            for role, query in role_queries.items():
                cursor.execute(query, [email])
                request.session[role] = cursor.fetchone()[0]

            context = {
                'email': request.session['email'],
                'is_premium': request.session['is_premium'],
                'is_songwriter': request.session['is_songwriter'],
                'is_artist': request.session['is_artist'],
                'is_podcaster': request.session['is_podcaster'],
                'is_label': request.session['is_label']
            }

            return HttpResponseRedirect(reverse('dashboard'))
    else:
        return render(request, 'login.html')

# View untuk logout
def logout_view(request):
    logout(request)
    return render(request, 'logout.html')

# View untuk register
def register_view(request):
    try:
        if request.method == 'POST':
            uuid_phk = uuid.uuid4()
            email = request.POST['email']
            email_label = request.POST['email_label']
            role = request.POST['role']

            with connection.cursor() as cursor:
                if role == 'pengguna':
                    password = request.POST['password']
                    nama = request.POST['nama']
                    gender = request.POST['gender']
                    tempat_lahir = request.POST['tempat_lahir']
                    tanggal_lahir = request.POST['tanggal_lahir']
                    kota_asal = request.POST['kota_asal']

                    # Konversi nilai gender menjadi integer
                    if gender.lower() == 'laki-laki':
                        gender_value = 1
                    elif gender.lower() == 'perempuan':
                        gender_value = 0
                    else:
                        messages.error(request, 'Nilai gender tidak valid.')
                        return render(request, 'register.html')

                    # Insert into AKUN table
                    is_verified = 'FALSE'
                    roles = ['podcaster', 'artist', 'songwriter']
                    for role in roles:
                        if role in request.POST:
                            is_verified = 'TRUE'
                            break

                    insert_user_query = f"""
                        INSERT INTO AKUN (email, password, nama, gender, tempat_lahir, tanggal_lahir, kota_asal, is_verified)
                        VALUES ('{email}', '{password}', '{nama}', {gender_value}, '{tempat_lahir}', '{tanggal_lahir}', '{kota_asal}', {is_verified})
                    """
                    cursor.execute(insert_user_query)

                    # Insert into role-specific tables if necessary
                    if 'podcaster' in request.POST:
                        cursor.execute(f"INSERT INTO PODCASTER (email) VALUES ('{email}')")

                    if ('artist' in request.POST) or ('songwriter' in request.POST):
                        
                        # Insert into PHK table
                        insert_phk_query = f"""
                            INSERT INTO PEMILIK_HAK_CIPTA (id, rate_royalti)
                            VALUES ('{uuid_phk}', 10)
                        """
                        cursor.execute(insert_phk_query)
                        
                        if 'artist' in request.POST:
                            insert_artist_query = f"""
                                INSERT INTO Artist (id, email_akun, id_pemilik_hak_cipta)
                                VALUES ('{uuid.uuid4()}', '{email}', '{uuid_phk}')
                            """
                            cursor.execute(insert_artist_query)

                        if 'songwriter' in request.POST:
                            insert_songwriter_query = f"""
                                INSERT INTO SONGWRITER (id, email_akun, id_pemilik_hak_cipta)
                                VALUES ('{uuid.uuid4()}', '{email}', '{uuid_phk}')
                            """
                            cursor.execute(insert_songwriter_query)

                    messages.success(request, 'Pengguna registered successfully.')

                elif role == 'label':
                    password = request.POST['password_label']
                    nama = request.POST['nama_label']
                    kontak = request.POST['kontak_label']

                    # Insert into PHK table
                    insert_phk_query = f"""
                        INSERT INTO PEMILIK_HAK_CIPTA (id, rate_royalti)
                        VALUES ('{uuid_phk}', 10)
                    """
                    cursor.execute(insert_phk_query)

                    # Insert into LABEL table
                    insert_label_query = f"""
                        INSERT INTO LABEL (id, nama, email, password, kontak, id_pemilik_hak_cipta)
                        VALUES ('{uuid.uuid4()}', '{nama}', '{email_label}', '{password}', '{kontak}', '{uuid_phk}')
                    """
                    cursor.execute(insert_label_query)
                    messages.success(request, 'Label registered successfully.')

            return HttpResponseRedirect(reverse('login'))
    except InternalError as e:
        messages.warning(request, str(e).splitlines()[0])
        return render(request, 'register.html')
    except:
        messages.error(request, 'Terdapat field yang kosong.')
        return render(request, 'landing.html')

    return render(request, 'register.html')


def dashboard_view(request):
    if not request.user.is_authenticated:
        return render(request, 'landing.html')

    context = {
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }

    with connection.cursor() as cursor:
        if request.session['is_label']:
            query = """
                SELECT nama, email, kontak
                FROM LABEL
                WHERE email = %s
            """
            cursor.execute(query, [request.session['email']])
            result = cursor.fetchone()
            context.update({
                'nama': result[0],
                'email': result[1],
                'kontak': result[2]
            })

            cursor.execute("SELECT judul FROM ALBUM WHERE id_label = (SELECT id FROM LABEL WHERE email = %s)", [request.session['email']])
            albums = cursor.fetchall()
            context['albums'] = [album[0] for album in albums] if albums else None
        else:
            query = """
                SELECT nama, email, kota_asal, gender, tempat_lahir, tanggal_lahir
                FROM AKUN
                WHERE email = %s
            """
            cursor.execute(query, [request.session['email']])
            result = cursor.fetchone()
            context.update({
                'nama': result[0],
                'email': result[1],
                'kota_asal': result[2],
                'gender': result[3],
                'tempat_lahir': result[4],
                'tanggal_lahir': result[5],
            })

        roles = []
        if request.session['is_songwriter']:
            roles.append('Songwriter')
        if request.session['is_artist']:
            roles.append('Artist')
        if request.session['is_podcaster']:
            roles.append('Podcaster')
        if request.session['is_label']:
            roles.append('Label')
        context['roles'] = roles

        if not request.session['is_label']:
            cursor.execute("SELECT judul FROM USER_PLAYLIST WHERE email_pembuat = %s", [request.session['email']])
            playlists = cursor.fetchall()
            context['playlists'] = [playlist[0] for playlist in playlists] if playlists else None

            if request.session['is_artist'] or request.session['is_songwriter']:
                cursor.execute("""
                    SELECT KONTEN.judul 
                    FROM SONG 
                    INNER JOIN KONTEN ON SONG.id_konten = KONTEN.id 
                    WHERE SONG.id_artist = (SELECT id FROM ARTIST WHERE email_akun = %s)
                    OR SONG.id_konten IN (SELECT id_song FROM SONGWRITER_WRITE_SONG WHERE id_songwriter = (SELECT id FROM SONGWRITER WHERE email_akun = %s))
                """, [request.session['email'], request.session['email']])
                songs = cursor.fetchall()
                context['songs'] = [song[0] for song in songs] if songs else None

            if request.session['is_podcaster']:
                cursor.execute("""
                    SELECT KONTEN.judul 
                    FROM PODCAST 
                    INNER JOIN KONTEN ON PODCAST.id_konten = KONTEN.id 
                    WHERE PODCAST.email_podcaster = %s
                """, [request.session['email']])
                podcasts = cursor.fetchall()
                context['podcasts'] = [podcast[0] for podcast in podcasts] if podcasts else None

    return render(request, 'dashboard.html', context)



#=================================================GREEN FUNCTIONS===================================================
#=================================================GREEN FUNCTIONS===================================================
#=================================================GREEN FUNCTIONS===================================================



# CRUD Kelola Playlist
@login_required
def playlist_view(request):
    email = request.session['email']
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_user_playlist, judul, deskripsi, jumlah_lagu, total_durasi FROM USER_PLAYLIST WHERE email_pembuat = %s", [email])
        playlists = cursor.fetchall()

    context = {
        'playlists': [{'id_user_playlist': playlist[0], 'judul': playlist[1], 'deskripsi': playlist[2], 'jumlah_lagu': playlist[3], 'total_durasi': playlist[4]} for playlist in playlists],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }
    return render(request, 'playlist.html', context)

@login_required
def add_playlist(request):
    if request.method == 'POST':
        judul = request.POST['playlistName']
        deskripsi = request.POST['playlistDescription']
        email = request.session['email']
        playlist_id = uuid.uuid4()
        user_playlist_id = uuid.uuid4()
        
        with connection.cursor() as cursor:
            # Tambahkan entri ke tabel PLAYLIST
            cursor.execute("""
                INSERT INTO PLAYLIST (id) VALUES (%s)
            """, [playlist_id])
            
            # Tambahkan entri ke tabel USER_PLAYLIST
            cursor.execute("""
                INSERT INTO USER_PLAYLIST (
                    email_pembuat, 
                    id_user_playlist, 
                    judul, 
                    deskripsi, 
                    jumlah_lagu, 
                    total_durasi, 
                    tanggal_dibuat, 
                    id_playlist
                ) VALUES (
                    %s, 
                    %s, 
                    %s, 
                    %s, 
                    0, 
                    0, 
                    CURRENT_TIMESTAMP, 
                    %s
                )
            """, [email, user_playlist_id, judul, deskripsi, playlist_id])
        return redirect('playlist')
    else:
        context = {
            'is_premium': request.session['is_premium'],
            'is_songwriter': request.session['is_songwriter'],
            'is_artist': request.session['is_artist'],
            'is_podcaster': request.session['is_podcaster'],
            'is_label': request.session['is_label']
        }
        return render(request, 'playlist.html', context)

@login_required
def update_playlist(request, id):
    if request.method == 'POST':
        judul = request.POST['playlistName']
        deskripsi = request.POST['playlistDescription']
        
        with connection.cursor() as cursor:
            cursor.execute("UPDATE USER_PLAYLIST SET judul = %s, deskripsi = %s WHERE id_user_playlist = %s", [judul, deskripsi, id])
        return JsonResponse({'success': True})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

# views.py
@login_required
def delete_playlist(request, id):
    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM USER_PLAYLIST WHERE id_user_playlist = %s", [id])
        return JsonResponse({'success': True})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

    
@login_required
def playlist_detail_view(request):
    playlist_id = request.GET.get('id')
    
    with connection.cursor() as cursor:
        # Ambil detail playlist
        cursor.execute("SELECT judul, deskripsi, jumlah_lagu, total_durasi, email_pembuat, tanggal_dibuat FROM USER_PLAYLIST WHERE id_user_playlist = %s", [playlist_id])
        playlist = cursor.fetchone()

        if not playlist:
            return render(request, 'playlist_detail.html', {'error': 'Playlist tidak ditemukan'})

        # Ambil lagu-lagu dalam playlist
        cursor.execute("""
            SELECT KONTEN.id, KONTEN.judul, AKUN.nama, KONTEN.durasi 
            FROM KONTEN 
            INNER JOIN SONG ON KONTEN.id = SONG.id_konten 
            INNER JOIN ARTIST ON SONG.id_artist = ARTIST.id
            INNER JOIN AKUN ON ARTIST.email_akun = AKUN.email
            WHERE KONTEN.id IN (
                SELECT id_song FROM PLAYLIST_SONG WHERE id_playlist = (SELECT id_playlist FROM USER_PLAYLIST WHERE id_user_playlist = %s)
            )
        """, [playlist_id])
        songs = cursor.fetchall()

        # Ambil lagu yang tersedia untuk ditambahkan ke playlist
        cursor.execute("SELECT id, judul FROM KONTEN")
        available_songs = cursor.fetchall()

    context = {
        'playlist': {
            'id_user_playlist': playlist_id,
            'judul': playlist[0],
            'deskripsi': playlist[1],
            'jumlah_lagu': playlist[2],
            'total_durasi': playlist[3],
            'email_pembuat': playlist[4],
            'tanggal_dibuat': playlist[5],
        },
        'songs': [{'id': song[0], 'judul': song[1], 'artis': song[2], 'durasi': song[3]} for song in songs],
        'available_songs': [{'id': song[0], 'judul': song[1]} for song in available_songs],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }
    return render(request, 'playlist_detail.html', context)

# View untuk menambahkan lagu ke playlist (sengaja tidak dihandle karena merupakan Trigger Hijau)
@login_required
def add_song_to_playlist(request, id_user_playlist):
    if request.method == 'POST':
        id_song = request.POST['song_id']
        
        try:
            with connection.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO PLAYLIST_SONG (id_playlist, id_song) 
                    VALUES ((SELECT id_playlist FROM USER_PLAYLIST WHERE id_user_playlist = %s), %s)
                """, [id_user_playlist, id_song])
            return JsonResponse({'message': 'Lagu berhasil ditambahkan ke playlist'}, status=200,)
        except psycopg2.errors.RaiseException as e:
            if str(e).startswith('Lagu sudah ada dalam playlist'):
                return JsonResponse({'message': 'Lagu sudah ada dalam playlist'}, status=400)
            else:
                return JsonResponse({'message': 'Terjadi kesalahan'}, status=500)
    else:
        return JsonResponse({'message': 'Invalid request method'}, status=400)


# View untuk menghapus lagu dari playlist
@login_required
def remove_song_from_playlist(request, id_user_playlist, id_song):
    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM PLAYLIST_SONG WHERE id_playlist = (SELECT id_playlist FROM USER_PLAYLIST WHERE id_user_playlist = %s) AND id_song = %s", [id_user_playlist, id_song])
        return redirect(reverse('playlist_detail') + f'?id={id_user_playlist}')
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

@login_required
def download_song(request, song_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO DOWNLOADED_SONG (id_song, email_downloader)
                VALUES (%s, %s)
            """, [song_id, request.session['email']])
    except Exception as e:
        return JsonResponse({'message': str(e)}, status=400)

    return JsonResponse({'message': 'Berhasil mengunduh Lagu dengan judul ‘Song1’!'})

@login_required
def song_detail_view(request, song_id):
    if request.method == 'POST':
        progress = int(request.POST.get('progress', 0))
        if progress > 70:
            play_song(request, song_id)
            return HttpResponseRedirect(reverse('song_detail', args=(song_id,)))
        else:
            messages.warning(request, str('Progress harus lebih dari 70% untuk menghitung play.'))

    with connection.cursor() as cursor:
        # Ambil detail lagu
        cursor.execute("""
            SELECT KONTEN.judul, AKUN.nama, KONTEN.durasi, ALBUM.judul, KONTEN.tanggal_rilis, KONTEN.tahun, 
                   COALESCE((SELECT COUNT(*) FROM AKUN_PLAY_SONG WHERE id_song = KONTEN.id), 0) AS total_play,
                   COALESCE((SELECT COUNT(*) FROM DOWNLOADED_SONG WHERE id_song = KONTEN.id), 0) AS total_download,
                   STRING_AGG(DISTINCT GENRE.genre, ', ') AS genres,
                   STRING_AGG(DISTINCT SONGWRITER.email_akun, ', ') AS songwriters
            FROM KONTEN
            INNER JOIN SONG ON KONTEN.id = SONG.id_konten
            INNER JOIN ARTIST ON SONG.id_artist = ARTIST.id
            INNER JOIN AKUN ON ARTIST.email_akun = AKUN.email
            LEFT JOIN ALBUM ON SONG.id_album = ALBUM.id
            LEFT JOIN SONGWRITER_WRITE_SONG ON SONG.id_konten = SONGWRITER_WRITE_SONG.id_song
            LEFT JOIN SONGWRITER ON SONGWRITER_WRITE_SONG.id_songwriter = SONGWRITER.id
            LEFT JOIN GENRE ON KONTEN.id = GENRE.id_konten
            WHERE KONTEN.id = %s
            GROUP BY KONTEN.id, AKUN.nama, ALBUM.judul
        """, [song_id])
        song = cursor.fetchone()

        if not song:
            return render(request, 'now_playing.html', {'error': 'Lagu tidak ditemukan'})

        # Ambil daftar playlist pengguna untuk modal "Add to Playlist"
        cursor.execute("""
            SELECT id_user_playlist, judul 
            FROM USER_PLAYLIST 
            WHERE email_pembuat = %s
        """, [request.session['email']])
        playlists = cursor.fetchall()

    context = {
        'song': {
            'id': song_id,
            'judul': song[0],
            'artist_name': song[1],
            'durasi': song[2],
            'album_title': song[3],
            'tanggal_rilis': song[4],
            'tahun': song[5],
            'total_play': song[6],
            'total_download': song[7],
            'genres': song[8] or '',
            'songwriters': song[9] or ''
        },
        'playlists': [{'id': playlist[0], 'judul': playlist[1]} for playlist in playlists],
        'is_premium': request.session['is_premium'],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }
    return render(request, 'now_playing.html', context)


@login_required
def shuffle_play(request):
    if request.method == 'POST':
        playlist_id = request.POST.get('playlist_id')
        timestamp = now()
        
        with connection.cursor() as cursor:
            # Tambah entry ke AKUN_PLAY_USER_PLAYLIST
            cursor.execute("""
                INSERT INTO AKUN_PLAY_USER_PLAYLIST (email_pemain, id_user_playlist, email_pembuat, waktu) 
                VALUES (%s, %s, %s, %s)
            """, [request.session['email'], playlist_id, request.session['email'], timestamp])
            
            # Ambil semua lagu dari playlist
            cursor.execute("""
                SELECT id_song 
                FROM PLAYLIST_SONG 
                WHERE id_playlist = (SELECT id_playlist FROM USER_PLAYLIST WHERE id_user_playlist = %s)
            """, [playlist_id])
            songs = cursor.fetchall()
            
            # Tambah entry ke AKUN_PLAY_SONG untuk setiap lagu dalam playlist
            for song in songs:
                cursor.execute("""
                    INSERT INTO AKUN_PLAY_SONG (email_pemain, id_song, waktu) 
                    VALUES (%s, %s, %s)
                """, [request.session['email'], song[0], timestamp])
        
        return JsonResponse({'message': 'Playlist berhasil di shuffle play!'})
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=400)

@login_required
def play_song(request, song_id):
    if request.method == 'POST':
        timestamp = now()
        
        try:
            with connection.cursor() as cursor:
                # Tambah entry ke AKUN_PLAY_SONG
                cursor.execute("""
                    INSERT INTO AKUN_PLAY_SONG (email_pemain, id_song, waktu) 
                    VALUES (%s, %s, %s)
                """, [request.session['email'], song_id, timestamp])
            return HttpResponse('Lagu berhasil dimainkan!')
        except IntegrityError as e:
            return HttpResponse(str(e), status=400)
        except Exception as e:
            return HttpResponse('Terjadi kesalahan saat memainkan lagu.', status=500)
    else:
        return HttpResponse('Invalid request method', status=400)

@login_required
def play_song2(request):
    if request.method == 'POST':
        song_id = request.POST.get('song_id')
        timestamp = now()
        
        with connection.cursor() as cursor:
            # Tambah entry ke AKUN_PLAY_SONG
            cursor.execute("""
                INSERT INTO AKUN_PLAY_SONG (email_pemain, id_song, waktu) 
                VALUES (%s, %s, %s)
            """, [request.session['email'], song_id, timestamp])
        
        return JsonResponse({'message': 'Lagu berhasil dimainkan!'})
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=400)




#=================================================BLUE FUNCTIONS===================================================
#=================================================BLUE FUNCTIONS===================================================
#=================================================BLUE FUNCTIONS===================================================




def chart_details(request):
    context = {
        'is_premium' : request.session['is_premium'],
        'is_songwriter' : request.session['is_songwriter'],
        'is_artist' : request.session['is_artist'],
        'is_podcaster' : request.session['is_podcaster'],
        'is_label' :request.session['is_label']
    }
    return render(request, 'chart_details.html', context)

def chart_view(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT tipe FROM chart")
        charts = cursor.fetchall()
    
    context = {
        'charts': [{'tipe': row[0]} for row in charts],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }

    return render(request, 'chart_list.html', context)

@login_required(login_url='/login/')
def chart_details(request):
    tipe_top = request.GET.get('tipe_top')
    with connection.cursor() as cursor:
        if tipe_top == "Daily Top 20":
            cursor.execute("""
                SELECT konten.id, konten.judul AS "Judul Lagu", akun.nama AS "Oleh", konten.tanggal_rilis AS "Tanggal Rilis", COUNT(*) AS "Total Plays"
                FROM akun_play_song
                JOIN song ON akun_play_song.id_song = song.id_konten 
                JOIN konten ON song.id_konten = konten.id 
                JOIN artist ON song.id_artist = artist.id 
                JOIN akun ON artist.email_akun = akun.email
                WHERE akun_play_song.waktu::date <= DATE(CURRENT_DATE)
                GROUP BY konten.id, konten.judul, akun.nama, konten.tanggal_rilis
                ORDER BY "Total Plays" DESC
                LIMIT 20;
            """)

        elif tipe_top == "Weekly Top 20":
            cursor.execute("""
                SELECT konten.id, konten.judul AS "Judul Lagu", akun.nama AS "Oleh", konten.tanggal_rilis AS "Tanggal Rilis", COUNT(*) AS "Total Plays"
                FROM akun_play_song
                JOIN song ON akun_play_song.id_song = song.id_konten JOIN konten ON song.id_konten = konten.id JOIN artist ON song.id_artist = artist.id JOIN akun ON artist.email_akun = akun.email
                WHERE akun_play_song.waktu <= date_trunc('week', CURRENT_DATE)
                GROUP BY konten.id, konten.judul, akun.nama, konten.tanggal_rilis
                ORDER BY "Total Plays" DESC
                LIMIT 20;
            """)
        elif tipe_top== "Monthly Top 20":
            cursor.execute("""
                SELECT konten.id, konten.judul AS "Judul Lagu", akun.nama AS "Oleh", konten.tanggal_rilis AS "Tanggal Rilis", COUNT(*) AS "Total Plays"
                FROM akun_play_song
                JOIN song ON akun_play_song.id_song = song.id_konten JOIN konten ON song.id_konten = konten.id JOIN artist ON song.id_artist = artist.id JOIN akun ON artist.email_akun = akun.email
                WHERE akun_play_song.waktu <= date_trunc('month', CURRENT_DATE)
                GROUP BY konten.id, konten.judul, akun.nama, konten.tanggal_rilis
                ORDER BY "Total Plays" DESC
                LIMIT 20;
            """)
        elif tipe_top == "Yearly Top 20":
            cursor.execute("""
                SELECT konten.id, konten.judul AS "Judul Lagu", akun.nama AS "Oleh", konten.tanggal_rilis AS "Tanggal Rilis", COUNT(*) AS "Total Plays"
                FROM akun_play_song
                JOIN song ON akun_play_song.id_song = song.id_konten JOIN konten ON song.id_konten = konten.id JOIN artist ON song.id_artist = artist.id JOIN akun ON artist.email_akun = akun.email
                WHERE akun_play_song.waktu >= date_trunc('year', CURRENT_DATE)
                GROUP BY konten.id, konten.judul, akun.nama, konten.tanggal_rilis
                ORDER BY "Total Plays" DESC
                LIMIT 20;
            """)
        else:
            return render(request, 'chart_list.html')
        song_favorit = cursor.fetchall()
    
    context = {
        'judul': tipe_top,
        'list_song': [
            {
                'id_lagu': row[0],
                'title': row[1],
                'artist': row[2],
                'release_date': row[3].strftime('%d/%m/%Y'),
                'total_plays': row[4]
            } for row in song_favorit],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }
    
    return render(request, 'chart_details.html', context)

@login_required
def kelola_podcast(request):
    email = request.session.get('email')
    
    # Periksa apakah pengguna adalah podcaster
    with connection.cursor() as cursor:
        cursor.execute('SELECT COUNT(*) FROM podcaster WHERE email = %s', [email])
        is_podcaster = cursor.fetchone()[0] > 0
    
    context = {
        'is_podcaster': is_podcaster,
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
        
    }

    return render(request, 'awal_kelola_podcast.html', context)

def list_podcast(request):
    return render(request, 'list_podcast.html')

def create_podcast(request):
    records_genre = []
    
    if request.method == 'POST':
        judul = request.POST.get('judul')
        id_podcast = str(uuid.uuid4())
        genres = request.POST.getlist('genre[]')
        
        # Cek apakah email_podcaster tersedia di cookie
        email_podcaster = request.session.get('email')
        if not email_podcaster:
            return redirect('login')  
        
        # Insert ke tabel konten
        current_datetime = datetime.datetime.now()
        date_now = current_datetime.strftime('%Y-%m-%d')
        current_year = current_datetime.year

        with connection.cursor() as cursor:
            cursor.execute(
                'INSERT INTO konten (id, judul, tanggal_rilis, tahun, durasi) VALUES (%s, %s, %s, %s, %s)',
                (id_podcast, judul, date_now, current_year, 0)  
            )

            cursor.execute(
                'INSERT INTO podcast (id_konten, email_podcaster) VALUES (%s, %s)',
                (id_podcast, email_podcaster)
            )

            # Insert ke genre
            for genre in genres:
                cursor.execute(
                    'INSERT INTO genre (id_konten, genre) VALUES (%s, %s)',
                    (id_podcast, genre)
                )

            connection.commit()
        return redirect('list_podcast')  # Mengarahkan ke halaman daftar podcast

    # Untuk pilihan dropdown genre
    with connection.cursor() as cursor:
        cursor.execute('SELECT DISTINCT genre FROM genre')
        records_genre = cursor.fetchall()
    
    context = {
        'records_genre': records_genre,
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }

    return render(request, 'create_podcast.html', context)

def list_podcast(request):
    email = request.session.get('email')
    with connection.cursor() as cursor:

        cursor.execute("""
            SELECT konten.id, konten.judul AS podcast_title, COALESCE(SUM(episode.durasi), 0) AS total_durasi, COUNT(episode.id_konten_podcast) AS jumlah_episode
            FROM podcast
            JOIN konten ON podcast.id_konten = konten.id
            LEFT JOIN episode ON podcast.id_konten = episode.id_konten_podcast
            WHERE podcast.email_podcaster = %s
            GROUP BY konten.id, konten.judul
        """, [email])
        
        result = cursor.fetchall()

    context = {
        'podcasts': [
            {'podcast_id':row[0],
             'judul': row[1],
             'jumlah_episode': row[3], 
             'total_durasi': f"{row[2]} menit"} for row in result
        ],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }

    return render(request, 'list_podcast.html', context)


def create_episode(request):
    podcast_id = request.GET.get('podcast_id')
    if request.method == 'POST':
        # Mendapatkan data yang dikirimkan melalui form
        judul = request.POST.get('judul')
        deskripsi = request.POST.get('deskripsi')
        durasi = request.POST.get('durasi')
        id_episode = uuid.uuid4()
        current_datetime = datetime.datetime.now()
        date_now = current_datetime.strftime('%Y-%m-%d')

        # Insert data episode ke dalam database
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO episode (
                    id_episode, id_konten_podcast, judul, deskripsi, durasi, tanggal_rilis
                ) VALUES (%s, %s, %s, %s, %s, %s)
            """, [id_episode, podcast_id, judul, deskripsi, durasi, date_now])
        connection.commit()
        # Redirect ke halaman list episode setelah membuat episode
        return HttpResponseRedirect(reverse('daftar_episode') + f'?podcast_id={podcast_id}')

    else:
        # Mengambil informasi podcast yang dipilih
        with connection.cursor() as cursor:
            cursor.execute(
                'SELECT judul FROM konten WHERE id = %s', (podcast_id,)
            )
            podcast_title = cursor.fetchone()

        context = {
            'podcast_title': podcast_title,
            'is_premium': request.session['is_premium'],
            'is_songwriter': request.session['is_songwriter'],
            'is_artist': request.session['is_artist'],
            'is_podcaster': request.session['is_podcaster'],
            'is_label': request.session['is_label']
        }

        return render(request, 'create_episode.html', context)
    
def delete_podcast(request):
    podcast_id = request.POST.get('podcast_id')
    
    with connection.cursor() as cursor:
        cursor.execute(
            'DELETE FROM podcast WHERE id_konten = %s', [podcast_id]
        )
        cursor.execute(
            'DELETE FROM konten WHERE id = %s', [podcast_id]
        )
        connection.commit()
    
    return HttpResponseRedirect(reverse('list_podcast'))

def daftar_episode(request):
    podcast_id = request.GET.get('podcast_id')
    
    if not podcast_id:
        return HttpResponse("Podcast ID is missing")
    
    with connection.cursor() as cursor:
        cursor.execute("""
                SELECT konten.id, konten.judul 
                FROM konten
                JOIN podcast ON konten.id = podcast.id_konten
                WHERE podcast.id_konten = %s """, [podcast_id])
        podcast = cursor.fetchone()
        cursor.execute("""
                SELECT judul, deskripsi, durasi, tanggal_rilis, episode.id_episode
                FROM episode 
                WHERE id_konten_podcast = %s;
                """, [podcast_id])
        episodes = cursor.fetchall()
    
    context = {
        'podcast': podcast,
        'episodes': episodes,
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }
    
    return render(request, 'daftar_episode.html', context)

def delete_episode(request):
    episode_id = request.GET.get('episode_id')
    podcast_id = request.GET.get('podcast_id')

    print(f"Request URL: {request.build_absolute_uri()}")
    print(f"episode_id: {episode_id}, podcast_id: {podcast_id}")

    if not episode_id or not podcast_id:
        error_message = "Podcast ID or Episode ID is missing."
        if podcast_id:
            return HttpResponseRedirect(reverse('daftar_episode') + f'?podcast_id={podcast_id}&error_message={error_message}')
        else:
            return HttpResponse(error_message)

    with connection.cursor() as cursor:
        cursor.execute('DELETE FROM episode WHERE id_episode = %s', [episode_id])
        connection.commit()

    return HttpResponseRedirect(reverse('daftar_episode') + f'?podcast_id={podcast_id}')

def play_podcast(request):
    podcast_id = request.GET.get('podcast_id')
    data_podcast = {}
    data_episode = []

    # Query to get podcast details
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT 
                konten.judul, 
                konten.tanggal_rilis, 
                konten.tahun, 
                akun.nama AS podcaster_name,
                COALESCE(SUM(episode.durasi), 0) AS total_durasi
            FROM 
                podcast
            JOIN 
                podcaster ON podcast.email_podcaster = podcaster.email 
            JOIN 
                akun ON podcaster.email = akun.email 
            JOIN 
                konten ON podcast.id_konten = konten.id 
            LEFT JOIN 
                episode ON podcast.id_konten = episode.id_konten_podcast
            WHERE 
                podcast.id_konten = %s
            GROUP BY 
                konten.id, konten.judul, konten.tanggal_rilis, konten.tahun, akun.nama;
        """, [podcast_id])
        result = cursor.fetchone()
        if result:
            duration = result[4] if result[4] else 0
            hours = duration // 60
            minutes = duration % 60
            formatted_duration = f"{hours} jam {minutes} menit" if hours > 0 else f"{minutes} menit"
            data_podcast = {
                'judul': result[0],
                'date': result[1].strftime('%d/%m/%Y'),
                'tahun': result[2],
                'podcaster': result[3],
                'duration': formatted_duration
            }

    # Query to get genres
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT DISTINCT genre 
            FROM genre 
            WHERE id_konten = %s
        """, [podcast_id])
        result = cursor.fetchall()
        if result:
            data_podcast['genre'] = [row[0] for row in result]

    # Query to get episodes details
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT judul, deskripsi, durasi, tanggal_rilis
            FROM episode
            WHERE id_konten_podcast = %s
        """, [podcast_id])
        kumpulan_episode = cursor.fetchall()
        for episode in kumpulan_episode:
            duration_hours = episode[2] // 60
            duration_minutes = episode[2] % 60
            formatted_duration = f"{duration_hours} jam {duration_minutes} menit" if duration_hours else f"{duration_minutes} menit"

            data_episode.append({
                'title': episode[0],
                'description': episode[1],
                'duration': formatted_duration,
                'date': episode[3].strftime('%d/%m/%Y')
            })

    context = {
        'detail_podcast': data_podcast,
        'kumpulan_episode': data_episode,
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }
    messages.success(request, 'Podcast Played.')
    return render(request, 'awal_play_podcast.html', context)

def all_podcasts(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT konten.id, konten.judul, akun.nama AS podcaster_name, SUM(episode.durasi) AS total_durasi, COUNT(episode.id_konten_podcast) AS jumlah_episode
            FROM podcast
            JOIN konten ON podcast.id_konten = konten.id
            JOIN podcaster ON podcast.email_podcaster = podcaster.email
            JOIN akun ON podcaster.email = akun.email
            LEFT JOIN episode ON podcast.id_konten = episode.id_konten_podcast
            GROUP BY konten.id, konten.judul, akun.nama
        """)
        podcasts = cursor.fetchall()

    context = {
        'podcasts': [
            {
                'podcast_id': row[0],
                'judul': row[1],
                'podcaster_name': row[2],
                'total_durasi': f"{row[3]} menit" if row[3] else "0 menit",
                'jumlah_episode': row[4]
            } for row in podcasts
        ],
        'is_premium': request.session['is_premium'],
        'is_songwriter': request.session['is_songwriter'],
        'is_artist': request.session['is_artist'],
        'is_podcaster': request.session['is_podcaster'],
        'is_label': request.session['is_label']
    }

    return render(request, 'all_podcasts.html', context)



#=================================================RED FUNCTIONS===================================================
#=================================================RED FUNCTIONS===================================================
#=================================================RED FUNCTIONS===================================================


@login_required(login_url='/login/')
def get_albums(request):  
    email = request.session['email'] 
    artists = f"""
        SELECT id_album 
        FROM SONG
        WHERE id_artist IN (
            SELECT id
            FROM ARTIST
            WHERE email_akun = '{ email }'
        )
    """
    songwriters = f"""
        SELECT id_album 
        FROM SONG
        WHERE id_konten IN (
            SELECT id_song
            FROM SONGWRITER_WRITE_SONG
            WHERE id_songwriter IN (
                SELECT id
                FROM SONGWRITER
                WHERE email_akun = '{ email }'
            ) 
        )
    """
    
    get_album_from = """
        SELECT ALBUM.id, judul, LABEL.nama ,jumlah_lagu, total_durasi
        FROM ALBUM JOIN LABEL 
        ON id_label = LABEL.id
        WHERE ALBUM.id IN
    """

    get_album_from_label = f"""
        SELECT ALBUM.id, judul, LABEL.nama ,jumlah_lagu, total_durasi
        FROM ALBUM JOIN LABEL 
        ON id_label = LABEL.id
        WHERE LABEL.email = '{ email }'
    """
    with connection.cursor() as cursor:
        if request.session['is_artist']:
            if request.session['is_songwriter']:
                cursor.execute(get_album_from + "(" + artists + " UNION " 
                               + songwriters + ")")
            else:
                cursor.execute(get_album_from + "(" + artists + ")")
        elif request.session['is_songwriter']:
            cursor.execute(get_album_from + "(" + songwriters + ")")
        elif request.session['is_label']:
            cursor.execute(get_album_from_label)
        else:
            response = HttpResponse()
            response.status_code = 403
            return response
        result = dictfetchall(cursor)
    return result

@login_required(login_url='/login/')
def list_album(request):
    context = {
        'albums' : get_albums(request),
        'is_premium' : request.session['is_premium'],
        'is_songwriter' : request.session['is_songwriter'],
        'is_artist' : request.session['is_artist'],
        'is_podcaster' : request.session['is_podcaster'],
        'is_label' :request.session['is_label']
    }
    return render(request, 'album/list_album.html', context)

@login_required(login_url='/login/')
def get_songs(request, id):
    query = f"""
        SELECT KONTEN.id, KONTEN.judul, KONTEN.durasi, SONG.total_play, SONG.total_download
        FROM KONTEN JOIN SONG ON KONTEN.id = SONG.id_konten
        WHERE SONG.id_album = '{ id }'
    """
    with connection.cursor() as cursor:
        cursor.execute(query)
        result = dictfetchall(cursor)
        return result

@login_required(login_url='/login/')
def list_song(request, id):
    query = f"""
        SELECT judul
        FROM ALBUM
        WHERE id = '{id}'
    """
    with connection.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchone()
    context = {
        'songs' : get_songs(request, id),
        'album_nama' : result[0],
        'album_id' : id,
        'is_premium' : request.session['is_premium'],
        'is_songwriter' : request.session['is_songwriter'],
        'is_artist' : request.session['is_artist'],
        'is_podcaster' : request.session['is_podcaster'],
        'is_label' :request.session['is_label']
    }
    return render(request, 'album/list_lagu.html', context)

@login_required(login_url='/login/')
def get_artists(request):
    if request.session['is_artist']:
        query = f"""
            SELECT DISTINCT id, nama
            FROM AKUN JOIN ARTIST ON AKUN.email = ARTIST.email_akun
            WHERE AKUN.email = '{ request.session['email'] }'
        """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result
    else:
        query = """
            SELECT DISTINCT id, nama
            FROM AKUN JOIN ARTIST ON AKUN.email = ARTIST.email_akun
            ORDER BY nama
        """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result

@login_required(login_url='/login/')
def get_songwriters(request):
    if request.session['is_songwriter']:
        query = f"""
            SELECT WRITERS.id, WRITERS.nama
            FROM (SELECT id, nama
            FROM AKUN JOIN SONGWRITER ON AKUN.email = SONGWRITER.email_akun
            EXCEPT
            SELECT id, nama
            FROM AKUN JOIN SONGWRITER ON AKUN.email = SONGWRITER.email_akun
            WHERE AKUN.email = '{ request.session['email'] }') AS WRITERS
            ORDER BY WRITERS.nama ASC
        """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result
    else:
        query = """
            SELECT DISTINCT id, nama
            FROM AKUN JOIN SONGWRITER ON AKUN.email = SONGWRITER.email_akun
            ORDER BY nama
        """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result

@login_required(login_url='/login/')        
def get_original_writer(request) :
    if request.session['is_songwriter']:
        query = f"""
            SELECT DISTINCT id, nama
            FROM AKUN JOIN SONGWRITER ON AKUN.email = SONGWRITER.email_akun
            WHERE AKUN.email = '{ request.session['email'] }'
        """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result

@login_required(login_url='/login/')
def get_genres(request):
    query = """
            SELECT DISTINCT genre
            FROM GENRE
            ORDER BY genre
        """
    with connection.cursor() as cursor:
        cursor.execute(query)
        result = dictfetchall(cursor)
        return result

@login_required(login_url='/login/')
def get_labels(request):
    if request.session['is_label']:
        query = f"""
                SELECT id, nama
                FROM LABEL 
                WHERE email = { request.sesson['email'] }
            """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result
    else:
        query = """
                SELECT DISTINCT id, nama
                FROM LABEL
                ORDER BY nama
            """
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = dictfetchall(cursor)
            return result

@login_required(login_url='/login/')
def create_album(request):
    if request.method == "GET":
        context = {
            'labels' : get_labels(request),
            'artists' : get_artists(request),
            'songwriters' : get_songwriters(request),
            'originalwriter' : get_original_writer(request),
            'genres' : get_genres(request),
            'is_premium' : request.session['is_premium'],
            'is_songwriter' : request.session['is_songwriter'],
            'is_artist' : request.session['is_artist'],
            'is_podcaster' : request.session['is_podcaster'],
            'is_label' : request.session['is_label'],
        }
        return render(request, 'album/create_album.html', context)
    elif request.method == "POST":
        current_date = datetime.datetime.now()
        formatted_date = current_date.strftime('%Y-%m-%d')
        album_uuid = uuid.uuid4()
        song_uuid = uuid.uuid4()
        with connection.cursor() as cursor:
            query = f"""
                INSERT INTO ALBUM (id, judul, jumlah_lagu, id_label, total_durasi)
                VALUES ('{album_uuid}', '{request.POST["judul"]}', 0, '{request.POST["label"]}', {request.POST["durasi"]})
            """
            cursor.execute(query)

            query = f"""
                INSERT INTO Konten (id, judul, tanggal_rilis, tahun, durasi)
                VALUES ('{song_uuid}', '{request.POST["judulLagu"]}', '{formatted_date}', {current_date.year}, {request.POST["durasi"]})              
            """
            cursor.execute(query)

            query = f"""
                INSERT INTO SONG (id_konten, id_artist, id_album, total_play, total_download)
                VALUES ('{song_uuid}', '{request.POST["artist"]}', '{album_uuid}', 0, 0)             
            """
            cursor.execute(query)

            for writer in request.POST.getlist("songwriter"):
                query = f"""
                    INSERT INTO SONGWRITER_WRITE_SONG (id_songwriter, id_song)
                    VALUES ('{writer}', '{song_uuid}')
                """
                cursor.execute(query)

            for genre_item in request.POST.getlist("genre"):
                query = f"""
                    INSERT INTO Genre (id_konten, genre)
                    VALUES ('{song_uuid}', '{genre_item}')
                """
                cursor.execute(query)
        return HttpResponseRedirect(reverse("list_album"))

@login_required(login_url='/login/')
def create_song(request, album_id = ''):
    if request.method == "GET":
        with connection.cursor() as cursor:
            query = f"""
                SELECT judul
                FROM ALBUM
                WHERE id = '{album_id}' 
            """
            cursor.execute(query)
            result = cursor.fetchone()
            result = result[0]
        context = {
            'album_name' : result,
            'album_id' : album_id,
            'artists' : get_artists(request),
            'songwriters' : get_songwriters(request),
            'originalwriter' : get_original_writer(request),
            'genres' : get_genres(request),
            'is_premium' : request.session['is_premium'],
            'is_songwriter' : request.session['is_songwriter'],
            'is_artist' : request.session['is_artist'],
            'is_podcaster' : request.session['is_podcaster'],
            'is_label' : request.session['is_label'],
        }
        return render(request, 'album/create_lagu.html', context)
    elif request.method == "POST":
        current_date = datetime.datetime.now()
        formatted_date = current_date.strftime('%Y-%m-%d')
        song_uuid = uuid.uuid4()
        with connection.cursor() as cursor:
            query = f"""
                INSERT INTO Konten (id, judul, tanggal_rilis, tahun, durasi)
                VALUES ('{song_uuid}', $${request.POST["judul"]}$$, '{formatted_date}', {current_date.year}, {request.POST["durasi"]})              
            """
            cursor.execute(query)

            query = f"""
                INSERT INTO SONG (id_konten, id_artist, id_album, total_play, total_download)
                VALUES ('{song_uuid}', '{request.POST["artist"]}', '{album_id}', 0, 0)             
            """
            cursor.execute(query)

            for writer in request.POST.getlist("songwriter"):
                query = f"""
                    INSERT INTO SONGWRITER_WRITE_SONG (id_songwriter, id_song)
                    VALUES ('{writer}', '{song_uuid}')
                """
                cursor.execute(query)

            for genre_item in request.POST.getlist("genre"):
                query = f"""
                    INSERT INTO Genre (id_konten, genre)
                    VALUES ('{song_uuid}', '{genre_item}')
                """
                cursor.execute(query)
        return HttpResponseRedirect(reverse("list_song", args=(album_id,)))

@login_required(login_url='/login/')
def get_royalti(request):
    email = request.session['email']
    if request.session['is_label']:
        query = f"""
            SELECT DISTINCT KONTEN.judul, C.judul AS judul_album, total_play, total_download, rate_royalti * total_play AS royalti
            FROM KONTEN JOIN (
                SELECT SONG.id_konten, SONG.total_play, SONG.total_download, B.judul, B.rate_royalti
                FROM SONG JOIN (
                    SELECT ALBUM.id, ALBUM.judul, A.rate_royalti
                    FROM ALBUM JOIN (
                        SELECT LABEL.id, PEMILIK_HAK_CIPTA.rate_royalti
                        FROM LABEL JOIN PEMILIK_HAK_CIPTA 
                        ON LABEL.id_pemilik_hak_cipta = PEMILIK_HAK_CIPTA.id
                        WHERE LABEL.email = '{ email }'
                    ) AS A ON ALBUM.id_label = A.id
                ) AS B ON SONG.id_album = B.id
            ) AS C ON KONTEN.id = C.id_konten
            ORDER BY C.judul
        """
    elif request.session['is_artist'] or request.session['is_songwriter']:
        query = f"""
            SELECT DISTINCT E.judul, ALBUM.judul AS judul_album, total_play, total_download, total_play * rate_royalti AS royalti
            FROM ALBUM JOIN (
                SELECT KONTEN.judul, D.id_album, D.rate_royalti, D.total_download, D.total_play
                FROM KONTEN JOIN (
                    SELECT id_konten, id_album, B.rate_royalti, total_download, total_play   
                    FROM SONG JOIN (
                        SELECT id_song AS id, rate_royalti
                        FROM SONGWRITER_WRITE_SONG JOIN(
                            SELECT SONGWRITER.id, rate_royalti
                            FROM SONGWRITER JOIN PEMILIK_HAK_CIPTA
                            ON PEMILIK_HAK_CIPTA.id = id_pemilik_hak_cipta
                            WHERE email_akun = '{ email }'
                        ) AS A ON A.id = id_songwriter
                    ) AS B ON SONG.id_konten = B.id
                    UNION
                    SELECT id_konten, id_album, C.rate_royalti, total_download, total_play
                    FROM SONG JOIN (
                        SELECT ARTIST.id, rate_royalti
                        FROM ARTIST JOIN PEMILIK_HAK_CIPTA 
                        ON PEMILIK_HAK_CIPTA.id = id_pemilik_hak_cipta
                        WHERE email_akun = '{ email }'
                    ) AS C ON SONG.id_artist = C.id
                ) AS D ON D.id_konten = KONTEN.id
            )AS E ON ALBUM.id = E.id_album
            ORDER BY ALBUM.judul
        """
    else:
        return None
    with connection.cursor() as cursor:
        cursor.execute(query)
        result = dictfetchall(cursor)
        return result
    

@login_required(login_url='/login/')
def check_royalty(request):
    result = get_royalti(request)
    if result is None:
        return JsonResponse({'success': False, 'message': 'User not authorized'})    
    context = {
        'royalties' : result,
        'is_premium' : request.session['is_premium'],
        'is_songwriter' : request.session['is_songwriter'],
        'is_artist' : request.session['is_artist'],
        'is_podcaster' : request.session['is_podcaster'],
        'is_label' : request.session['is_label'],
    }
    return render(request, 'album/cek_royalti.html', context)

@login_required
def remove_song(request, id_album, id_song):
    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute(f"DELETE FROM SONG WHERE SONG.id_konten = '{id_song}'")
            cursor.execute(f"DELETE FROM KONTEN WHERE KONTEN.id = '{id_song}'")
        return redirect(reverse('list_song', args=(id_album,)))
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})
    
@login_required
def remove_album(request, id_album):
    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute(f"""DELETE FROM KONTEN WHERE KONTEN.id IN(
                            SELECT SONG.id_konten FROM SONG
                            WHERE SONG.id_album = '{id_album}'
                           """)
            cursor.execute(f"DELETE FROM ALBUM WHERE ALBUM.id = '{id_album}'")
        return redirect(reverse('list_album'))
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

def dictfetchall(cursor):
    """
    Return all rows from a cursor as a dict.
    Assume the column names are unique.
    """
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]