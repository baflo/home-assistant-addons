# paperless_app/urls.py
from django.urls import path
from .views import InboxCountView, TodoCountView

urlpatterns = [
    path('inbox/', InboxCountView.as_view()),
    path('inbox/<str:username>', InboxCountView.as_view()),
    path('todo/', TodoCountView.as_view()),
    path('todo/<str:username>', TodoCountView.as_view()),
]

