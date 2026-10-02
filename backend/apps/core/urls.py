from django.http import HttpRequest, JsonResponse
from django.urls import path


def health(_request: HttpRequest) -> JsonResponse:
    return JsonResponse({"status": "ok"})


urlpatterns = [path("health/", health, name="health")]
