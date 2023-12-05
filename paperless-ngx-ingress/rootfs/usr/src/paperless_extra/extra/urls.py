# paperless_app/urls.py
from django.urls import path
from .views import InboxCountView

urlpatterns = [
    path('inbox-count/', InboxCountView.as_view()),
    path('inbox-count/<str:username>', InboxCountView.as_view()),
]

