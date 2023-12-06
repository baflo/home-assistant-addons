# paperless_app/urls.py
from django.urls import path
from .views import InboxCountView, TaskCountView

urlpatterns = [
    path('inbox/', InboxCountView.as_view()),
    path('inbox/<str:username>', InboxCountView.as_view()),
    path('task/', TaskCountView.as_view()),
    path('task/<str:username>', TaskCountView.as_view()),
]

