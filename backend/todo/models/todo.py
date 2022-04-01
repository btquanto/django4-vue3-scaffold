from django.db import models
from django.urls import reverse
from django.utils.translation import gettext as _

# pylint: disable=line-too-long
class TodoItem(models.Model):

    # pylint: disable=invalid-name
    class Priority(models.IntegerChoices):
        Urgent = 4, _("Urgent")
        High = 3, _("High")
        Medium = 2, _("Medium")
        Low = 1, _("Low")

    # pylint: disable=invalid-name
    class Status(models.TextChoices):
        InProgress = 'in_progress', _("In Progress")
        Done = 'done', _("Done")

    name = models.CharField(null=False, blank=False, default="", max_length=255)
    description = models.CharField(null=False, blank=False, default="", max_length=255)
    priority = models.SmallIntegerField(null=False, blank=False, choices=Priority.choices, default=Priority.Low)
    status = models.CharField(null=False, blank=False, choices=Status.choices, default=Status.InProgress, max_length=16)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    deleted_at = models.DateTimeField(null=True, default=None)

    class Meta:
        verbose_name = _("Todo Item")
        verbose_name_plural = _("Todo Items")

    # pylint: disable=invalid-str-returned
    def __str__(self):
        return self.name

    def get_absolute_url(self):
        return reverse("TodoItem-details", kwargs={"pk": self.pk})
