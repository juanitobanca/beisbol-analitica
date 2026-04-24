"""Central JSON field extraction utility."""

from typing import Any, Callable

Dataset = dict[str, list[Any]]
Resolver = Callable[[dict | None, str], Any]


def extract_fields(node: dict | None, fields: list[str], dataset: Dataset, resolver: Resolver) -> None:
    """Iterate fields, call resolver(node, field), and append each result to dataset[field]."""
    for field in fields:
        try:
            value = resolver(node, field)
        except Exception:
            value = None
        dataset[field].append(value)


def nav(node: dict | None, field: str) -> Any:
    """Direct access: node.get(field)."""
    if node is None:
        return None
    return node.get(field)


def nav_id(node: dict | None, field: str | None = None) -> Any:
    """Extract the 'id' key from node."""
    if node is None:
        return None
    return node.get("id")


def nav_code(node: dict | None, field: str | None = None) -> Any:
    """Extract the 'code' key from node."""
    if node is None:
        return None
    return node.get("code")


def nav_name(node: dict | None, field: str | None = None) -> Any:
    """Extract the 'name' key from node."""
    if node is None:
        return None
    return node.get("name")


def nav_link(node: dict | None, field: str | None = None) -> Any:
    """Extract the 'link' key from node."""
    if node is None:
        return None
    return node.get("link")


def nav_description(node: dict | None, field: str | None = None) -> Any:
    """Extract the 'description' key from node."""
    if node is None:
        return None
    return node.get("description")
