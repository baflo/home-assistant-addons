# paperless_app/views.py
from django.http import JsonResponse
from django.views import View
import requests
import os

class CountByTagView(View):
    def getByPredicate(self, request, tagPredicateLambda, username=None, *args, **kwargs):
        # Extrahiere den X-Remote-User-Name Header aus dem eingehenden Request
        if username is None:
            username = self.request.headers.get('X-Remote-User-Name')

        # Rufe die Umgebungsvariablen für die Basic Authentication ab
        admin_user = os.environ.get('PAPERLESS_ADMIN_USER')
        admin_pass = os.environ.get('PAPERLESS_ADMIN_PASSWORD')

        auth = (admin_user, admin_pass)

        # Rufe den Service http://localhost:8000/api/users/ auf mit Basic Authentication
        users_url = 'http://localhost:8000/api/users/'
        response_users = requests.get(users_url, auth=auth)
        users_data = response_users.json()

        # Rufe den Service http://localhost:8000/api/tags/ auf mit Basic Authentication
        tags_url = 'http://localhost:8000/api/tags/'
        response_tags = requests.get(tags_url, auth=auth)
        tags_data = response_tags.json()
        inbox_tags = ",".join([str(tag.id) for tag in tags_data.results if tagPredicateLambda(tag)])

        # Suche die userid für den angegebenen username
        userid = None
        for user in users_data.get('results'):
            if user.get('username') == username:
                userid = user.get('id')
                break

        # Rufe den Service http://localhost:8000/api/documents/?owner__id=userid auf mit Basic Authentication
        if userid is None:
            documents_url = f'http://localhost:8000/api/documents/?owner__id__none&tags__id__in={inbox_tags}'
        else:
            documents_url = f'http://localhost:8000/api/documents/?owner__id={userid}&tags__id__in={inbox_tags}'

        response_documents = requests.get(documents_url, auth=auth)
        documents_data = response_documents.json()

        # Extrahiere den Wert des "counts" Schlüssels
        counts_value = documents_data.get('count', None)

        return JsonResponse({'count': counts_value})

class InboxCountView(CountByTagView):
    def get(self, *args, **kwargs):
        
        return getByPredicate(*args, **kwargs, tagPredicateLambda=lambda tag: tag.is_inbox_tab)


class TaskCountView(CountByTagView):
    def get(self, *args, **kwargs):
        
        return getByPredicate(*args, **kwargs, tagPredicateLambda=lambda tag: tag.slug == "task")
