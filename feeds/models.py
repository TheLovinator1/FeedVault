from __future__ import annotations

import logging
import typing
from typing import Literal

from django.db import models
from django.db.models import JSONField

logger = logging.getLogger(__name__)


class Domain(models.Model):
    """A domain that has one or more feeds."""

    url = models.URLField(unique=True)
    name = models.CharField(max_length=255)
    categories = models.JSONField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)
    hidden = models.BooleanField(default=False)
    hidden_at = models.DateTimeField(null=True, blank=True)
    hidden_reason = models.TextField(blank=True)

    def __str__(self) -> str:
        """Return string representation of the domain."""
        if_hidden: Literal[" (hidden)", ""] = " (hidden)" if self.hidden else ""
        return self.name + if_hidden


class Author(models.Model):
    """An author of an entry."""

    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)
    name = models.TextField(blank=True)
    href = models.TextField(blank=True)
    email = models.TextField(blank=True)

    def __str__(self) -> str:
        """Return string representation of the author."""
        return f"{self.name} - {self.email} - {self.href}"


class Generator(models.Model):
    """A generator of a feed."""

    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)
    name = models.TextField(blank=True)
    href = models.TextField(blank=True)
    version = models.TextField(blank=True)

    class Meta:
        """Meta information for the generator model."""

        unique_together: typing.ClassVar[list[str]] = ["name", "version", "href"]

    def __str__(self) -> str:
        """Return string representation of the generator."""
        return self.name


class Links(models.Model):
    """A link to a feed or entry."""

    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)
    rel = models.TextField(blank=True)
    type = models.TextField(blank=True)
    href = models.TextField(blank=True)
    title = models.TextField(blank=True)

    def __str__(self) -> str:
        """Return string representation of the links."""
        return self.href


class Publisher(models.Model):
    """The publisher of a feed or entry."""

    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)
    name = models.TextField(blank=True)
    href = models.TextField(blank=True)
    email = models.TextField(blank=True)

    def __str__(self) -> str:
        """Return string representation of the publisher."""
        return self.name


class Feed(models.Model):
    """A RSS/Atom/JSON feed."""

    feed_url = models.URLField(unique=True)

    domain = models.ForeignKey(Domain, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)
    last_checked = models.DateTimeField(null=True, blank=True)
    active = models.BooleanField(default=True)

    # General data
    bozo = models.BooleanField()
    bozo_exception = models.TextField(blank=True)
    encoding = models.TextField(blank=True)
    etag = models.TextField(blank=True)
    headers = JSONField(null=True, blank=True)
    href = models.TextField(blank=True)
    modified = models.DateTimeField(null=True, blank=True)
    namespaces = JSONField(null=True, blank=True)
    status = models.IntegerField()
    version = models.CharField(max_length=255, blank=True)

    # Feed data
    author = models.TextField(blank=True)
    author_detail = models.ForeignKey(
        Author,
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="feeds",
    )

    cloud = JSONField(null=True, blank=True)
    contributors = JSONField(null=True, blank=True)
    docs = models.TextField(blank=True)
    errorreportsto = models.TextField(blank=True)
    generator = models.TextField(blank=True)
    generator_detail = models.ForeignKey(
        Generator,
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="feeds",
    )

    icon = models.TextField(blank=True)
    _id = models.TextField(blank=True)
    image = JSONField(null=True, blank=True)
    info = models.TextField(blank=True)
    info_detail = JSONField(null=True, blank=True)
    language = models.TextField(blank=True)
    license = models.TextField(blank=True)
    link = models.TextField(blank=True)
    links = JSONField(null=True, blank=True)
    logo = models.TextField(blank=True)
    published = models.TextField(blank=True)
    published_parsed = models.DateTimeField(null=True, blank=True)
    publisher = models.TextField(blank=True)
    publisher_detail = models.ForeignKey(
        Publisher,
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="feeds",
    )

    rights = models.TextField(blank=True)
    rights_detail = JSONField(null=True, blank=True)
    subtitle = models.TextField(blank=True)
    subtitle_detail = JSONField(null=True, blank=True)
    tags = JSONField(null=True, blank=True)
    textinput = JSONField(null=True, blank=True)
    title = models.TextField(blank=True)
    title_detail = JSONField(null=True, blank=True)
    ttl = models.TextField(blank=True)
    updated = models.TextField(blank=True)
    updated_parsed = models.DateTimeField(null=True, blank=True)

    def __str__(self) -> str:
        """Return string representation of the feed."""
        return f"{self.domain} - {self.title}"

    def get_fields(self) -> list:
        """Return the fields of the feed."""
        return [(field.name, field.value_from_object(self)) for field in Feed._meta.fields]


class Entry(models.Model):
    """Each feed has multiple entries."""

    feed = models.ForeignKey(Feed, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    modified_at = models.DateTimeField(auto_now=True)

    # Entry data
    author = models.TextField(blank=True)
    author_detail = models.ForeignKey(
        Author,
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="entries",
    )
    comments = models.TextField(blank=True)
    content = JSONField(null=True, blank=True)
    contributors = JSONField(null=True, blank=True)
    created = models.TextField(blank=True)
    created_parsed = models.DateTimeField(null=True, blank=True)
    enclosures = JSONField(null=True, blank=True)
    expired = models.TextField(blank=True)
    expired_parsed = models.DateTimeField(null=True, blank=True)
    _id = models.TextField(blank=True)
    license = models.TextField(blank=True)
    link = models.TextField(blank=True)
    links = JSONField(null=True, blank=True)
    published = models.TextField(blank=True)
    published_parsed = models.DateTimeField(null=True, blank=True)
    publisher = models.TextField(blank=True)
    publisher_detail = models.ForeignKey(
        Publisher,
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        related_name="entries",
    )
    source = JSONField(null=True, blank=True)
    summary = models.TextField(blank=True)
    summary_detail = JSONField(null=True, blank=True)
    tags = JSONField(null=True, blank=True)
    title = models.TextField(blank=True)
    title_detail = JSONField(null=True, blank=True)
    updated = models.TextField(blank=True)
    updated_parsed = models.DateTimeField(null=True, blank=True)

    def __str__(self) -> str:
        """Return string representation of the entry."""
        return f"{self.feed} - {self.title}"

    def get_fields(self) -> list:
        """Return the fields of the entry."""
        return [(field.name, field.value_from_object(self)) for field in Entry._meta.fields]
