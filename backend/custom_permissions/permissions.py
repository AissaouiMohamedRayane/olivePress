from rest_framework.permissions import BasePermission

class IsActiveUser(BasePermission):
    """
    Custom permission to only allow active users.
    """

    def has_permission(self, request, view):
        # Check if the user is authenticated and is active
        return request.user and request.user.is_authenticated and request.user.is_active and request.user.is_staff


class IsSuperUser(BasePermission):
    """
    Custom permission to only allow superusers to access the view.
    """
    def has_permission(self, request, view):
        return request.user and request.user.is_superuser