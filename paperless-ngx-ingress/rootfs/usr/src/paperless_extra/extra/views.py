# paperless_app/views.py
from django.http import JsonResponse
from django.views import View
import requests
import os

class InboxCountView(View):
    def get(self, request, username=None, *args, **kwargs):
        # Extrahiere den X-Remote-User-Name Header aus dem eingehenden Request
        if username is None:
            username = self.request.headers.get('X-Remote-User-Name')

        # Rufe die Umgebungsvariablen für die Basic Authentication ab
        admin_user = os.environ.get('PAPERLESS_ADMIN_USER')
        admin_pass = os.environ.get('PAPERLESS_ADMIN_PASSWORD')

        # Rufe den Service http://localhost:8000/api/users auf mit Basic Authentication
        users_url = 'http://localhost:8000/api/users/'
        response_users = requests.get(users_url, auth=(admin_user, admin_pass))
        users_data = response_users.json()

        # Suche die userid für den angegebenen username
        userid = None
        for user in users_data.get('results'):
            if user.get('username') == username:
                userid = user.get('id')
                break

        # Rufe den Service http://localhost:8000/api/documents/?owner__id=userid auf mit Basic Authentication
        if userid is not None:
            documents_url = f'http://localhost:8000/api/documents/?owner__id={userid}'
            response_documents = requests.get(documents_url, auth=(admin_user, admin_pass))
            documents_data = response_documents.json()

            # Extrahiere den Wert des "counts" Schlüssels
            counts_value = documents_data.get('count', None)

            return JsonResponse({'count': counts_value})
        else:
            return JsonResponse({'error': 'User not found'}, status=404)

